#!/bin/sh
cd $(dirname $0)

cd ../complete
./gradlew build
ret=$?
if [ $ret -ne 0 ]; then
  exit $ret
fi
rm -rf build

cd ../initial
../complete/gradlew -b ../initial/build.gradle wrapper
./gradlew compileJava
ret=$?
if [ $ret -ne 0 ]; then
  exit $ret
fi
rm -rf build
rm -rf gradle
rm gradlew*

exit
