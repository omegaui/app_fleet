#!/bin/bash
cd package
./build-bundle.sh
cd integration
./integrate.sh update