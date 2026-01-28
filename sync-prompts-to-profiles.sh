#!/bin/zsh

## Summary: Copy all .md files from local prompts and agents source directories
## into each profile directory under `profiles/[profileId]/prompts` and `profiles/[profileId]/agents`.
## Behavior preserved: if a source directory contains no .md files, that category is skipped.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPTS_DIR="$ROOT_DIR/prompts"
AGENTS_DIR="$ROOT_DIR/agents"
USER_PROFILES_DIR="$ROOT_DIR/profiles"

prompts_files=($PROMPTS_DIR/*.md(N))
agents_files=($AGENTS_DIR/*.md(N))
profile_id_dirs=($USER_PROFILES_DIR/*(N/))

if [ ! -d "$PROMPTS_DIR" ]; then
	echo "[ERROR] not found User/prompts/: $PROMPTS_DIR" >&2
	exit 1
fi

if [ ${#profile_id_dirs[@]} -eq 0 ]; then
	echo "[ERROR] not found User/profiles/[id]/: $USER_PROFILES_DIR" >&2
	exit 1
fi

for profile_id_dir in $profile_id_dirs; do
	profile_id="${profile_id_dir##*/}"
	echo "[INFO] --▼ profileId: $profile_id ▼--"

	# copy prompts
	if [ ${#prompts_files[@]} -gt 0 ]; then
		dist_dir="$profile_id_dir/prompts"
		[ -d "$dist_dir" ] || mkdir -p "$dist_dir"
		echo "[INFO] profiles/$profile_id/prompts/"
		for src_path in $prompts_files; do
			file_name="${src_path##*/}"
			dist_path="$dist_dir/$file_name"
			cp "$src_path" "$dist_path"
			echo "[INFO] ├── $file_name"
		done
	fi

	# copy agents
	if [ ${#agents_files[@]} -gt 0 ]; then
		dist_dir="$profile_id_dir/agents"
		[ -d "$dist_dir" ] || mkdir -p "$dist_dir"
		echo "[INFO] profiles/$profile_id/agents/"
		for src_path in $agents_files; do
			file_name="${src_path##*/}"
			dist_path="$dist_dir/$file_name"
			cp "$src_path" "$dist_path"
			echo "[INFO] ├── $file_name"
		done
	fi

	echo ""
done

echo "[INFO] all profiles copy completed"