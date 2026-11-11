The `~/.ssh/config.d/` directory is intended to allow the usually monolithic `./config` file to be split up.
The individual files can then be added to dotfiles version control on a case-by-case basis.

Examples:

```
# Hosts that may fall back to password auth if key auth fails.
Host password-hosts
    PreferredAuthentications publickey,password,keyboard-interactive

# Hosts that only use a local key file
Host password-hosts
    IdentityAgent none          # don't use 1password (or any other agent)
    IdentityFile path/to/file   # use the key file specified
```
