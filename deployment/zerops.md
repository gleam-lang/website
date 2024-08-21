---
title: Deploying on Zerops
subtitle: Run Gleam with Ease. Zero Ops required.
layout: page
redirect_from:
  - "/deploying-gleam-on-zerops/index.html"
---

[Zerops](https://zerops.io) is a dev-first cloud platform and easy to use and economically viable deployment platform with [free $15 credits](https://zerops.io/#pricing) no credit card required. You can get $50 more after adding $10 into your zerops account.

Zerops' free allowance of $15 is enough to deploy any type of full stack project without any credit card.

## Prepare an application

We will need a Gleam backend web application to deploy in this guide, so first
we will make one. If you already have an application skip to the next section.

Create a new Gleam project and add the required dependencies.

```sh
gleam new my_web_app
cd my_web_app
gleam add mist gleam_http gleam_erlang
```

Open up `src/my_web_app.gleam` and replace the contents with this code that
defines a micro web application.

```gleam
import mist
import gleam/erlang/process
import gleam/bytes_builder
import gleam/http/response.{Response}

pub fn main() {
  let assert Ok(_) =
    web_service
    |> mist.new
    |> mist.port(8080)
    |> mist.start_http
  process.sleep_forever()
}

fn web_service(_request) {
  let body = bytes_builder.from_string("Hello, Zerops!")
  Response(200, [], mist.Bytes(body))
}
```

Now we have a web application that listens on port 8080 and can be started with
`gleam run`.

## Gleam x Zerops Quickrun

Want to test Gleam on Zerops without installing or setting up anything? Use the Zerops Gleam recipe [Zerops x Gleam](https://github.com/zeropsio/recipe-gleam) using the project import yaml mentioned below or [Deploy with a Single Click](https://app.zerops.io/recipe/gleam).

```yaml
project:
  name: recipe-gleam
services:
  - hostname: app
    type: gleam@1
    enableSubdomainAccess: true
    buildFromGit: https://github.com/zeropsio/recipe-gleam
```

## Manual Project Creation

Projects and services can be added either through a [Project add](https://app.zerops.io/dashboard/project-add) wizard or imported using a yaml structure:

```yaml
# see https://docs.zerops.io/references/import for full reference
project:
  name: recipe-gleam
services:
  - hostname: app
    type: gleam@1
    enableSubdomainAccess: true
```

This will create a project called `recipe-gleam` with a Zerops Static service called `app`.

## Add Zerops.yml

```yml
zerops:
  - setup: app
    build:
      base: gleam@1
      buildCommands:
        - gleam export gleam-prod
      deployFiles: /
    run:
      base: gleam@1
      ports:
        - port: 8080
          httpSupport: true
      start: ./gleam-prod/entrypoint.sh run
```

## Set up the Zerops CLI

Follow the instructions [here](https://docs.zerops.io/references/cli)
to install zCli, the command-line interface for the Zerops.io platform.

#### Windows

```
irm https://zerops.io/zcli/install.ps1 | iex
```

#### Linux/MacOS

```
curl -L https://zerops.io/zcli/install.sh | sh
```

#### Npm (Package Manager)

```
npm i -g @zerops/zcli
```

Once installed use the CLI to connect to your Zerops Account:

---

## Authentication & Deploying

- Open [Settings > Access Token Management](https://app.zerops.io/settings/token-management) in the Zerops app and generate a new access token.

- Log in using your access token with the following command:

```sh
zcli login <token>
```

- Navigate to the root of your app in terminal (where zerops.yml is located) and run the following command to trigger the deploy (The CLI will ask you to choose the project & service):

```sh
zcli push
```

This will deploy the package to Zerops service and after it successfully deploys you can test it with the subdomain url.

You can also setup git based deployments by connecting the app service with your GitHub / GitLab repository from inside the service detail.
