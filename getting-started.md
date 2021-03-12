## Getting started

After installation, you should create at least one profile and
apply it to the repository you're currently working on.

### Creating a Profile
The `create` subcommand creates a new profile with the default
username and email from your global git configuration and can be
configured interactively. To further customize the profile, see
[Edit a Profile](/reference#edit-a-profile).

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

<small>Copyright © 2021 by Carsten Schmidt | Licensed under MIT License</small>
