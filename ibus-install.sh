#!/bin/bash

trap exit ERR
set -o pipefail

datadir=/usr/share
tabledir=${datadir}/ibus-table
icondir=${tabledir}/icons
name=latex
table=latex.txt
image=latex-input.svg

if [ $# -gt 1 ]
then
    echo "USAGE: ibus-install.sh [NAME]"
    exit 1
elif [ $# -eq 1 ]
then
    latex=$1
fi

ibus-table-createdb -n ${tabledir}/${name}.db -s latex.txt
cp images/${image} ${icondir}/${image}
