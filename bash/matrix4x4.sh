#!/bin/env bash
# source ./math.sh
# source ./vector3.sh

# (a: matrix4x4, b: matrix4x4) -> matrix4x4
matrix4x4.mul() {
    args=( ${*} )

    (( a=((args[0]*args[0+16])>>radix) + ((args[1]*args[4+16])>>radix) + ((args[2]*args[8+16])>>radix) + ((args[3]*args[12+16])>>radix) ))
    (( b=((args[0]*args[1+16])>>radix) + ((args[1]*args[5+16])>>radix) + ((args[2]*args[9+16])>>radix) + ((args[3]*args[13+16])>>radix) ))
    (( c=((args[0]*args[2+16])>>radix) + ((args[1]*args[6+16])>>radix) + ((args[2]*args[10+16])>>radix) + ((args[3]*args[14+16])>>radix) ))
    (( d=((args[0]*args[3+16])>>radix) + ((args[1]*args[7+16])>>radix) + ((args[2]*args[11+16])>>radix) + ((args[3]*args[15+16])>>radix) ))
    (( e=((args[4]*args[0+16])>>radix) + ((args[5]*args[4+16])>>radix) + ((args[6]*args[8+16])>>radix) + ((args[7]*args[12+16])>>radix) ))
    (( f=((args[4]*args[1+16])>>radix) + ((args[5]*args[5+16])>>radix) + ((args[6]*args[9+16])>>radix) + ((args[7]*args[13+16])>>radix) ))
    (( g=((args[4]*args[2+16])>>radix) + ((args[5]*args[6+16])>>radix) + ((args[6]*args[10+16])>>radix) + ((args[7]*args[14+16])>>radix) ))
    (( h=((args[4]*args[3+16])>>radix) + ((args[5]*args[7+16])>>radix) + ((args[6]*args[11+16])>>radix) + ((args[7]*args[15+16])>>radix) ))
    (( i=((args[8]*args[0+16])>>radix) + ((args[9]*args[4+16])>>radix) + ((args[10]*args[8+16])>>radix) + ((args[11]*args[12+16])>>radix) ))
    (( j=((args[8]*args[1+16])>>radix) + ((args[9]*args[5+16])>>radix) + ((args[10]*args[9+16])>>radix) + ((args[11]*args[13+16])>>radix) ))
    (( k=((args[8]*args[2+16])>>radix) + ((args[9]*args[6+16])>>radix) + ((args[10]*args[10+16])>>radix) + ((args[11]*args[14+16])>>radix) ))
    (( l=((args[8]*args[3+16])>>radix) + ((args[9]*args[7+16])>>radix) + ((args[10]*args[11+16])>>radix) + ((args[11]*args[15+16])>>radix) ))
    (( m=((args[12]*args[0+16])>>radix) + ((args[13]*args[4+16])>>radix) + ((args[14]*args[8+16])>>radix) + ((args[15]*args[12+16])>>radix) ))
    (( n=((args[12]*args[1+16])>>radix) + ((args[13]*args[5+16])>>radix) + ((args[14]*args[9+16])>>radix) + ((args[15]*args[13+16])>>radix) ))
    (( o=((args[12]*args[2+16])>>radix) + ((args[13]*args[6+16])>>radix) + ((args[14]*args[10+16])>>radix) + ((args[15]*args[14+16])>>radix) ))
    (( p=((args[12]*args[3+16])>>radix) + ((args[13]*args[7+16])>>radix) + ((args[14]*args[11+16])>>radix) + ((args[15]*args[15+16])>>radix) ))

    globals[$3]="$a $b $c $d $e $f $g $h $i $j $k $l $m $n $o $p"
}

# (eye: vector3, target: vector3, up: vector3) -> matrix4x4
matrix4x4.lookAtRH() {
    vector3.sub "$1" "$2" zAxis
    vector3.norm "${globals[zAxis]}" zAxis

    vector3.cross "$3" "${globals[zAxis]}" xAxis
    vector3.norm "${globals[xAxis]}" xAxis

    vector3.cross "${globals[zAxis]}" "${globals[xAxis]}" yAxis
    vector3.norm "${globals[yAxis]}" yAxis

    # negate eye vector
    vector3.sub "0 0 0" "$1" eye

    vector3.dot "${globals[xAxis]}" "${globals[eye]}" ex
    vector3.dot "${globals[yAxis]}" "${globals[eye]}" ey
    vector3.dot "${globals[zAxis]}" "${globals[eye]}" ez

    local -a data=( ${globals[xAxis]} ${globals[yAxis]} ${globals[zAxis]} )
    globals[$4]="${data[0]} ${data[3]} ${data[6]} 0 ${data[1]} ${data[4]} ${data[7]} 0 ${data[2]} ${data[5]} ${data[8]} 0 ${globals[ex]} ${globals[ey]} ${globals[ez]} $one"
}

# (fov: decimal, aspect: decimal, zNear: decimal, zFar: decimal) -> matrix4x4
matrix4x4.perspectiveFovRH() {
    local -i tan fRange
    sin "$(( $1 >> 1 ))" sin
    cos "$(( $1 >> 1 ))" cos
    (( tan = (${globals[cos]} << radix) / ${globals[sin]}, fRange = ($4 << radix) / ($3 - $4) ))

    globals[$5]="$(( (tan << radix) / $2 )) 0 0 0 0 $tan 0 0 0 0 $fRange -$one 0 0 $(( (fRange * $3)>>radix )) 0"
}

# (offset: vector3) -> matrix4x4
matrix4x4.translation() {
    globals[$2]="$one 0 0 0 0 $one 0 0 0 0 $one 0 $1 $one"
}

# (angle: decimal) -> matrix4x4
matrix4x4.rotX() {
    sin "$1" sin
    cos "$1" cos
    globals[$2]="$one 0 0 0 0 ${globals[cos]} ${globals[sin]} 0 0 -${globals[sin]} ${globals[cos]} 0 0 0 0 $one"
}

# (angle: decimal) -> matrix4x4
matrix4x4.rotY() {
    sin "$1" sin
    cos "$1" cos
    globals[$2]="${globals[cos]} 0 -${globals[sin]} 0 0 $one 0 0 ${globals[sin]} 0 ${globals[cos]} 0 0 0 0 $one"
}

# (angle: decimal) -> matrix4x4
matrix4x4.rotZ() {
    sin "$1" sin
    cos "$1" cos
    globals[$2]="${globals[cos]} ${globals[sin]} 0 0 -${globals[sin]} ${globals[cos]} 0 0 0 0 $one 0 0 0 0 $one"
}

# (yaw: decimal, pitch: decimal, roll: decimal) -> matrix4x4
matrix4x4.yawPitchRoll() {
    matrix4x4.rotX "$2" "$4"
    matrix4x4.rotY "$3" temp
    echo "${globals[$4]}"
    echo "${globals[temp]}"
    matrix4x4.mul "${globals[$4]}" "${globals[temp]}" "$4"
    matrix4x4.rotZ "$1" temp
    echo "${globals[temp]}"
    matrix4x4.mul "${globals[temp]}" "${globals[$4]}" "$4"
}
