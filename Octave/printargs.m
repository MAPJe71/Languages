#! /bin/octave -qf

# For example, the following program will reproduce the command line that 
# was used to execute the script, not ‘-qf’.

printf ("%s", program_name ());
arg_list = argv ();
for i = 1:nargin
  printf (" %s", arg_list{i});
endfor
printf ("\n");
