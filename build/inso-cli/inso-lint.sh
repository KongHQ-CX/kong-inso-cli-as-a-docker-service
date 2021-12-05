#!/bin/sh
set -e
TERM=dumb

# RUN inso lint spec with the input file in $@, and clean it up.
#   It is important to jq -M to remove any additional "invisible" control
#   characters, otherwise the parsing the output later will be problematic

inso lint spec "$@" 2>&1 | grep -v -e "WARN\|errors" -e '^[[:space:]]*$' | sed 's/ - /\t/g' | tr -d "\r" | jq -RMsnc '[inputs
     | . / "\n"
     | (.[] | select(length > 0) | . / "\t") as $input
     | {"position": $input[0], "error": $input[1]}]
'
