# Setup the development environment

Make sure to install [Docker](https://docs.docker.com/get-docker/).
Otherwise, make sure the `npm` command is available and prepend all the commands of this file by `NODOCKER=true`.

Install the dependencies:

```console
$ make install
```

Build the assets under the `dev_build` folder and watch their changes with esbuild:

```console
$ make watch
```

Build the assets for production under the `dist` folder with:

```console
$ make build
```

## Linters

Run the linters with:

```console
$ make lint
```
