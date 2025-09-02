#!/bin/sh
SYSTEM_CONFIG="$HOME/Programming/Nix/nixos-config"
SYSTEM_BRANCH="master"
HOME_CONFIG="$HOME/Programming/Nix/home-config"
HOME_BRANCH="master"
COMMIT_MESSAGE="Updating flake inputs"
CLEANUP_THRESHOLD="14d"

set +o nounset


askpass() {
	# print prompt
	if [ -n "$2" ]; then
		printf "%s: " "$2"
	fi

	# save old tty environment
	old_tty="$(stty -g)"
	# disable echoing for tty
	stty -echo
	# set a trap if script gets interrupted
	trap 'stty $old_tty' EXIT

	read -r "$1"

	# reset shell environment
	stty "$old_tty"
	trap - EXIT

	echo
}

die () {
	if [ -n "$1" ]; then
		echo "ERROR: $1" >&2
	else
		echo "UNKNOWN ERROR" >&2
	fi
	exit 1
}

git_assert_branch () {
	if [ -z "$1" ] || [ -z "$2" ]; then
		die "git_assert_branch needs two arguments (directory and branch name)"
	fi
	test "$2" = "$(git -C "$1" rev-parse --abbrev-ref HEAD)"
}

update_system () {
	git_assert_branch "$SYSTEM_CONFIG" "$SYSTEM_BRANCH" \
		|| die "git branch not matching for $SYSTEM_CONFIG (expected $SYSTEM_BRANCH)"

	echo "=> Fetching latest git version"
	git -C "$SYSTEM_CONFIG" pull \
		|| die "unable to fetch recent version for $SYSTEM_CONFIG from git"

	echo "=> Updating flake inputs"
	cd "$SYSTEM_CONFIG" \
		|| die "unable to enter $SYSTEM_CONFIG"
	nix flake update \
		|| die "unable to update flake inputs ($SYSTEM_CONFIG)"
	cd - > /dev/null \
		|| die "unable to switch back working directory"

	echo "=> Rebuilding system"
	doas nixos-rebuild switch --flake "$SYSTEM_CONFIG" \
		|| die "unable to switch to new system"

	echo "=> Commiting and pushing changes"
	git -C "$SYSTEM_CONFIG" commit flake.lock -m "$COMMIT_MESSAGE" \
		|| die "Unable to commit changes"
	git -C "$SYSTEM_CONFIG" push \
		|| die "Unable to push changes"
}

update_system_passive () {
	git_assert_branch "$SYSTEM_CONFIG" "$SYSTEM_BRANCH" \
		|| die "git branch not matching for $SYSTEM_CONFIG (expected $SYSTEM_BRANCH)"

	echo "=> Fetching latest git version"
	git -C "$SYSTEM_CONFIG" pull \
		|| die "unable to fetch recent version for $SYSTEM_CONFIG from git"

	echo "=> Rebuilding system"
	doas nixos-rebuild switch --flake "$SYSTEM_CONFIG" \
		|| die "unable to switch to new system"
}

update_home () {
	git_assert_branch "$HOME_CONFIG" "$HOME_BRANCH" \
		|| die "git branch not matching for $HOME_CONFIG (expected $HOME_BRANCH)"

	echo "=> Fetching latest git version"
	git -C "$HOME_CONFIG" pull \
		|| die "unable to fetch recent version for $HOME_CONFIG from git"

	echo "=> Updating flake inputs"
	cd "$HOME_CONFIG" \
		|| die "unable to enter $HOME_CONFIG"
	nix flake update \
		|| die "unable to update flake inputs ($HOME_CONFIG)"
	cd - \
		|| die "unable to switch back working directory"

	echo "=> Rebuilding home"
	home-manager switch --flake "$HOME_CONFIG" \
		|| die "unable to switch to new home"

	echo "=> Commiting and pushing changes"
	git -C "$HOME_CONFIG" commit flake.lock -m "$COMMIT_MESSAGE" \
		|| die "Unable to commit changes"
	git -C "$HOME_CONFIG" push \
		|| die "Unable to push changes"
}

update_home_passive () {
	git_assert_branch "$HOME_CONFIG" "$HOME_BRANCH" \
		|| die "git branch not matching for $HOME_CONFIG (expected $HOME_BRANCH)"

	echo "=> Fetching latest git version"
	git -C "$HOME_CONFIG" pull \
		|| die "unable to fetch recent version for $HOME_CONFIG from git"

	echo "=> Rebuilding home"
	home-manager switch --flake "$HOME_CONFIG" \
		|| die "unable to switch to new home"
}

cleanup () {
	if command -v home-manager > /dev/null; then
		echo "=> Expiring home-manager generations"
		home-manager expire-generations "$CLEANUP_THRESHOLD" \
			|| die "home-manager cleanup failed"
	else
		echo "=> Skipping home-manager cleanup (not available)"
	fi

	echo "=> Cleaning up local profile"
	nix profile wipe-history --older-than "$CLEANUP_THRESHOLD" \
		|| die "local profile cleanup failed"

	echo "=> Cleaning up system profile"
	doas nix-collect-garbage -d --delete-older-than "$CLEANUP_THRESHOLD" \
		|| die "system profile cleanup failed"

	echo "=> Optimising nix store"
	nix store optimise \
		|| die "store optimisation"
}

for arg in "$@"; do
	case $arg in
		update)
			UPDATE_SYSTEM=1
			UPDATE_HOME=1
			;;
		update-system) UPDATE_SYSTEM=1 ;;
		update-home) UPDATE_HOME=1 ;;
		update-passive)
			UPDATE_SYSTEM_PASSIVE=1
			UPDATE_HOME_PASSIVE=1
			;;
		update-system-passive) UPDATE_SYSTEM_PASSIVE=1 ;;
		update-home-passive) UPDATE_HOME_PASSIVE=1 ;;
		cleanup) CLEANUP=1 ;;
		full)
			UPDATE_SYSTEM=1
			UPDATE_HOME=1
			CLEANUP=1
			;;
		full-passive)
			UPDATE_SYSTEM_PASSIVE=1
			UPDATE_HOME_PASSIVE=1
			CLEANUP=1
			;;
	esac
done

if [ -z "$1" ]; then
	UPDATE_SYSTEM_PASSIVE=1
	UPDATE_HOME_PASSIVE=1
	CLEANUP=1
fi

if [ -n "$UPDATE_SYSTEM_PASSIVE" ]; then
	echo
	echo "### UPDATING SYSTEM (PASSIVELY) ###"
	update_system_passive
fi

if [ -n "$UPDATE_SYSTEM" ]; then
	echo
	echo "### UPDATING SYSTEM ###"
	update_system
fi

if [ -n "$UPDATE_HOME_PASSIVE" ]; then
	echo
	echo "### UPDATING HOME (PASSIVELY) ###"
	update_home_passive
fi

if [ -n "$UPDATE_HOME" ]; then
	echo
	echo "### UPDATING HOME ###"
	update_home
fi

if [ -n "$CLEANUP" ]; then
	echo
	echo "### CLEANUP ###"
	cleanup
fi
