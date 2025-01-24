---
title: Deploying on Fly.io
subtitle: Run Gleam all over the world. No ops required. 
layout: page
redirect_from:
  - "/deploying-gleam-on-fly/index.html"
---

[Fly.io](https://fly.io) is a convenient and easy to use deployment platform
with a generous [free allowance](https://fly.io/docs/about/pricing/). They were
also a sponsor of the Gleam project, thank you Fly!

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
import gleam/bytes_tree
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
  let body = bytes_tree.from_string("Hello, Joe!")
  Response(200, [], mist.Bytes(body))
}
```

Now we have a web application that listens on port 8080 and can be started with
`gleam run`.


## Add a Dockerfile

We can use Fly's support for containers to build the application and prepare it
for deployment.

Add a file named `Dockerfile` with these contents:

```dockerfile
FROM ghcr.io/gleam-lang/gleam:v1.5.1-erlang-alpine

# Add project code
COPY . /build/

# Compile the project
RUN cd /build \
  && gleam export erlang-shipment \
  && mv build/erlang-shipment /app \
  && rm -r /build

# Run the server
WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]
```


## Set up the Fly.io CLI

Follow the instructions [here](https://fly.io/docs/getting-started/installing-flyctl/)
to install Flyctl, the command-line interface for the Fly.io platform.

Once installed use the CLI to sign up (or log in if you already have a Fly.io
account).

```sh
fly auth signup
# OR
fly auth login
```

Fly's free allowance is enough to run the Gleam application but new accounts
need a payment card to be added, to prevent people from abusing Fly's free
service.


## Deploy the application

From within the project use the Fly CLI to create and run your application on
their platform.

```
flyctl launch
```

The CLI will ask you a series of questions:

- What the application should be named.
- What Fly organisation should the application belong to.
- What region the application should be deployed to.
- Whether you would like a PostgreSQL database to go with the application.

Once you have answered these it will build the application using the docker
file. Once deployed you can open it in a web browser by running `flyctl open`.

To deploy future versions of the application run `flyctl deploy` after saving
any changes to the source code.
