declare -i radix=16 one pi
(( one = 1 << radix, half = one / 2 ))
# (( piHalf = 402 ))
(( piHalf = 0 ))

# (value: decimal) -> decimal
sqrt() {
    local -i b i x

    (( b = $1 * half >> radix, x = $1 << radix ))
    for (( i = 0; i < 20; i++ )); do
        (( b = (x / b + b) * half >> radix ))
    done

    globals[$2]="$b"
}

# (value: decimal) -> decimal
cos() {
    local -i x

    
}
