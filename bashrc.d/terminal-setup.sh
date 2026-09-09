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

# On a Slurm cluster the hostname is just a node name ("ln03") and says nothing
# about which machine you are on, so resolve the Slurm cluster name for the
# prompt. scontrol queries the controller, which is far too slow to run on every
# prompt, so cache the answer per host.
if command -v scontrol >/dev/null 2>&1; then
  _cluster_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/cluster-${HOSTNAME%%.*}"
  if [ -s "$_cluster_cache" ]; then
    CLUSTER_NAME=$(cat "$_cluster_cache")
  else
    # A busy controller can make scontrol hang; don't stall shell startup on it.
    _cluster_timeout=""
    command -v timeout >/dev/null 2>&1 && _cluster_timeout="timeout 2"
    CLUSTER_NAME=$($_cluster_timeout scontrol show config 2>/dev/null | awk '/^ClusterName/ {print $3; exit}')
    unset _cluster_timeout
    if [ -n "$CLUSTER_NAME" ]; then
      mkdir -p "${_cluster_cache%/*}"
      printf '%s\n' "$CLUSTER_NAME" > "$_cluster_cache"
    fi
  fi
  # starship hides the hostname whenever CLUSTER_NAME is set, so never leave it
  # exported-but-empty: that would hide the hostname with nothing to replace it.
  if [ -n "$CLUSTER_NAME" ]; then
    export CLUSTER_NAME
  else
    unset CLUSTER_NAME
  fi
  unset _cluster_cache
fi

eval "$(starship init bash)"