#!/bin/env bash

# source ./math.sh
declare -A globals
declare -i pi=205887

sin() {
    globals[$2]="$( echo "s(%d / (1 >> 16)) * (1 << 16)" | bc -l )"
}

main() {
    local -i current width=100 height=20
    local -a values

    (( current = 0, step = (pi << 1) / 100 ))
    sin "$current" res

    values+=( "$(( (height>>1) * globals[res] / one + (height>>1) ))" )

    clear
    for (( i = 0; i < height; i++ )); do
        printf '\n'
    done
    for (( i = 0; i < ${#values}; i++ )); do
        printf '\e[%d;%dH#' "$i" "${values[$i]}"
    done
    printf '\e[0;%dH' "$height"
}
