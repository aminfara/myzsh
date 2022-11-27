# CONFIGURATIONS
################################################################################

export LINUXBREW_DIRECTORY=/home/linuxbrew/.linuxbrew

# HELPERS
################################################################################

activate_homebrew() {
  [ -d $LINUXBREW_DIRECTORY/bin ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  true
}

# SET PARAMETERS
################################################################################

export LC_ALL=en_AU.UTF-8
export LANG=en_AU.UTF-8

activate_homebrew

export JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"
