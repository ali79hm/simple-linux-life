#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_DIR="$SCRIPT_DIR/setup"

INSTALLERS=()

while IFS= read -r file; do
  INSTALLERS+=("$file")
done < <(
  find "$INSTALLER_DIR" \
    -maxdepth 1 \
    -type f \
    -name "*.sh" \
    | sort
)

if [[ ${#INSTALLERS[@]} -eq 0 ]]; then
  echo "No installer scripts found in:"
  echo "  $INSTALLER_DIR"
  exit 1
fi

# All installers selected by default
SELECTED=()
for ((i = 0; i < ${#INSTALLERS[@]}; i++)); do
  SELECTED[$i]=1
done

CURRENT=0

cleanup() {
  printf "\033[?25h"
}

trap cleanup EXIT

# Hide cursor
printf "\033[?25l"

draw() {
  clear

  echo "Setup"
  echo "────────────────────────────────────────"
  echo

  for i in "${!INSTALLERS[@]}"; do
    name="$(basename "${INSTALLERS[$i]}" .sh)"

    if [[ "${SELECTED[$i]}" == "1" ]]; then
      mark="x"
    else
      mark=" "
    fi

    if [[ "$i" -eq "$CURRENT" ]]; then
      printf "  > [%s] %s\n" "$mark" "$name"
    else
      printf "    [%s] %s\n" "$mark" "$name"
    fi
  done

  echo
  echo "────────────────────────────────────────"
  echo "↑ / ↓ move   SPACE check/uncheck   ENTER install   q quit"
}

while true; do
  draw

  IFS= read -rsn1 key

  case "$key" in
    $'\x1b')
      # Read arrow-key sequence
      read -rsn2 -t 0.1 rest || true

      case "$rest" in
        '[A')
          ((CURRENT--)) || true

          if ((CURRENT < 0)); then
            CURRENT=$((${#INSTALLERS[@]} - 1))
          fi
          ;;

        '[B')
          ((CURRENT++)) || true

          if ((CURRENT >= ${#INSTALLERS[@]})); then
            CURRENT=0
          fi
          ;;
      esac
      ;;

    ' ')
      if [[ "${SELECTED[$CURRENT]}" == "1" ]]; then
        SELECTED[$CURRENT]=0
      else
        SELECTED[$CURRENT]=1
      fi
      ;;

    q|Q)
      clear
      echo "Setup canceled."
      exit 0
      ;;

    '')
      break
      ;;
  esac
done

clear
printf "\033[?25h"

COUNT=0

for i in "${!INSTALLERS[@]}"; do
  if [[ "${SELECTED[$i]}" == "1" ]]; then
    ((COUNT++)) || true
  fi
done

if [[ "$COUNT" -eq 0 ]]; then
  echo "Nothing selected."
  exit 0
fi

echo "Installing $COUNT selected installer(s)..."
echo

for i in "${!INSTALLERS[@]}"; do
  [[ "${SELECTED[$i]}" != "1" ]] && continue

  file="${INSTALLERS[$i]}"
  name="$(basename "$file")"

  echo "────────────────────────────────────────"
  echo "Installing: $name"
  echo "────────────────────────────────────────"
  echo

  bash "$file"

  echo
  echo "✓ Finished: $name"
  echo
done

echo "────────────────────────────────────────"
echo "✓ Setup complete"