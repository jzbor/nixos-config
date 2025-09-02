#!/usr/bin/env python3
import argparse
import os
import sys
import subprocess


SHELL_NIX_FILE = './shell.nix'
SHELL_DRV_FILE = './.shell.drv'
SHELL_TEMPLATE= '''
{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # build tools
    nativeBuildInputs = with pkgs; [];

    # libraries/dependencies
    buildInputs = with pkgs; [];
}
'''


def die(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)
    sys.exit(1)

def parse_args():
    parser = argparse.ArgumentParser(
            prog=sys.argv[0],
            description='Manage development environments with nix-shell')
    parser.add_argument('-c', '--create', action='store_true')
    parser.add_argument('-i', '--instantiate', action='store_true')
    parser.add_argument('-e', '--enter', action='store_true')
    return parser.parse_args()

def find_shell():
    files = [ SHELL_NIX_FILE, SHELL_DRV_FILE ]
    for file in files:
        if os.path.exists(file):
            return file
    return None


if __name__ == '__main__':
    args = parse_args()

    if args.create:
        if os.path.exists(SHELL_NIX_FILE):
            die(f'Error: {SHELL_NIX_FILE} already exists')
        else:
            with open(SHELL_NIX_FILE, 'w') as file:
                file.write(SHELL_TEMPLATE)

    if args.instantiate:
        if os.path.exists(SHELL_NIX_FILE):
            subprocess.call(['nix-instantiate', SHELL_NIX_FILE, '--indirect', '--add-root', SHELL_DRV_FILE ])
        else:
            die('Error: No shell file found to instantiate')

    if args.enter:
        file = find_shell()
        if file and 'SHELL' in os.environ:
            subprocess.call(['nix-shell', file, '--command', os.environ['SHELL']])
        elif file:
            subprocess.call(['nix-shell', file])
        else:
            die('Error: No shell file found to enter')

