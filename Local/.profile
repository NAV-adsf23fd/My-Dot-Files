# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022


# ---------------------------------------------------------------------------
# Move some dot files to .misc for tidiness
export DOT_MISC_FOLDER="$HOME/.misc"

export CARGO_HOME="$DOT_MISC_FOLDER/cargo"
export RUSTUP_HOME="$DOT_MISC_FOLDER/rustup"
export HISTFILE="$DOT_MISC_FOLDER/bash_history"
export LESSHISTFILE="$DOT_MISC_FOLDER/lesshst"
export PYTHON_HISTORY="$DOT_MISC_FOLDER/python_history"
export SQLITE_HISTORY="$DOT_MISC_FOLDER/sqlite_history"
export GNUPGHOME="$DOT_MISC_FOLDER/gnupg"
export NPM_CONFIG_USERCONFIG="$DOT_MISC_FOLDER/npmrc"
export NPM_CONFIG_CACHE="$DOT_MISC_FOLDER/npm_cache"
export GOPATH="$DOT_MISC_FOLDER/go"
export GRADLE_USER_HOME="$DOT_MISC_FOLDER/gradle"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$DOT_MISC_FOLDER/java"
export WGETRC="$DOT_MISC_FOLDER/wgetrc"
export IPYTHONDIR="$DOT_MISC_FOLDER/ipython"
export JUPYTER_CONFIG_DIR="$DOT_MISC_FOLDER/jupyter"
export JUPYTER_DATA_DIR="$DOT_MISC_FOLDER/jupyter_data"
export CONDARC="$DOT_MISC_FOLDER/condarc"
export CONDA_PKGS_DIRS="$DOT_MISC_FOLDER/conda_pkgs"
export CONDA_ENVS_DIRS="$DOT_MISC_FOLDER/conda_envs"
# -----------------------------------------------------------------------


# set PATH so it includes user's private bin if it exists
# This make openfile.sh execute instead of default linux xdg-open
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


# Default variable
export DEFAULT_TERMINAL="st"
export DEFAULT_EDITOR="subl"
export DEFAULT_BROWSER="waterfox"
export DEFAULT_FILE_MANAGER="lf"


