
# if fnm is installed, enable it

if string match -q Darwin (/usr/bin/uname)
    fnm env --use-on-cd --version-file-strategy recursive --corepack-enabled --resolve-engines --shell fish | source
    
else if string match -q Linux (/usr/bin/uname)
    set -q XDG_DATA_HOME; or set XDG_DATA_HOME $HOME/.local/share
    fish_add_path $XDG_DATA_HOME/fnm

    fnm env --use-on-cd --version-file-strategy recursive --corepack-enabled --resolve-engines --shell fish | source

end
