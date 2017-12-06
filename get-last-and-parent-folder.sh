#! /usr/bin/env bash

echo $PWD | awk -F"/" '{print $(NF-1)"/"$NF}'
