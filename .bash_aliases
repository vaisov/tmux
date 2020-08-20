branch() {
  if [ ! -z "$1" ]
  then
    git branch $1
    git checkout $1
    git branch
  else
    git branch
  fi
}

chout() {
  if [ ! -z "$1" ]
  then
    git checkout $1 && \
    git pull origin $1
    git branch
  else
    git branch
  fi
}

gitp() {
  git push origin $(git rev-parse --abbrev-ref HEAD)
}
