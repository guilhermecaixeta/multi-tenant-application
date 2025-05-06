#!/bin/bash

# Install the version of Bundler specified in Gemfile.lock
if [ -f Gemfile.lock ]; then
    bundler_version=$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1 | tr -d ' ')
    gem update --system 3.6.7
    gem install bundler -v "$bundler_version"
fi

# If there's a Gemfile, then run `bundle install`
if [ -f Gemfile ]; then
    echo "Installing global node packages"
    npm install -g mjml

    echo "Installing gems"
    gem install whenever rails htmlbeautifier solargraph \
        sorbet foreman debug rdbg erb_lint kamal \
        ruby-debug-ide debase

    echo "running bundle"
    bundle install

    echo "initializing tapioca"
    bundle exec tapioca init
    bin/rails tapioca:update:all
fi
