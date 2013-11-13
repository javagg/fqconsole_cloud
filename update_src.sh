#!/bin/bash -eu
CWD=`pwd`

if [ -z "$1" ]; then
  echo "Need origin-server source directory"
fi

ORIGIN_SERVER_SRC=$1
FQ_SERVER_SRC=$2

rm -rf vendor/gems
mkdir -p vendor/gems

ORIGIN_CONSOLE=$ORIGIN_SERVER_SRC/console
mkdir -p vendor/gems/origin
cp -r $ORIGIN_CONSOLE vendor/gems/origin
pushd vendor/gems/origin/console
gem_spec=$(ls *.gemspec)
gem build $gem_spec
gem spec *.gem -l --ruby > $gem_spec
rm *.gem
popd

# Our additional plugins
if [ ! -z "FQ_SERVER_SRC" ]; then
  FQ_CONSOLE=$FQ_SERVER_SRC/console
  mkdir -p vendor/gems/freequant
  cp -r $FQ_CONSOLE vendor/gems/freequant
  pushd vendor/gems/freequant/console
  gem_spec=$(ls *.gemspec)
  gem build $gem_spec
  gem spec *.gem -l --ruby > $gem_spec
  rm *.gem
  popd
fi