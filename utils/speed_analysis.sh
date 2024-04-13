#!/bin/env bash

declare -A globals

# (value: r16) -> r16
sqrt_loop() {
    local -i b i

    (( b = $1*32768>>16 ))
    for (( i = 0; i < 20; i++ )); do
        (( b = (b+(($1<<16)/b)) * 32768 >> 16 ))
    done

    printf '%d\n' "${b}"
}

# (value: r16) -> r16
sqrt_unrolled() {
    local -i b

    printf '%d\n' "$(( b = $1*32768>>16, b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b ))"
}

# (value: r16) -> r16
sqrt_global_loop() {
    local -i b i

    (( b = $1*32768>>16 ))
    for (( i = 0; i < 20; i++ )); do
        (( b = (b+(($1<<16)/b)) * 32768 >> 16 ))
    done

    globals[$2]="$b"
}

# (value: r16) -> r16
sqrt_global_unrolled() {
    local -i b

    globals[$2]="$(( b = $1*32768>>16, b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b = ((b+(($1<<16)/b))*32768>>16), b ))"
}

main() {
    local -i begin iterations i
    unset 'globals[result]'

    (( iterations = $1 ))

    (( begin=$SECONDS ))
    for (( i = 0; i < iterations; i++ )); do
        result="$(sqrt_loop "65538 * 4")"
    done
    printf '%-20s: %3d\n' 'sqrt_loop' "$(( ${SECONDS} - begin ))"

    (( begin=$SECONDS ))
    for (( i = 0; i < iterations; i++ )); do
        result="$(sqrt_unrolled "65538 * 4")"
    done
    printf '%-20s: %3d\n' 'sqrt_unrolled' "$(( ${SECONDS} - begin ))"

    (( begin=$SECONDS ))
    for (( i = 0; i < iterations; i++ )); do
        sqrt_global_loop "65538 * 4" result
    done
    printf '%-20s: %3d\n' 'sqrt_global_loop' "$(( ${SECONDS} - begin ))"

    (( begin=$SECONDS ))
    for (( i = 0; i < iterations; i++ )); do
        sqrt_global_unrolled "65538 * 4" result
    done
    printf '%-20s: %3d\n' 'sqrt_global_unrolled' "$(( ${SECONDS} - begin ))"

    unset 'globals[result]'
}

main "${1}"
