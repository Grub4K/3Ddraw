
# (a: vector3, b: vector3) -> vector3
vector3.sub() {
    local -a args=( ${*} )

    (( x = args[0] - args[3], y = args[1] - args[4], z = args[2] - args[5] ))
    globals[$3]="$x $y $z"
}

# (data: vector3) -> vector3
vector3.norm() {
    local -a args=( ${*} )

    (( x=((args[0]*args[0])>>16) + ((args[1]*args[1])>>16) + ((args[2]*args[2])>>16) )) && {
        sqrt "$x" "$2"
        globals[$2]="$(( (args[0]<<16)/globals[$2] )) $(( (args[1]<<16)/globals[$2] )) $(( (args[2]<<16)/globals[$2] ))"
    } || globals[$2]="0 0 0"
}

# (vertex: vector3, transformation: matrix4x4) -> vector3
vector3.transformW() {
    local -a args=( ${*} )
    local -i w x y z

    (( w = ((args[0]*args[6])>>16) + ((args[1]*args[10])>>16) + ((args[2]*args[14])>>16) + args[18] ))
    (( x = (( ((args[0]*args[3])>>16) + ((args[1]*args[7])>>16) + ((args[2]*args[11])>>16) + args[15]) << 16) / w ))
    (( y = (( ((args[0]*args[4])>>16) + ((args[1]*args[8])>>16) + ((args[2]*args[12])>>16) + args[16]) << 16) / w ))
    (( z = (( ((args[0]*args[5])>>16) + ((args[1]*args[9])>>16) + ((args[2]*args[13])>>16) + args[17]) << 16) / w ))
    globals[$3]="$x $y $z"
}
