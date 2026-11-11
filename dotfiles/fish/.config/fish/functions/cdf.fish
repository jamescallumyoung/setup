function cdf
  if test $argv
    cd (command ls -d $argv/*/ | fzf)
  else
    cd (command ls -d */ | fzf)
  end
end
