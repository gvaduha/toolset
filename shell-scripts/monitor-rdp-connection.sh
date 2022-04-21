#! /bin/bash

while true ; do nc -vz $1 3389 |& grep -v succeeded ; done