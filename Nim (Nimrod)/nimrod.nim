parameter x float range from 1 to 10 step 1;
parameter y float range from -4 to 5 step 1;

task main
    onerror fail
    node:execute /bin/echo X:${x} Y:${y} > output
    onerror ignore
    node:execute /bin/sleep ${y}
    onerror fail
    copy node:output output.${x}.${y}
endtask