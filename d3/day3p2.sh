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

function findbadge {
    local first=$1
    local second=$2    
    local third=$3
    
    for ((i=0;i<${#first}; ++i)) ; do
        local c=${first:i:1}
        if [[ $second == *$c* && $third == *$c* ]]; then
            echo $c
            break
        fi
    done
}

total=0
ct=0
lines=(a a a)
while read line
do
    lines[$ct]=$line
    let ct=ct+1;
    if [ $ct == 3 ]
    then
        let ct=0;
        total=$(($total + $(cpriority $(findbadge ${lines[0]} ${lines[1]} ${lines[2]}))))
    fi
done<$1
echo $total
