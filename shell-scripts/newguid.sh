#! /bin/bash

# create new uppercase formatted guid
#alias newguid="uuidgen | sed 's/-/, /g' | tr '[:lower:]' '[:upper:]'"

newguid="uuidgen | sed 's/-/, /g' | tr '[:lower:]' '[:upper:]'"
