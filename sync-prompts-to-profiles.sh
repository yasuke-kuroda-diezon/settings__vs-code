#!/bin/zsh

## 概要: prompts ディレクトリ内の .md ファイルを各プロファイルの prompts ディレクトリにコピーする.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPTS_SRC="$SCRIPT_DIR/prompts"
PROFILES_ROOT="$SCRIPT_DIR/profiles"

echo "[INFO] コピー処理開始"

if [ ! -d "$PROMPTS_SRC" ]; then
	echo "[ERROR] ソースディレクトリ $PROMPTS_SRC が存在しません" >&2
	exit 1
fi

md_files=($PROMPTS_SRC/*.md(N))
if [ ${#md_files[@]} -eq 0 ]; then
	echo "[WARN] .md ファイルが見つかりません: $PROMPTS_SRC"
	exit 0
fi

profiles=( $PROFILES_ROOT/*(/) )
if [ ${#profiles[@]} -eq 0 ]; then
	echo "[ERROR] プロファイルディレクトリが存在しません: $PROFILES_ROOT" >&2
	exit 1
fi

for profile_dir in $profiles; do
	profile_id="${profile_dir##*/}"
	target_dir="$profile_dir/prompts"
	if [ ! -d "$target_dir" ]; then
		echo "[INFO] プロファイル '$profile_id' の prompts ディレクトリを作成: $target_dir"
		mkdir -p "$target_dir"
	fi
	for src_file in $md_files; do
		file_name="${src_file##*/}"
		dest_file="$target_dir/$file_name"
		cp "$src_file" "$dest_file"
		echo "[INFO] コピー: $file_name -> profiles/$profile_id/prompts/"
	done
done

echo "[INFO] 全てのプロファイルへのコピーが完了しました"