#!/bin/bash

trap "exit" INT

result=0

cd "$( dirname "${BASH_SOURCE[0]}" )"

for test_script in $(find . -name test_runner.sh); do
  echo `dirname $test_script`
  if [ "$2" != "" ] && [ "./$2" != `dirname $test_script` ]
  then
    continue
  fi

  pushd `dirname $test_script` > /dev/null
  chmod +x ./test_runner.sh
  if [ "$1" == "ci" ]; then
    ./test_runner.sh ci $3
  else
    ./test_runner.sh main $3
  fi

  ((result+=$?))
  popd > /dev/null
done

if [ $result -eq 0 ]; then
  tput setaf 2;
  echo "==================== SUCCESS ===================="
  echo "          You will be showered in riches         "
else
  tput setaf 1;
  echo "=====================  FAILURE  ===================="
  echo "You have brought shame upon yourself and your family"
fi

exit $result