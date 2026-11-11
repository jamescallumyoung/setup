# Post Setup: Additional Manual Steps

## On macOS, set Terminal.app's default shell

macOS's default terminal, Terminal.app, may use a different shell.
To change this, open Terminal.app, press `SPACE`+`.` and set _General_ -> _Shells open with_ to "Default login shell".

## Passwords

These dotfiles don't handle passwords. Passwords for most services are managed by 1password, my password manager of choice.

The 1password application should be downloaded directly from the [1password website](https://1password.com) for security reasons.
Once installed, follow the sign in flow as usual.

Once signed in, the 1password browser extension and CLI tools can also be installed

## SSH Keys

This repo doesn't handle SSH keys. You'll need to set them up yourself for every service that uses them, including git.

If the 1password application has been installed, [SSH integration](https://developer.1password.com/docs/ssh) can be enabled.
This allows the 1password app to function as an identity provider for the SSH agent.

The 1password ["get started"](https://developer.1password.com/docs/ssh/get-started/) should be followed as set up instructions vary by platform.

## Files with secrets

This repo doesn't handle files that include secrets, such as `~/.npmrc`. You'll need to create these yourself.

Suggested files:
- `~/npmrc`
- kube configs

Note: 1password offers plugins for many developer tools.
If the 1password application is installed, you should explore whether one of these plugins can be used.

Note: the 1password CLI tool can be installed to access secrets stored in 1password from the shell.

## Github login

### Using 1password to authenticate with GitHub (preferred)

If the 1password application is installed, and the SSH integration (see above) has been enabled, authentication with Github can be done with 1password.

### Using an SSH key file

Generate a new SSH key (with `ssh-keygen -t ed25519 -a 100` -C "A_GOOD_KEY_NAME_HERE"`) for use with GitHub, and upload it to GitHub via their website.

Then, add the following to `.ssh/config`:

```
Host github.com
 HostName github.com
 IdentityFile ~/.ssh/NAME_OF_YOUR_NEW_KEY
```

**Updating the dotfiles repo login:**

If you want to be able to commit to the dotfiles repo from this device, you'll need to change the remote from HTTPS to SSH.
