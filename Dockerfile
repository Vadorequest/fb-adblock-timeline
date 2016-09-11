# TODO Replace with a proper version of Ubuntu, which should have node (nvm) and gulp installed.
FROM ubuntu:16.10

# Allow to run custom gulp command by default, like "gulp look".
ENTRYPOINT gulp
