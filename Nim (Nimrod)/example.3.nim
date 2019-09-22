# Example 3 - Keeping it clean with subdirectories

parameter x float range from 1 to 10 step 1;

task main
    node:execute ${HOME}/bin/fileCreator ${x}
    copy node:file* output.${x}/
endtask
