#!/bin/bash
URL_REGEX='(https?|ftp|file|http)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'

echo -en  "Enter the filename:\n"
read FILE_NAME

NEW_FILE_NAME=migrated.$FILE_NAME

if [ ! -f $FILE_NAME ] || [ -z $FILE_NAME ]
then
    echo "The source sql file (first argument) $FILE_NAME does not exist"
    exit 127;
fi

echo -en  "Enter the current url:\n"
read CURRENT_URL

if ! [[ $CURRENT_URL =~ $URL_REGEX ]]
then
    echo "The current url $CURRENT_URL (second argument) is not an valid URL"
    exit 127;
fi

echo -en  "Enter the new url:\n"
read NEW_URL

if ! [[ $NEW_URL =~ $URL_REGEX ]]
then
    echo "The new url $NEW_URL (third argument) is not an valid URL"
    exit 127;
fi

sed "s|$CURRENT_URL|$NEW_URL|g" $FILE_NAME > $NEW_FILE_NAME
echo saved migrated file in $NEW_FILE_NAME

echo "Use this to import the db into docker container:"
echo "docker exec -it SQL_CONTAINER_NAME mysql -uDBUSER -pPASSWORD DB_NAME < $NEW_FILE_NAME"

echo -en "Do you want to import into a docker Conteiner? (y|n) "
read INTO_DOCKER

if [[ $INTO_DOCKER != "y" ]]
then
  echo "ok goodby"
  exit 0
fi

echo -en "Docker Container name? (eg: fca-mysql)\n"
read SQL_CONTAINER_NAME

echo -en "Docker DB User? (eg: fc_aarau)\n"
read DB_USER

echo -en "Docker DB Password? (eg: fc_aarau)\n"
read DB_PASSWORD

echo -en "Docker DB Name? (eg: fc_aarau)\n"
read DB_NAME


echo "execute: docker exec -i $SQL_CONTAINER_NAME mysql -u$DB_USER -p$DB_PASSWORD $DB_NAME < $NEW_FILE_NAME"
docker exec -it $SQL_CONTAINER_NAME mysql -u$DB_USER -p$DB_PASSWORD $DB_NAME < $NEW_FILE_NAME

