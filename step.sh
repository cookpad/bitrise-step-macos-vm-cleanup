#!/usr/bin/env bash
set -e

homebrew_cache=$(brew --cache)
if [ -d "$homebrew_cache" ]; then
  # The Homebrew cache in the Bitrise macOS VM image still has all the pre-installed tools.
  # If you enable cache in the Brew install step, you would end up also caching those pre-installed tools.
  # So clean-up the cache to make your cache small and caching faster.
  echo "Removing Homebrew cache"
  rm -rf "$homebrew_cache"
fi

homebrew_logs="${HOMEBREW_LOGS:-$HOME/Library/Logs/Homebrew}"
if [ -d "$homebrew_logs" ]; then
  echo "Removing Homebrew logs"
  rm -rf "$homebrew_logs"
fi

cocoapods_master="$HOME/.cocoapods/repos/master"
if [ -d "$cocoapods_master" ]; then
  # Having CocoaPods's old master only makes things slower and bigger (trunk should be used instead)
  # Removing it also lets us to more easily include ~/.cocoapods/repos in the cache.
  # Note we are not using `pod repo remove master` or `rm -rf` as moving is way faster.
  echo "Removing CocoaPods master"
  mv "$cocoapods_master" "$TMPDIR/unused-cocoapods-master"
fi
