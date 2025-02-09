---
title: Deploying to a Linux server
subtitle: Run Gleam on a server from any provider
layout: page
---

This guide will take you through the process of deploying a Gleam backend web
application to a single Linux server. The application will be run by systemd in
a Linux container, and [Caddy](https://caddyserver.com/) will be used to handle
HTTPS.

## Provision your server

We will be using the most recent LTS version of Ubuntu in this tutorial. You can
use other Linux distributions but there may be slight differences in commands or
additional steps you need to undertake to deploy your application.

If you do not have a server already there are a number of companies who can
provide you one for a small monthly fee. You can use [Gleam's referral link for
Vultr](https://www.vultr.com/?ref=9694426) if you do not already have a
preferred server provider.

We will be using an amd64 server with 1 shared virtual CPU and 1 GB of memory.
You can use a smaller server if you wish, but at least 250MB of memory is
recommended. If your application is to receive a lot of traffic or perform
expensive computation then you may wish to upgrade to a more powerful server.
Be sure to add your SSH public key to the server when creating it. SSH should
never be used with passwords, it is insecure.

## Configure your DNS

Once you have your server add an A record pointing to the public IPv4 address of
your server, which can likely be found in the web console of your server
provider.

If your server has a public IPv6 address add an AAAA record for the same domain
to that address.

We will be used the domain `example.gleam.run` for the rest of this tutorial. Be
sure to replace this with your domain.

## Prepare your application

Ensure you application is listening on `0.0.0.0`. If you're using Mist or Wisp
you can do this with the `mist.bind` function, as shown here.

```diff
  let assert Ok(_) =
    wisp_mist.handler(handle_request, secret_key_base)
    |> mist.new
+   |> mist.bind("0.0.0.0")
    |> mist.port(8000)
    |> mist.start_http
```

Take note of what port your application is starting on. We will be using port
8000 for the rest of this guide.

## Add a Dockerfile

Add a file to the base of your repository called `Dockerfile` with these
contents:

```dockerfile
FROM erlang:27.1.1.0-alpine AS build
COPY --from=ghcr.io/gleam-lang/gleam:v1.8.0-erlang-alpine /bin/gleam /bin/gleam
COPY . /app/
RUN cd /app && gleam export erlang-shipment

FROM erlang:27.1.1.0-alpine
RUN \
  addgroup --system webapp && \
  adduser --system webapp -g webapp   
COPY --from=build /app/build/erlang-shipment /app
WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]
```

Edit the Erlang and Gleam versions on the 2 `FROM` lines and the first `COPY`
lines to be the ones you want to use.

If your application normally needs additional arguments to `gleam run` to start
then edit the `CMD ["run"]` line to include them.

If you have other requirements (for example, if you are using NIFs and need a C
compiler) you will may need to edit this file further to install the required
packages.

## Build your container on CI

We will be using GitHub actions to build and publish the container image to the
GitHub container registry using docker each time a git tag is pushed to the repo.

Create a file at `.github/workflows/build-container.yml` with these contents:

```
name: Build container image
on:
  push:
    tags:

jobs:
  push:
    runs-on: ubuntu-latest
    permissions:
      packages: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Build image
        run: docker build . --file Dockerfile --tag webapp

      - name: Log in to registry
        run: echo "${{ secrets.GITHUB_TOKEN }}" | docker login ghcr.io -u ${{ github.actor }} --password-stdin

      - name: Push image
        run: |
          IMAGE_ID=ghcr.io/gleam-run/example
          IMAGE_ID="$IMAGE_ID":$(echo "${{ github.ref }}" | sed -e 's,.*/\(.*\),\1,')
          docker tag webapp $IMAGE_ID:$VERSION
          docker push $IMAGE_ID:$VERSION
```

Edit `IMAGE_ID=ghcr.io/gleam-run/example` with the name of your GitHub
repository. If you repository is at `https://github.com/wibble/wob` it should be
`IMAGE_ID=ghcr.io/wibble/wob`.

After you have pushed these changes push a new git tag to GitHub. This will
trigger the workflow, which you can see in your GitHub repo's "Actions" tab.

```
git tag production
git push --tags
```

We're using the tag `production`, but you can use any tag name you want.

## Secure the SSH service

SSH into your server using the domain name you configured earlier.

```
ssh root@example.gleam.run
```

If you are unable to SSH in check you have the correct username and the domain,
and are using the same SSH key you added to the server when creating it.

Permitting SSH login with a password is a security risk, so ensure it is
disabled. Open `/etc/ssh/sshd_config` in a text editor.

```
nano /etc/ssh/sshd_config
```

Search for the line `#PasswordAuthentication yes` and edit it to be
`PasswordAuthentication no`. Notice that it does not have a `#` at the start,
while before it may have had one.

Restart the SSH service.

```
systemctl restart ssh
```

## Secure the network with a firewall

The server should only be accessible over HTTP, HTTPS, and SSH, so we will
configure the server to block anything else.

```
ufw allow ssh
ufw allow http
ufw allow https
ufw enable
```

`ufw` may prompt for confirmation when enabling it. Accept by entering `y`.

## Enable automatic Ubuntu security updates

```
apt install --yes unattended-upgrades
systemctl start unattended-upgrades
```

If you are not using Ubuntu Linux there may be some other way to do this for
your distribution.

## Install Caddy and Podman

Caddy is the reverse proxy that we will use to provision TLS certificates and
handle HTTPS traffic. Podman is the container engine we will use to run the
application container.

Install them both using `apt` (or the equivalent if you decided not to use
Ubuntu Linux).

```
apt install --yes podman caddy
```

After this finishes if you visit your domain in a web browser you should see the
default Caddy home page.

## Define your Podman container

If you are using a private GitHub repository you will need create a GitHub
personal access token with `read:packages` permissions in the GitHub security
settings, and then use it to log in on the server.

```
echo "YOUR_GITHUB_PAT" | podman login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

Create a Podman systemd container file.

```
nano /etc/containers/systemd/webapp.container
```

Add these contents, changing `Image=ghcr.io/gleam-lang/example:production`
for the name of your GitHub repository.

```ini
[Unit]
Description=My Gleam web application
After=local-fs.target

[Container]
Image=ghcr.io/gleam-lang/example:production
PublishPort=8000:8000

[Install]
WantedBy=multi-user.target default.target
```

You may want to edit the `[Container]` section to further configure your
container.

If your application is listening on a different port then edit the `8000`s to
the correct port.

Environment variables can be added using the `Environment=KEY=value` syntax.

Directories on the server can be made accessible to the application inside the
container using the ` Volume=/path/on/serevr:/path/in/container:rw,z` syntax.

See the [Podman systemd](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html)
documentation for more detail.

## Start the container

The `.container` file creates a systemd service, so `systemctl` can be used to
manage the application container.

Reload the systemd daemon to load the latest version of the file, and then start
the service.

```
systemctl daemon-reload
systemctl start webapp
```

The status of the systemd service can be viewed with `systemctl status webapp`.

Check that service is handling HTTP requests by making a request to `localhost`
on the port that your application is listening on.

```
curl -I localhost:8000
```

## Configure Caddy to send traffic to the application

Replace the contents of `/etc/caddy/Caddyfile` with this, making sure to replace
the domain and port with the ones you are using. Keep `localhost` the same.

```caddy
example.gleam.run {
        reverse_proxy localhost:8000
}
```

Restart the Caddy service to pick up these changes.

```
systemctl restart caddy
```

Open your domain in your web browser. You should see your web site, complete
with HTTPS!

## Future deployments and maintenance

Pushing a new tag to the GitHub repository will cause a new container image to
be built. You can force-push a tag to a new location to create a new container
with the same name.

If you have changed the `.container` file you can reload the daemon to pick up
the changes and then restart the service to replace the container with one using
the new configuration.

```
systemctl daemon-reload
systemctl restart webapp
```

The logs can be viewed with `journalctl -xeu webapp`.
