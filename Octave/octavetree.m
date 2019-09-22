#! octave

# https://wiki.octave.org/wiki/images/5/50/Octavetree.m

N= input("Height (best 25):");
H= input("Trunk height (best 7):");
g= input("Density of decoration <0,1> (best 0.2):");

for i=1:N
  for j=1:N-i
     printf(" ");
  end
  for j=1:2*i-1
    z = rand();
     if (z<g)
      printf("@");
     else
      printf("*");
     endif
  endfor
  printf("\n");
end
for i=1:H
  for j=1:N-2
    printf(" ");
  end
    printf("***\n");
end
i=0;
printf("2012");
while 1
  i = mod(i,2*N);
  for j=1:i
    printf(" ");
  end
  if i<2*N-2
    printf("mmmDDD");
  else
    printf("  2013");
  endif
  pause(0.1)
  printf("\r2012");
  i = i+1;
endwhile 
