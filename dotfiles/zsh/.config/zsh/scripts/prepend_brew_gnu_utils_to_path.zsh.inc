# Some systems (especially macOS) ship their own version of many GNU utils, but they're often old.
# Since we prefer to run up-to-date versions, we need to update/replace them. On some systems we use Brew to do this.
# However, Brew prefixes all GNU utils with 'g' so they don't conflict with the versions shipped with macOS.
# (Brew does this regardless of whether it's running on macOS or not.)
# This file finds all GNU utils installed with Brew and prepend them to PATH without the 'g' prefix.

# this script can be slow, so we cache the results to a file on disk.
# (_evalcache could not be used because it's not available until we have an interactive shell (it's loaded in zshrc))

_gnubin_cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/gnubin/gnubin_cache.zsh"

if [[ ! -f $_gnubin_cache_file ]]; then
    echo "Recreating gnubin cache"

    mkdir -p ${_gnubin_cache_file:h}
    touch $_gnubin_cache_file

    # get the "gnubin" directories.
    # these are created for any gnu package that would shadow a package shipped with macOS
    s_gnubins=$(find $(brew --prefix)/opt -type d -follow -name gnubin -print)

    # cast into a zsh array
    a_gnubins=( ${=s_gnubins} )

    # old, looped method. more readable output but slower
    # for bindir ("$a_gnubins[@]"); do
    #   echo "path=($bindir \$path)" >> $_gnubin_cache_file # add each dir to the cache, one line each
    # done

    echo "path=($a_gnubins \$path)" >> $_gnubin_cache_file

    unset s_gnubins
    unset a_gnubins
fi

source $_gnubin_cache_file

function _delete_gnubin_cache() { rm -f $_gnubin_cache_file && echo "Removed." }
