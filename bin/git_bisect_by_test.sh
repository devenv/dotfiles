#!/bin/bash

set -e

cd $1
mvn test -Dtest=$2
cd -
