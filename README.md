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

### Contribute

Contributions are always welcome!

### License

> The MIT License (MIT)
>
> Copyright (c) 2020 - 2021 Rui Costa.
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
