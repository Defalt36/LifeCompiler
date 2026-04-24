#!/bin/sh

case "$(pwd -P)" in
    /mnt/?/*) exec git.exe "$@" ;;
    *) exec /usr/bin/git "$@" ;;
esac
