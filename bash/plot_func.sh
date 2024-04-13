#!/bin/env bash

declare -i radix=8
declare -A globals

source ./math.sh

main() {
    local -i current width=300 height=50
    local -a values

    values=()
    for (( current = 0; current < (pi << 1); current += (pi << 1) / width )); do
        cos "$current" res
        values+=( "$(( (height>>1) * globals[res] / -one + (height>>1) + 2 ))" )
    done

    clear
    for (( i = 0; i < height+2; i++ )); do
        printf '\n'
    done
    printf '\e7'
    for (( i = 0; i < ${#values[@]}; i++ )); do
        printf '\e[%d;%dH#' "$(( values[$i] + 2 ))" "$i"
    done
    printf '\e8\n'
}

main
