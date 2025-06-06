# How to release a version

## Before the release

First, make sure that all the issues from the current milestone are done.
Also, see if you can fix any minor bugs or small technical debt issues first: that's always a good thing to do.

Before releasing a version, you should at least update the dependencies to their latest patch versions.

## Start the release process

There's a `make` command to release a new version:

```console
$ git switch -c release/1.0.0
$ make release VERSION=1.0.0
```

It will write the version number in the file [`package.json`](/package.json).

## Generate the changelog

Next, the command will open a text editor so you can edit the changelog.

Generate the list of messages to include in the changelog with:

```console
$ git log --first-parent --pretty=format:'- %s (%h)' --abbrev-commit $(git describe --abbrev=0 --tags)..
```

You might want to create a git alias in your `.gitconfig`.

Organize the commits in the following sections:

- Security (`sec:` prefix)
- New (`new:` prefix)
- Improvements (`imp:` prefix)
- Bug fixes (`fix:` prefix)
- Documentation (`doc:` prefix)
- Developers (`dev:` prefix)

Feel free to rename the commit messages if you think they aren't clear enough (at least to remove the prefixes).
If several commits refer to a single important item, you can merge them into a single message, and list their references in parentheses.
You can also remove messages if they don't bring value to the changelog (that's the purpose of the `misc:` prefix for instance).

Finally, add links to GitHub commits on the hashes (e.g. `[ffbfaa6](https://github.com/flusio/flus-design/commit/ffbfaa6)`).

## Complete the release

Once the changelog is complete, close your editor and the command will commit your changes.

Push your branch to GitHub:

```console
$ git push -u origin HEAD
```

And open a pull request.

Once merged, don't forget to push the version tag:

```console
$ git push --tags
```

## Publish on GitHub

Once the version tag is pushed, you must publish the version on GitHub:

1. start [a new release](https://github.com/flusio/flus-design/releases/new);
2. choose the tag corresponding to the new version;
3. name the release to the version tag (e.g. “Flus Design 1.0.0”);
4. copy the content of the changelog corresponding to the version;
5. you should adapt the title levels in Markdown (i.e. titles of level 3 `###` must be changed by titles of level 2 `##`);

## Publish on NPM

Make sure you've setup a NPM `authToken` in the `.npmrc`.
If not done yet, execute:

```console
$ echo '//registry.npmjs.org/:_authToken=<YOUR TOKEN>' > .npmrc
```

Note that you can generate a (classic) "publish" token on [npmjs.com](https://www.npmjs.com), under the "Access tokens" menu.

Then, publish the version on NPM with:

```console
$ make publish
```

## Fix mistakes made during the release

You may realize you made a mistake (e.g. commited a file which should not, a typo in the changelog) during the release process.
If the pull request is not merged yet, you still can fix your error.

First, reset the last commit:

```console
$ git reset HEAD^
```

Delete the tag (replace `<VERSION_NUMBER>` by the version you're releasing):

```console
$ git tag -d <VERSION_NUMBER>
$ # and if you pushed the tag on GitHub
$ git push -d origin <VERSION_NUMBER>
```

Then, fix your error, and re-run the release command:

```console
$ make release VERSION=<VERSION_NUMBER>
```

If you already pushed your commits on GitHub, force push your changes:

```console
$ git push --force-with-lease
```
