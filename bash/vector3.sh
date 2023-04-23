# (a: vector3, b: vector3) -> vector3
vector3.sub() {
    local -a args=( ${*} )

    (( x = args[0] - args[3], y = args[1] - args[4], z = args[2] - args[5] ))
    globals[$3]="$x $y $z"
}

# (a: vector3, b: vector3) -> decimal
vector3.dot() {
    local -a args=( ${*} )

    globals[$3]="$(( ((args[0] * args[3])>>radix) + ((args[1] * args[4])>>radix) + ((args[2] * args[5])>>radix) ))"
}

# (a: vector3, b: vector3) -> vector3
vector3.cross() {
    local -a args=( ${*} )

    (( x = (args[1] * args[5] - args[2] * args[4])>>radix, y = (args[2] * args[3] - args[0] * args[5])>>radix, z = (args[0] * args[4] - args[1] * args[3])>>radix ))
    globals[$3]="$x $y $z"
}

# (data: vector3) -> vector3
vector3.norm() {
    local -a args=( ${*} )

    (( x=((args[0]*args[0])>>radix) + ((args[1]*args[1])>>radix) + ((args[2]*args[2])>>radix) )) && {
        sqrt "$x" "$2"
        globals[$2]="$(( (args[0]<<radix)/globals[$2] )) $(( (args[1]<<radix)/globals[$2] )) $(( (args[2]<<radix)/globals[$2] ))"
    } || globals[$2]="0 0 0"
}

# (vertex: vector3, transformation: matrix4x4) -> vector3
vector3.transformW() {
    local -a args=( ${*} )
    local -i w x y z

    (( w = ((args[0]*args[6])>>radix) + ((args[1]*args[10])>>radix) + ((args[2]*args[14])>>radix) + args[18] ))
    (( x = (( ((args[0]*args[3])>>radix) + ((args[1]*args[7])>>radix) + ((args[2]*args[11])>>radix) + args[15]) << radix) / w ))
    (( y = (( ((args[0]*args[4])>>radix) + ((args[1]*args[8])>>radix) + ((args[2]*args[12])>>radix) + args[16]) << radix) / w ))
    (( z = (( ((args[0]*args[5])>>radix) + ((args[1]*args[9])>>radix) + ((args[2]*args[13])>>radix) + args[17]) << radix) / w ))
    globals[$3]="$x $y $z"
}
