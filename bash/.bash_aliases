alias gitf="git add .; git commit -m \"fast commit\"; git push -u"
alias gits="git status"
alias gitp="git pull"
alias gitc="git add.; git commit -m \"fast commit\""

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias com3="php bin/console doctrine:schema:drop --full-database --force; php bin/console doctrine:schema:update --force; php bin/console doctrine:fixtures:load -q"
alias migr="dropdb; php bin/console d:m:m; php bin/console m:mi"

alias dropdb="php bin/console doctrine:schema:drop --full-database --force"

alias com3b="php bin/console doctrine:fixtures:load --group=BASE_FIXTURE"

alias pa="git pull; cd dashboard; yarn; yarn encore prod; cd ../website; yarn; yarn encore prod; php bin/console c:c"

alias pwa="git pull; cd website; yarn; yarn encore prod; php bin/console c:c"

alias pwp="git pull; cd website; php bin/console c:c"

alias pdy="git pull; cd dashboard; yarn; yarn encore prod; cd ../website; php bin/console c:c"