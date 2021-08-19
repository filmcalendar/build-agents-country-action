#!/usr/bin/env bash

# 1. starts each agent in a country every 10secs
# 2. commits and dispatches all data to GIT_REPO_DATA

# git credentials are env secrets on docker run
git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "${GIT_USER}"

repo="data-${FC_COUNTRY}"
auth="$GIT_USER:$GIT_PASSWORD"

function pull_repo () {
  message=$(curl --silent --user "$auth" "https://api.github.com/repos/filmcalendar/$repo" | jq '.message')

  if [[ "$message" = *"Not Found"* ]]; then
    curl \
      -X POST \
      --silent \
      --output /dev/null \
      --user "$auth" \
      --header "Accept: application/vnd.github.baptiste-preview+json" \
      https://api.github.com/repos/filmcalendar/data-template/generate \
      --data "{\"owner\":\"filmcalendar\",\"name\":\"${repo}\"}"

    git clone "https://${GIT_PASSWORD}@github.com/filmcalendar/${repo}" data

    cd data || exit;

    # set current country on actions and readme
    sed -i "s/__FC_COUNTRY__/$FC_COUNTRY/g" .github/workflows/broadcast.yml 
    sed -i "s/__FC_COUNTRY__/$FC_COUNTRY/g" README.md

    # create CSV branch
    git checkout -b csv
    git push origin HEAD

    # create JSON branch
    git checkout -b json
    git add .
    git commit -m "chore: replace country"

    cd .. || exit;
  else
    git clone "https://${GIT_PASSWORD}@github.com/filmcalendar/${repo}" data
  fi
}

function finish_new_repo_setup () {
  default_branch=$(curl --silent --user "$auth" "https://api.github.com/repos/filmcalendar/$repo" | jq '.default_branch')

  if [[ "$default_branch" = *"main"* ]]; then
    # set default branch to json
    curl \
      -X PATCH \
      --silent \
      --output /dev/null \
      --user "$auth" \
      "https://api.github.com/repos/filmcalendar/${repo}" \
      --data "{\"default_branch\":\"json\"}"

    # delete main branch
    cd data || exit;
    git push origin --delete main
    cd .. || exit;
  fi
}

function commit_data () {
  today=$(date -u +"%Y-%m-%d")

  cd data || exit;

  git checkout json
  git add .
  git commit -m "dispatch: ${today}"
  git push origin HEAD

  cd .. || exit;
}

echo "Once upon a time..."

# checks if data repo exists, if not creates
pull_repo

export GIT_REPO_SRC=filmcalendar/agents-${FC_COUNTRY}

# list agents found on country app
agents=$(node fc-agent.js list "$@")
IFS=',' read -r -a agents_list <<< "$agents"
for agent in "${agents_list[@]}"; do
  echo "fc-agent scrape -a ${agent}"
  mkdir -p "data/${agent}"
  # spawn a new agent every 10secs
  node fc-agent.js scrape -a "${agent}" > "data/${agent}/data.json" &
  sleep 10
done

wait

commit_data

finish_new_repo_setup

echo "The End."

