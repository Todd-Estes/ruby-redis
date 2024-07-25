#!/bin/sh

set -e # Exit early if any commands fail

exec bundle exec ruby app/server.rb "$@"