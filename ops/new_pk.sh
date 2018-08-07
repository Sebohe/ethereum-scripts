#!/usr/bin/env bash
head -c 32 /dev/urandom | xxd -c 32 --plain
