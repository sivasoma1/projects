#!/bin/bash

var1=$1
var2=$2
if [ $var1 gt $var2 ]
then
    echo "$var1 is greather than $var2"
else 
    echo "$var2 The number is not greather than $var1"
fi