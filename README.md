# simple-linux-life

Small shell helpers and setup scripts for making everyday Linux work a little easier.


## Setup

Clone the repository and run the interactive setup script:

```bash
git clone <repository-url>
cd simple-linux-life
chmod +x setup.sh
./setup.sh
```

The setup menu finds every `.sh` file in the `setup/` directory. All installers are selected by default.

- Use the Up and Down arrow keys to move.
- Press Space to select or unselect an installer.
- Press Enter to run the selected installers.
- Press `q` to quit without installing anything.

The current installer checks whether needed packages are already installed. If there are missing packages, installer uses the first supported package manager it finds: `apt-get`, `dnf`, `yum`, `pacman`, `apk`, `zypper`, or Homebrew. Linux package managers may require `sudo` access.

### Enable shell functions permanently

To load all custom functions from `shell/functions.sh` whenever you open a new terminal, add this block to your shell configuration file:

- Bash: `~/.bashrc`
- Zsh: `~/.zshrc`

If the repository is located at `$HOME/simple-linux-life`, use:

```bash
CUSTOM_FUNCTIONS="$HOME/simple-linux-life/shell/functions.sh"

if [ -f "$CUSTOM_FUNCTIONS" ]; then
	source "$CUSTOM_FUNCTIONS"
fi
```

The path must point to the repository's `shell/functions.sh` file. If you cloned the repository somewhere else, change `$HOME/simple-linux-life` to the correct repository path.

Reload the file after editing it:

```bash
source ~/.bashrc   # Bash
source ~/.zshrc    # Zsh
```

## Tools

### jsonless

`jsonless` is a Bash function for viewing JSON in a readable, colorized, scrollable format. It runs:

```bash
jq --color-output . <file-or-input> | less -R
```

Here is what each part does:

1. `jq .` parses the JSON and pretty-prints it with indentation.
2. `--color-output` adds colors for strings, numbers, booleans, and other JSON values.
3. `less -R` opens the result in a pager while allowing the color escape codes through.

#### Examples

View a JSON file:

```bash
jsonless sample/sample.json
```

Pipe JSON into the command:

```bash
curl -s https://example.com/data.json | jsonless
```

You can use the usual `less` controls: Space or Page Down to move forward, `b` to move back, `/` to search, and `q` to quit.

---