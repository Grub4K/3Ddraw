#!/bin/env bash

declare -A globals temp
declare -i b
# (value: r16) -> r16
sqrt() {
    local -i b i

    (( b = $1*32768>>16 ))
    for (( i = 0; i < 20; i++ )); do
        (( b = (b+(($1<<16)/b)) * 32768 >> 16 ))
    done

    globals[$2]="$b"
}

# (value: r16) -> r16
sqrt_b() {
    local -i b

    globals[$2]="$(( b = $1*32768>>16, b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b ))"
}

main() {
    local -i begin end duration iterations i
    unset 'globals[result]'

    iterations=$1

    begin=$SECONDS

    for (( i = 0; i < $iterations; i++ )); do
        sqrt "65538 * 4" result
    done

    end=$SECONDS
    (( duration = end - begin ))

    printf 'loop: %d\n' "$duration"
    printf '    %s\n' "${globals[result]}"
    unset 'globals[result]'

    begin=$SECONDS

    for (( i = 0; i < $iterations; i++ )); do
        sqrt_b "65538 * 4" result
    done

    end=$SECONDS
    (( duration = end - begin ))

    printf 'unrolled: %d\n' "$duration"
    printf '    %s\n' "${globals[result]}"
    unset 'globals[result]'
}

main $1
