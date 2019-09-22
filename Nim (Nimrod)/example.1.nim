# Example 1 - Simple

parameter var0 float range from 1 to 500 step 1;

task main
    copy inputfile node:output
    node:execute /bin/uname -a >> output
    copy node:output output.${var0}
endtask
