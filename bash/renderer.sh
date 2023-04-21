#!/bin/env bash

declare -A globals
declare -i width height
declare EMPTY_LINE
declare -a lines

source ./math.sh

(( globals[width]=500, globals[height]=300 ))

globals[EMPTY_LINE]=""
for (( i = 0; i <= globals[width]; i++ )); do
    globals[EMPTY_LINE]="000000${globals[EMPTY_LINE]}"
done

globals[EMPTY_LINE]="${globals[EMPTY_LINE]//000000/112233}"
lines=()
for (( i = 0; i <= globals[height]; i++ )); do
    lines+=( "${globals[EMPTY_LINE]}" )
done

# (x: int, y: int, color: color)
renderer.putPixel() {
    lines[$2]="${lines[$2]::$((6*$1))}$3${lines[$2]:$((6*($1+1))):${#lines[$2]}}"
}

# (xStart: int, yStart: int, xEnd: int, yEnd: int, color: color)
renderer.drawLine() {
    local -i dx dy x y sx sy max threshold

    (( dx=$1-$3, dy=$2-$4, x=$1, y=$2 ))

    (( $1 < $3 )) && (( sx = 1, dx = -dx )) || (( sx = -1 ))
    (( $2 < $4 )) && (( sy = 1, dy = -dy )) || (( sy = -1 ))
    (( $dx > $dy )) && (( max = dx )) || (( max = dy ))

    (( threshold = dx-dy, dy = -dy ))

    for (( i = 0; i <= $max; i++ )); do
        renderer.putPixel "$x" "$y" "$5"

        (( error = 2 * threshold ))

        (( error > dy )) && (( threshold += dy, x += sx ))
        (( error < dx )) && (( threshold += dx, y += sy ))
    done
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

renderer.drawScreen() {
    printf '\e[0H'
    for line in "${lines[@]}"; do
        printf '\e[48;2;%d;%d;%dm  ' $(sed "s/../0x\0 /g" <<<"$line" )
        printf '\e[0m\n'
    done
}

# (vertex: vector3, transformation: matrix4x4) -> vector2
renderer.project() {
    local -a point
    local -i x y

    vector3.transformW "$1" "$2" point
    point=( ${globals[point]} )
    (( x=((point[0]* globals[width] )>>16) + globals[width] / 2, y=((-point[1]* globals[height] )>>16) + globals[height] / 2 ))
    globals[point]="$x $y"
}

renderer.test() {
    # transformation="308 155 184 182 -351 143 161 160 3 588 -90 -88 0 0 2586 2560"
    transformation="78848 39680 47104 46592 -89856 36608 41216 40960 768 150528 -23040 -22528 0 0 662016 655360"

    # Clear line buffer
    lines=()
    for (( i = 0; i <= $height; i++ )); do
        lines+=( "${globals[EMPTY_LINE]}" )
    done

    cubeVertices=()
    for z in 65536 -65536; do
        for y in 65536 -65536; do
            for x in 65536 -65536; do
                cubeVertices+=( "$x $y $z" )
            done
        done
    done
    cubeTris=( "0 1 2" "1 2 3" "1 3 7" "1 5 7" "0 1 4" "1 4 5" "2 3 6" "3 7 6" "0 2 6" "0 4 6" "4 5 7" "4 7 6" )

    points=()
    for cubeVertex in "${cubeVertices[@]}"; do
        renderer.project "$cubeVertex" "$transformation" point
        points+=( "${globals[point]}" )
    done

    for cubeTri in "${cubeTris[@]}"; do
        cubeTri=(${cubeTri})
        (( a=cubeTri[0], b=cubeTri[1], c=cubeTri[2] ))
        renderer.drawLine ${points[$a]} ${points[$b]} "ff0000"
        renderer.drawLine ${points[$b]} ${points[$c]} "00ff00"
        renderer.drawLine ${points[$c]} ${points[$a]} "0000ff"
    done

    for point in "${points[@]}"; do
        renderer.putPixel $point "00aaff"
    done

    # poor mans anti tearing
    printf '%s\n' "$( renderer.drawScreen )"
}

clear && renderer.test
