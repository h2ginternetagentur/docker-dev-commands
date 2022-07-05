#!/bin/bash

URL_REGEX='(https?|ftp|file|http)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
FILE_NAME=$(pwd)/$1
NEW_FILE_NAME=$(pwd)/migrated.$1
CURRENT_URL=$2
NEW_URL=$3

if [ ! -f $FILE_NAME ]
then
    echo "The source sql file (first argument) $FILE_NAME does not exist"
    exit 127;
fi

if ! [[ $CURRENT_URL =~ $URL_REGEX ]]
then
    echo "The current url $CURRENT_URL (second argument) is not an valid URL"
    exit 127;
fi
if ! [[ $NEW_URL =~ $URL_REGEX ]]
then
    echo "The new url  $NEW_URL (third argument) is not an valid URL"
    exit 127;
fi


sed "s|$CURRENT_URL|$NEW_URL|g" $FILE_NAME > $NEW_FILE_NAME

echo saved migrated file in $NEW_FILE_NAME
