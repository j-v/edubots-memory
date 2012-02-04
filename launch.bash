#!/bin/bash
echo 'compiling coffeescript...'
./compile_coffee.bash
echo 'launching server...'
sudo coffee app.coffee
