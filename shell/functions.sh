jsonless() {
  jq --color-output . "$@" | less -R
}