# Sets the OS, arch, and package manager convenience variables. These are used throughout the configs.
# $os and $arch are strings.
# $pm is an array containing the names of the package managers (commands) available.
# note: $pm only includes package managers we explicitly check for.

os=$(uname -s)
arch=$(uname -m)
pm=()

# set pm

[[ $(command -v apt) ]] && pm+=("apt")
# ...add other linux package managers here

# for homebrew, we check for a variable, as `brew` will not be in the path yet
[[ $os == *"Darwin"* && $macos_use_homebrew == 1 ]] && pm+=("brew")
[[ $os == *"Linux"* && $linux_use_homebrew == 1 ]] && pm+=("brew")

# fn for quickly checking for a package manager
using_pm() {
    local seeking="$1"
    local in=1
    [[ " ${pm[@]} " == *" $seeking "* ]] && in=0
    return $in
}
