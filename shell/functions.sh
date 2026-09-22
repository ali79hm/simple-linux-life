jsonless() {
  jq --color-output . "$@" | less -R
}

credit() {
  case "$1" in
    nw|neuralwatt)
      if [[ -z "${NEURALWATT_API_KEY:-}" ]]; then
        echo "NEURALWATT_API_KEY is not set. Run: export NEURALWATT_API_KEY=your_api_key"
        return 1
      fi

      curl -sS https://api.neuralwatt.com/v1/quota \
        -H "Authorization: Bearer $NEURALWATT_API_KEY" \
        | jsonless
      ;;

    or|openrouter)
      if [[ -z "${OPENROUTER_API_KEY:-}" ]]; then
        echo "OPENROUTER_API_KEY is not set. Run: export OPENROUTER_API_KEY=your_api_key"
        return 1
      fi

      curl -sS https://openrouter.ai/api/v1/key \
        -H "Authorization: Bearer $OPENROUTER_API_KEY" \
        | jsonless
      ;;

    *)
      echo "Usage: credit {or|openrouter} | {nw|neuralwatt}"
      return 2
      ;;
  esac
}