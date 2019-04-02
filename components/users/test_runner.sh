#!/bin/bash

exit_code=0

echo "**Running container specs**"
if [ "$1" == "ci" ]; then
  bundle check --path=../../vendor/bundle || bundle install --path=../../vendor/bundle --jobs=4 --retry=3
else
  bundle check || bundle install
fi

bundle exec rspec spec
exit_code+=$?

exit $exit_code