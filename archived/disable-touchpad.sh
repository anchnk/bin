#!/bin/sh

if [ `xinput --list | grep -i "pointer" | wc -l` -ge 3 ];
then
	fingerpad_id=`xinput --list | grep "PS/2 Generic Mouse" | cut -f2 | sed \
  's/id=//g'`
else
	fingerpad_id=11
fi

xinput disable $fingerpad_id
