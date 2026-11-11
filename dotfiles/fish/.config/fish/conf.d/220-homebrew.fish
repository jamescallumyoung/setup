
# if homebrew is installed, enable it

if string match -q Darwin (/usr/bin/uname)
    if command -q /opt/homebrew/bin/brew # apple silicon
        /opt/homebrew/bin/brew shellenv | source

    else if command -q /usr/local/bin/brew # intel macOS
        /usr/local/bin/brew shellenv | source

    end

else if string match -q Linux (/usr/bin/uname)
    if command -q /home/linuxbrew/.linuxbrew/bin/brew # linuxbrew
        /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
    end

end

if command -q brew
    # disable hints in homebrew, because they're noisy
    # these most often show whenever an automated action runs, and just inform us how to disable the automation
    set -gx HOMEBREW_NO_ENV_HINTS 1
end
