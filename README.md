# Git Profile Management

Keeping track of the correct git configuration can be a hassle,
when working with several repositories, e.g. using different
GPG-Keys, user names and email addresses. By using this profile
management addon, such configurations can be easily applied.

By default, it prevents any commit when no explicit profile is
set and thus prevents horrendous rebasings.

## Usage
### Create a Profile
The create subcommand creates a new profile with the default
username and email from your global git configuration and can be
configured interactively.

```
$ git profile create corporate
user name [John Doe]: J. Doe
user e-mail [john.doe@example.com]: doe@acme.com
description [J. Doe <john.doe@example.com>]: My corporate profile 
```

### List the Profiles
```
$ git profile list
corporate - My corporate profile
```

### Applying a Profile
When committing from a repository without a configured profile,
the commit will be cancelled.
```
$ git commit -m "Adds documentation"
FATAL: No profile set, aborting commit.
See `git profile help` for further help or use `git profile disable` to disable profile checking.
```

Explicitly apply a profile to let the commit pass:
```
$ git profile apply corporate
```

