#!/bin/env bash

declare -i radix=8
declare -A globals

(( globals[width]=40, globals[height]=30 ))

source ./math.sh
source ./vector3.sh
source ./matrix4x4.sh
source ./renderer.sh

declare -i x=0 y=0 yaw=200 pitch=300
main() {
    # Once per aspect ratio change
    matrix4x4.perspectiveFovRH 200 "$(( globals[width]*one/globals[height] ))" 3 256 projection
    echo "${globals[projection]}"

    # Once per camera movement
    matrix4x4.lookAtRH "0 0 $((10 * one))" "0 0 0" "0 $one 0" view
    matrix4x4.mul "${globals[view]}" "${globals[projection]}" view
    echo "${globals[view]}"

    while true; do
        (( yaw += 10, pitch += 15 ))

        matrix4x4.translation "$x $y 0" world
        echo "${globals[world]}"
        matrix4x4.yawPitchRoll "$yaw" "$pitch" 0 rotation
        matrix4x4.mul "${globals[world]}" "${globals[rotation]}" world
        echo "${globals[rotation]}"
        echo "${globals[world]}"

        matrix4x4.mul "${globals[world]}" "${globals[view]}" transform
        echo "${globals[transform]}"

        # transformation="308 155 184 182 -351 143 161 160 3 588 -90 -88 0 0 2586 2560"
        # transformation="78848 39680 47104 46592 -89856 36608 41216 40960 768 150528 -23040 -22528 0 0 662016 655360"

        cubeVertices=()
        for z in $one -$one; do
            for y in $one -$one; do
                for x in $one -$one; do
                    cubeVertices+=( "$x $y $z" )
                done
            done
        done
        cubeTris=( "0 1 2" "1 2 3" "1 3 7" "1 5 7" "0 1 4" "1 4 5" "2 3 6" "3 7 6" "0 2 6" "0 4 6" "4 5 7" "4 7 6" )

        points=()
        for cubeVertex in "${cubeVertices[@]}"; do
            renderer.project "$cubeVertex" "${globals[transform]}" point
            points+=( "${globals[point]}" )
        done

        renderer.clearScreen

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
        # sleep 1
    done
}

clear && main
