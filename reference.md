# Subcommand Reference

Overview of all available `git profile` subcommands. Whenever any
subcommand that needs a profile as an argument (e.g. `edit`) is
invoked without such, an interactive menu will ask for it.

## Show active Profile
When invoked without argument, `git profile` shows the
current applied profile, if any, or displays an error.

```bash
$ git profile
corporate
````

## List Profiles
The `list` subcommands shows all available profiles along
with their description.

```bash
$ git profile list
default - John Doe <john.doe@example.com>
corporate - J. Doe <j.dow@acme.com>
```

## Create a Profile
The `create` subcommand creates a new profile with the default
username and email from your global git configuration and can be
configured interactively. When no name argument is passed, it
asks you to type it in. To further customize the profile, see
[Edit a Profile](#edit-a-profile).

```bash
$ git profile create
Profile name: corporate
user name [John Doe]: J. Doe
user e-mail [john.doe@example.com]: doe@acme.com
description [J. Doe <john.doe@acme.com>]: My corporate profile
```

## Edit a Profile
The `edit` subcommand opens an editor to directly edit a profile
configuration, e.g. with a custom SSH- or GPG-Key.
If the git config `core.editor` is set, that editor
is used, otherwise the `EDITOR` variable can define a program or,
lastly, an editor such as `nano` or `vim` will be used. 

```bash
# open `corporate` with atom
$ EDITOR=$(which atom) git profile edit corporate
```

## Remove a Profile
The `remove` subcommand permanently removes a profile.

!> This does not affect the current repository configuration (see
[Reset a Repository](#reset-a-repository)).

```bash
$ git profile remove corporate
Removed profile coprorate
```

## Apply a Profile
The `apply` subcommand copies all configurations of the given profile
into the repositories local git configuration and allows the commits
to pass the profile check.

```bash
$ git profile apply corporate
```

## Reset a Repository
The `reset` subcommand *removes all configurations* from the local git
configuration, which have been defined in the profile.

!> Even manually changed configurations are removed.

```bash
$ git profile 
```

## Enable Profile Checking
If you previously disabled profile checking or disabled it globally, the
`enable` subcommand activates it again.

```bash
$ git profile enable
```

## Disable Profile Checking
The `disable` subcommand disables profile checking for the current repository.

```bash
$ git profile disable
```

## Help
The `help` subcommand shows a short description of `git-profile` and lists
all subcommands.

```bash
$ git profile help
Git Profile Management - applies git configurations from custom profile files.

DESCRIPTION
    In the first synopsis form, the current active profile will be printed to stdout if any. In the second synopsis form,
    different profiles can be managed. If the [profile] parameter is skipped, a interactive menu will be displayed that
    shows further details on a profile, such as the used user name and E-Mail or a custom description.

SYNOPSIS:
    git profile
    git profile subcommand [profile]

SUBCOMMANDS:
    list              Lists available profiles
    create [profile]  Creates a new profile
    edit [profile]    Edits a profile
    remove [profile]  Removes a profile
    apply [profile]   Applies a profile configuration
    reset             Resets to default configuration
    disable           Disables profile checking before committing changes
    enable            Prevents commits without any applied profile
    help              Shows this help
```

---

Made with :heart: at [GitHub](https://github.com/jazzschmidt/git-profile)

<small>Copyright © 2021 by Carsten Schmidt | Licensed under MIT License</small>
