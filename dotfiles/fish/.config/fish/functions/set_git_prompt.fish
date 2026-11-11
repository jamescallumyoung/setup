function set_git_prompt
	set -g __fish_git_prompt_showupstream "yes"
	set -g __fish_git_prompt_char_upstream_ahead (printf '\\uf062 ')
	set -g __fish_git_prompt_color_upstream_ahead "green"
	set -g __fish_git_prompt_char_upstream_behind (printf '\\uf063 ')
	set -g __fish_git_prompt_color_upstream_behind "red"

	set -g __fish_git_prompt_showstashstate "yes"
	set -g __fish_git_prompt_char_stashstate (printf ' ')
	set -g __fish_git_prompt_color_stashstate "yellow"

	set -g __fish_git_prompt_showuntrackedfiles "yes"
	set -g __fish_git_prompt_char_untrackedfiles "☡ "
	set -g __fish_git_prompt_color_untrackedfiles "yellow"

	set -g __fish_git_prompt_showdirtystate "yes"
	set -g __fish_git_prompt_char_dirtystate (printf '\\uf040 ')
	set -g __fish_git_prompt_color_dirtystate "magenta"

	set -g __fish_git_prompt_char_stagedstate (printf '\\uf00c ')
	set -g __fish_git_prompt_color_stagedstate "green"
	
	set -g __fish_git_prompt_char_invalidstate (printf '\\uf071 ')
	set -g __fish_git_prompt_color_invalidstate "red"

	set -g __fish_git_prompt_shorten_branch_len "400"
	set -g __fish_git_prompt_shorten_branch_char_suffix ""
	set -g __fish_git_prompt_char_stateseparator " | "
end
