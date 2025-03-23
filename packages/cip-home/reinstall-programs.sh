#!/bin/sh

echo
echo "=> Installing marswm"
cargo install marswm --force --root ~/.local/

echo
echo "=> Installing marsbar"
cargo install marsbar --force --root ~/.local/

echo
echo "=> Installing mars-relay"
cargo install mars-relay --force --root ~/.local/

echo
echo "=> Installing lash"
cargo install lash --force --root ~/.local/

echo
echo "=> Installing fd-find"
cargo install fd-find --force --root ~/.local/

echo
echo "=> Installing tealdeer"
cargo install tealdeer --force --root ~/.local/
