#! /bin/bash

function charcode {
    printf %d "'$1"
}

upperA=$(charcode "A")
lowerA=$(charcode "a")

function cpriority {
    local in=$1
    local cc=$(charcode $in)
    if [ $cc -lt $lowerA ]
    then
        echo $((27+$cc-$upperA))
    else
        echo $((1+$cc-$lowerA))
    fi
}

function findduplicate {
    local first=$1
    local second=$2
    
    for ((i=0;i<${#first}; ++i)) ; do
        local c=${first:i:1}
        if [[ $second == *$c* ]]; then
            echo $c
            break
        fi
    done
}

function processrucksack {
    local str=$1
    local len=${#str}
    local half=$((len/2))
    local first=${str:0:half}
    local second=${str:half:half}
    echo $(cpriority $(findduplicate $first $second))
}

total=0
while read line
do
    total=$(($total + $(processrucksack $line)))
done<$1
echo $total
