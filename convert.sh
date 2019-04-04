#!/bin/bash

FROM_ENCODING="ISO_8859-1"
TO_ENCODING="UTF-8"

CONVERT="iconv -f $FROM_ENCODING -t $TO_ENCODING"

for  file  in  *.tex; do
     $CONVERT "$file" -o "${file}"
done
exit 0
