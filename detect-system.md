## detect system

example of how to detect what system we're running on

```shell

# What OS are we running?
if [[ $(uname) == "Darwin" ]]; then
    source "$ZSH_CUSTOM"/os/mac.zsh

elif command -v freebsd-version > /dev/null; then
    source "$ZSH_CUSTOM"/os/freebsd.zsh

elif command -v apt > /dev/null; then
    source "$ZSH_CUSTOM"/os/debian.zsh

else
    echo 'Unknown OS!'
fi

# Do we have systemd on board?
if command -v systemctl > /dev/null; then
    source "$ZSH_CUSTOM"/os/systemd.zsh
fi

# Ditto Kubernetes?
if command -v kubectl > /dev/null; then
    source "$ZSH_CUSTOM"/os/kubernetes.zsh
fi

```
