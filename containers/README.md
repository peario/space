# Containers

Here you'll find Dockerfiles and other container-related files and configurations.
Their main purpose is to test the install script, `<repo root>/install.sh`, but
also more generally used to test the entire config in various environments.

## Environments

The currently configured environments are:

- `Alpine 3.20.3`
- `Arch Linux (latest)`
- `Debian 12 (bookworm)`
- `Fedora 40`
- `Ubuntu 22.04`

There's no real way of simulating WSL (Windows Subsystem for Linux) within a Dockerfile
but `Ubuntu 22.04` is the default distro installed. As such it's the closest way
to test if `install.sh` works aside from on a Windows machine.

## Installation

The Dockerfiles are supposed to only pre-install the required programs to run `install.sh`.
The script itself is intended to install those programs required to kick-start
the Nix config.

## Usage

There's a couple steps to running the containers. These instructions assume you're
running from the project root. If you're running from within `./containers` or somewhere
else, simply remove `containers/` or adjust the path according to your environment
for each instruction when running them.

> [!TIP]
> When running `Dockerfile.arch` on macOS for example, it might terminate early.
> To resolve this, prepend `DOCKER_DEFAULT_PLATFORM=linux/amd64` to the docker command.
>
> Example:
>
> ```bash
> DOCKER_DEFAULT_PLATFORM=linux/amd64 docker build \
>   -f containers/Dockerfile.arch \
>   -t space-installer-arch .
> ```

Firstly to build the container use the following command where `arch` (in `space-arch`)
can be replaced with whichever distro of Dockerfile is available.

```bash
docker build -f containers/Dockerfile.arch -t space-arch .
```

Then to start the container run the following command where, like above, `arch`
can be replaced with whichever distro of Dockerfile is available. This command will
delete the container once done (due to the `--rm` flag).

```bash
docker run --rm space-arch /bin/bash
```

> [!TIP]
> Try following the syntax of `Dockerfile.[distro]` and `space-[distro]`, where `[distro]`
> is any of the available Dockerfiles. This makes it easier to figure out which unix
> distro the container is. Just an idea though.

### Quick run

> [!NOTE]
> For the following two codeblocks where the `-it` (interactive) flag is present
> at `docker run`, the command wont trigger the run of `./install.sh`.
>
> So you'll have to run `./install.sh` manually.

I personally use the following command for a quick, interactive and temporary testing
environment of `install.sh`. Notice the use of `SPACE_DISTRO="arch"`, the contents
of `SPACE_DISTRO="..."` can be changed to whichever distro of Dockerfile is available
within `./containers`.

```bash
SPACE_DISTRO="arch" && \
  docker build -f containers/Dockerfile.${SPACE_DISTRO} -t space-${SPACE_DISTRO} . && \
  docker run -it --rm space-${SPACE_DISTRO} /bin/bash
```

If Docker complains about `no match for platform in manifest: not found` for the
`arch` Dockerfile (or any other Dockerfile), try the following command:

```bash
SPACE_DISTRO="arch" && \
  DOCKER_DEFAULT_PLATFORM=linux/amd64 docker build -f \
  containers/Dockerfile.${SPACE_DISTRO} -t space-${SPACE_DISTRO} . && \
  DOCKER_DEFAULT_PLATFORM=linux/amd64 docker run -it --rm space-${SPACE_DISTRO} /bin/bash
```
