#!/bin/bash

echo value of a = $a
echo value of b = ${b}

DATE=$(date +%F)
echo welcome today $DATE

x=$((1*3))
echo value of $x
a1=200
echo val of ABC=${ABC}

b2=(100 101 abc)
echo ${b2[0]}

declare -A new=([class]=devops [train]=raghu [time]=6)
echo ${new[class]}

# read -p "Enter your age": age
# echo "your age = ${age}"

# read -p "enter your college": college
#  echo "college name = ${college}"
# echo ${college}


echo $0
echo $1
echo $n
echo $@
echo $*
echo $#