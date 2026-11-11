function git-branch-choose --description="launch fzf to choose a git branch to checkout"
  git checkout (git branch -a | fzf | string trim -l --chars="*" | string trim)
end
