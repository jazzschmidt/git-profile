# About

Keeping track of the correct git configuration can be a hassle,
when working with several repositories, e.g. with different
GPG-Keys, user names and email addresses. By using this profile
management addon, such configurations can be easily applied.

?> By default, it prevents any commit when no profile is explicitly
set and reminds you to do so. This way, you will never again
accidentally commit with your private e-mail to a corporate repo.

## Installation
The addon is installed by running an installer script, that you
can run via your shell. Prepend the version you want to install.

```bash
$ RELEASE=v1.0 bash -c "$(curl -fsSL https://raw.github.com/jazzschmidt/git-profile/master/install.sh)"
```

---

Made with :heart: at [GitHub](https://github.com/jazzschmidt/git-profile)

<small>Copyright © 2021 by Carsten Schmidt</small>
