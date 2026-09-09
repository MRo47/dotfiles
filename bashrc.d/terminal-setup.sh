case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# Some distros (e.g. Fedora) already load bash-completion from /etc/profile.d,
# so only load it here if nothing has done so yet.
if ! shopt -oq posix && [ -z "${BASH_COMPLETION_VERSINFO-}" ]; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

eval "$(starship init bash)"