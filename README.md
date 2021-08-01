# @filmcalendar/build-agents-action

Builds a country's agent docker image.

## Configuration

**Action inputs**

|                  | default |
| ---------------- | ------- |
| `country`        |         |
| `githubPassword` |         |

## Usage

```yaml
name: Release
on:
  workflow_dispatch:
  release:
    types:
      - created

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: yarn install --frozen-lockfile
      - run: yarn build
      - name: Build docker image
        uses: filmcalendar/build-agents-action@v1
        with:
          country: uk
          githubPassword: ${{ secrets.GIT_PASSWORD }}
```

## Contribute

Contributions are always welcome!

## License

MIT
