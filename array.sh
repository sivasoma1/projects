#!/bin/bash
#this is called array,instead of single value it can hold multiple values

person=("siva" "krishna" "saikiran")

echo ${person[0]} #accessing the first element using index 0
echo ${persson[@]} #accessing the all the elements using index @
echo ${person[*]} #same as above but with space between each element
echo ${person[@]:1:2} #it will print second and third element only