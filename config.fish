# GCLOUD
function init_gcloud -d "Configures shell environment gcloud command"
	set -gx CLOUDSDK_PYTHON "/usr/local/bin/python3" # Python v3.12.8 installed by gcloud installer
	# Updates PATH for the Google Cloud SDK.
	if [ -f /Users/skylarpape/google-cloud-sdk/path.fish.inc ]; . /Users/skylarpape/google-cloud-sdk/path.fish.inc; end
end

# TERMINAL PROMPT
function fish_prompt -d "Write out the prompt" 
	# PYTHON VIRTUAL ENVIRONMENT
	set PYTHON_VIRTUAL_ENVIRONMENT ""
	# Toggle virtual environment
	if test $HOME != "$(pwd)" && test -d .venv
		source .venv/bin/activate.fish
	# If environment from previous directory is currently activated
	else if type -q deactivate
		deactivate
	end
	# Get environment name, if one is active
	# The $VIRTUAL_ENV environment variable sometimes contains a stale value
	# Instead check if deactivate command is valid
	if type -q deactivate 
		set VENV_DIR "$(basename $VIRTUAL_ENV)"
		if test "$VENV_DIR" = ".venv"
			set PYTHON_VIRTUAL_ENVIRONMENT "$(basename (pwd)) " 
		else
			set PYTHON_VIRTUAL_ENVIRONMENT "$(basename $VIRTUAL_ENV) "
		end	
	end	
	
	# GCLOUD PROJECT
	if not string length --quiet "$(which gcloud)"
		init_gcloud
	end	
	set GCLOUD_PROJECT "$(gcloud config get-value project 2>&1) "
	if test "$GCLOUD_PROJECT" = "(unset) "
		set GCLOUD_PROJECT ""
	end

	# GIT BRANCH
	set GIT_BRANCH ""
	if git branch --show-current &> /dev/null	
		set GIT_BRANCH "$(git branch --show-current) "
	end
	set CURRENT_DIRECTORY_PATH "$(prompt_pwd)
"
	printf '%s%s%s%s%s%s' \
		(set_color blue) "$PYTHON_VIRTUAL_ENVIRONMENT" (set_color normal) \
		(set_color cyan) "$GCLOUD_PROJECT" (set_color normal) \
		(set_color magenta) "$GIT_BRANCH" (set_color normal) \
		(set_color $fish_color_cwd) "$CURRENT_DIRECTORY_PATH" (set_color normal)
end

# 1Password
op completion fish | source

# GCLOUD
init_gcloud

# PERSONAL SCRIPTS
fish_add_path "$HOME/Local/mxskylar/scripts"
fish_add_path "$HOME/Local/mxskylar/python-scripts/bin"

# CONVENIENCE VARIABLES
set -gx FISH_CONFIG "$HOME/.config/fish/config.fish"

# HOMEBREW
eval (/opt/homebrew/bin/brew shellenv)
if test -d (brew --prefix)"/share/fish/completions"
    set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
end
if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

# PYTHON
set -gx PYTHONPATH "$HOME/scripts" "$PYTHONPATH"
fish_add_path $(brew --prefix)"/opt/python@3.11/libexec/bin"
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1 # The prompt is stale when changing directories while the active virtual environment is not
fish_add_path "$HOME/.local/bin" # Adds uv to path

# JAVA
set -gx JAVA_HOME "$(brew --prefix)/opt/openjdk@17"
fish_add_path "$JAVA_HOME/bin" 

# ABBREVIATIONS
# os utils
abbr --add --global cl "clear"
# git
abbr --add --global gch "git checkout"
abbr --add --global gl "git log"
abbr --add --global ga "git add"
abbr --add --global gsth "git stash"
abbr --add --global gst "git status"
abbr --add --global gacm "git add -A && git commit"
abbr --add --global grv "git revert HEAD"
abbr --add --global gsh "git show"
abbr --add --global gpl "git pull"
abbr --add --global gpsh "git push"
abbr --add --global gb "git branch"
abbr --add --global gcm "git commit"
abbr --add --global grb "git rebase"
abbr --add --global gd "git diff"
abbr --add --global gcl "git-cleanup-branch"
abbr --add --global grl "git-rebase-off-latest"
abbr --add --global gml "git-merge-off-latest"
# docker
abbr --add --global d "docker"
abbr --add --global di "docker image"
abbr --add --global dc "docker compose"
abbr --add --global dsp "docker system prune -a"
abbr --add --global dcp "docker container prune"
# Project-Specific
abbr --add --global canales "docker compose run --rm --entrypoint python canales"

