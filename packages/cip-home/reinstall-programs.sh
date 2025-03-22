#!/bin/sh

echo
echo "=> Installing marswm"
cargo install marswm --root ~/.local/

echo
echo "=> Installing marsbar"
cargo install marsbar --root ~/.local/

echo
echo "=> Installing mars-relay"
cargo install mars-relay --root ~/.local/

echo
echo "=> Installing lash"
cargo install lash --root ~/.local/

echo
echo "=> Installing fd-find"
cargo install fd-find --root ~/.local/

echo
echo "=> Installing tealdeer"
cargo install tealdeer --root ~/.local/
