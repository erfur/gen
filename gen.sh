#!/bin/bash

echo "gen.sh - Generate an agenda file for personal use"
echo "================================================="

if [ $# -eq 0 ]; then
	MONTH=$(date +"%m")
	YEAR=$(date +"%Y")
elif [ $# -eq 2 ]; then
	MONTH=$1
	YEAR=$2
else
	echo "Usage:"
	echo "> ./gen.sh #month #year"
	echo "or"
	echo "> ./gen.sh"
	exit
fi


FILE=$MONTH.$YEAR.txt
LINE=$(python -c 'print("="*72)')

echo "Generating the calendar file for $(date -d "$YEAR$MONTH01" +"%m.%y")"

if [ -e $FILE ]; then
	echo "File exists, backing it up and creating an empty file..."
	mv --backup=numbered $FILE $FILE.bak
	touch $FILE
fi

cal -3 --monday $MONTH $YEAR >> $FILE
echo $LINE >> $FILE

for i in {01..31};
do
	date -d "$YEAR$MONTH$i" +"%d %a" > /dev/null
	RET=$?
	if [ $RET -eq 0 ]; then
		date -d "$YEAR$MONTH$i" +"%d %a" >> $FILE
		echo $LINE >> $FILE
	fi
done

if [ -e $FILE ]; then
	echo "File successfully created."
fi
