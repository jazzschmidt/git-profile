# Git Profile Management

Keeping track of the correct git configuration can be a hassle,
when working with several repositories, e.g. with different
GPG-Keys, user names and email addresses. By using this profile
management addon, such configurations can be easily applied.

By default, it prevents any commit when no profile is explicitly
set and reminds you to do so. This way, you will never again
accidentally commit with your private e-mail to a corporate repo.

## Installation
The addon is installed by running an installer script, that you
can run via your shell. Prepend the version you want to install.

```bash
$ RELEASE=v1.0 bash -c "$(curl -fsSL https://raw.github.com/jazzschmidt/git-profile/master/install.sh)"
```


## Usage

After installation, you should create at least one profile and
apply it to the repository you're currently working on.

### Create a Profile
The `create` subcommand creates a new profile with the default
username and email from your global git configuration and can be
configured interactively.

```bash
$ git profile create corporate
user name [John Doe]: J. Doe
user e-mail [john.doe@example.com]: doe@acme.com
description [J. Doe <john.doe@acme.com>]: My corporate profile
```

When committing from a repository without a profile applied,
the commit will be cancelled from now on.

```bash
$ git commit -m "Fixes bug #71"
FATAL: No profile set, aborting commit.
See `git profile help` for further help or use `git profile disable` to disable profile checking.
```

### Applying a Profile
The `apply` subcommand applied the configuration from a profile
to your local git configuration and permits committing again.

```bash
$ git profile apply corporate
```

To ensure which profile is currently applied, invoke `git profile`
without any argument.

---

Made with :heart: at [GitHub](https://github.com/jazzschmidt/git-profile)
