#!/bin/bash

executable=$1
shift;
args=$@

bash -lic "$executable $args"