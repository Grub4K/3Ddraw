#!/bin/env bash

declare EMPTY_LINE
declare -a lines

EMPTY_LINE=""
for (( i = 0; i <= globals[width]; i++ )); do
    EMPTY_LINE="000000${EMPTY_LINE}"
done

EMPTY_LINE="${EMPTY_LINE//000000/112233}"
lines=()
for (( i = 0; i <= globals[height]; i++ )); do
    lines+=( "${EMPTY_LINE}" )
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

renderer.clearScreen() {
    lines=()
    for (( i = 0; i <= ${globals[height]}; i++ )); do
        lines+=( "${EMPTY_LINE}" )
    done
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
    (( x=((point[0]* globals[width] )>>radix) + globals[width] / 2, y=((-point[1]* globals[height] )>>radix) + globals[height] / 2 ))
    globals[point]="$x $y"
}
