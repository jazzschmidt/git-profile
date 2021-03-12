# Configuration

This is an overview of the used git configurations.

Configuration | Level | Effect
------------- | ----- | ------
`profile.path` | global | Path where profiles are stored, defaults to `$HOME/.git/profiles`.  
`profile.enabled` | global/local | When set to `true` the plugin will prevent any commits without an active profile.
`profile.name` | local | Name of the currently applied profile.
`core.hookspath` | global | Path where global git hooks are stored, defaults to `$HOME/.git/hooks` if not previosly defined.
`core.editor` | global | The standard editor for commit messages, that will also be used to edit profiles.

---

Made with :heart: at [GitHub](https://github.com/jazzschmidt/git-profile)

<small>Copyright © 2021 by Carsten Schmidt</small>
