#!/bin/sh
cd $(dirname $0)
cd ../complete
./gradlew build
rm -rf build
exit $ret
