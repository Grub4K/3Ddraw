declare -i one half pi piHalf
(( one = 1 << radix, half = one >> 1 ))

# (value: string) -> decimal
_() {
    local -i i digits result

    digits=( ${1/./ } )
    for (( i = ${#digits[1]} - 1; i >= 0; i-- )); do
        (( result = (result + ${digits[1]:$i:1} * one) / 10 ))
    done

    printf "%d" "$(( result + digits[0] * one ))"
}

pi="$(_ 3.1415926535)"
(( piHalf = pi >> 1 ))

# (value: decimal) -> decimal
sqrt() {
    local -i b i x

    (( b = $1 >> 1, x = $1 << radix ))
    for (( i = 0; i < 20 && b != 0; i++ )); do
        (( b = (x / b + b) >> 1 ))
    done

    globals[$2]="$b"
}

# (value: decimal) -> decimal
cos() {
    local -i x a prefix

    (( a=($1 / piHalf) % 4, x=$1 % piHalf ))
    (( prefix = ((-((a^(a>>1))&1)<<1)+1) ))
    (( x=(a&1) * (piHalf-x) + ((a&1)^1) * x, x=x*x>>radix ))
    globals[$2]="$(( prefix * (one - x / 2 + x*x/(24*one) - ((x*x)>>radix)*x/(720*one)) ))"
}

# (value: decimal) -> decimal
sin() {
    cos "$(( $1 - piHalf ))" $2
}
