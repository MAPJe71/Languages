# Example 4 - Parameter Substitution

parameter x float range from 1 to 10 step 1;

task main
    copy inputfile.sub node:.
    node:subsitute inputfile.sub inputfile
    node:execute ${HOME}/bin/program inputfile
    copy node:output output.${x}
endtask
