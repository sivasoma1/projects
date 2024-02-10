#!/bin/bash
#this is called array,instead of single value it can hold multiple values


    # $@ represents all the arguments passed to a script.
    # $0 represents file name.
    # $1 represents  first argument and so on..
    # $2 represents second argument  and so on...
    # $* represents all the arguments as a list $1 $2 .. $n
    # $# represents number of arguments given to the script.
    # $? represents exit status of last command executed in background.
    
person=("siva" "krishna" "saikiran")

echo ${person[0]} #accessing the first element using index 0
echo ${persson[@]} #accessing the all the elements using index @
echo ${person[*]} #same as above but with space between each element
echo ${person[@]:1:2} #it will print second and third element only

