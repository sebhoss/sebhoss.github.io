#!/bin/bash

# enable error reporting to the console
set -e

rm -rf ../master

jekyll build

git clone https://${GH_TOKEN}@github.com/sebhoss/sebhoss.github.io.git ../distribution
cp -R _site/* ../distribution
cd ../distribution
git config user.email "travisci@shoss.de"
git config user.name "Travis-CI for Sebastian Hoß"
git add .
git commit -a -s -m "Travis #${TRAVIS_BUILD_NUMBER}"
git push --quiet origin master > /dev/null 2>&1
