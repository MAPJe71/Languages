# Example 5 - Command substitution

parameter x float range from 1 to 10 step 1;
parameter y float range from 1 to 10 step 1;

task main
    node:execute /bin/echo X:${x} Y:${y} > output
    copy node:output output.`expr ${y} \* 10 + ${x}`
endtask
