# Introduction

## About
Keeping track of the correct git configuration can be a hassle,
when working with several repositories, e.g. with different
GPG-Keys, user names and e-mail addresses. By using this profile
management addon, such configurations can be easily applied.

?> By default, it prevents any commit when no profile is explicitly
set and reminds you to do so. This way, you will never again
accidentally commit with your private e-mail to a corporate repository.

## Features
There are a few `git profile` tools around, which all do a great job.
This tool stands out with these features:

- git cli integration
- commit prevention via hook
- interactive profile selection
- convenient installation
- runs as a bash script
- not limited to `user.name` and `user.email` configuration

## Installation
The addon is installed with an installer script, that you
can run via your shell. Simply prepend the version you want to install.

```bash
$ RELEASE=v1.0 bash -c "$(curl -fsSL https://raw.github.com/jazzschmidt/git-profile/master/install.sh)"
```

When committing from a repository without a profile applied,
the commit will be cancelled from now on.

```bash
$ git commit -m "Fixes bug #71"
FATAL: No profile set, aborting commit.
See `git profile help` for further help or use `git profile disable` to disable profile checking.
```

---
<div style="text-align: center;">

Made with :heart: at [GitHub](https://github.com/jazzschmidt/git-profile)

<small>Copyright © 2021 by Carsten Schmidt | Licensed under [MIT License](https://github.com/jazzschmidt/git-profile/blob/master/LICENSE)</small>

</div>
