#!/bin/bash
# Based on: https://gist.github.com/XVilka/8346728

awk -v columns=$(tput cols || echo 80) 'BEGIN{
    for (column = 0; column<columns; column++) {
        r = (column*255/columns);
        g = (column*255/columns);
        b = (column*255/columns);
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "%s\033[0m", " ";
    }
    printf "\n\n";
    for (column = 0; column<columns; column++) {
        r = 255-(column*255/columns);
        g = (column*510/columns);
        b = (column*255/columns);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "%s\033[0m", " ";
    }
}'
