$fs=0.35;
$fa=1;

function arclawcos(a,b,c) = acos((a*a+b*b-c*c)/2/a/b);

tol = 0.01;
nthumb = 4;
thumb = 17;
// no larger than 44/2
bigr = 15;
h=8;
ht = h+tol*2;
//axle1 = 6/2; // 1/4" = 6.35mm
//axle2 = 7/2;
axle1 = 6.7/2;
axle2 = 5.9/2;
off=3;
rinc = 360/nthumb;
thumbdeg = arclawcos(bigr, bigr+(thumb/2-off), thumb);
rdeg = rinc - thumbdeg;
round =  bigr *sin(rdeg/2);
echo ("roff=",round*cos(rdeg/2), "round=",round);
roff=0;
//roff = round*sin(rdeg/2);
roff = round-round*cos(rdeg/2);

// old hand picked values
////round = 9/2;
////roff=1.8;

echo ("thumbdeg=",thumbdeg, "rdeg=",rinc-thumbdeg);

tophath = 3;
//tophatr = bigr;
tophatr=0;

difference(){
  union() {
    // center
    cylinder(r=bigr, h=h);
    // round ends
    for (i=[0:nthumb]){
      rotate([0,0,rinc*i+rinc/2])
	translate([bigr-roff,0,0])
	cylinder(r=round, h=h);
    }
  }
  // cut out
  for  (i=[0:nthumb]){
    rotate([0,0,rinc*i])
      translate([bigr+off,0,-tol]){
      cylinder(r=thumb/2, h=ht);
//%      cylinder(r=thumb/2, h=ht);
    }      
  }
  // center hole
  translate([0,0,-tol])
    cylinder(r1=axle1, r2=axle2, h=ht);
}
// top hat
if (tophatr>0){
  translate([0,0,h]) intersection() {
     translate([-tophatr, -tophatr, 0]) cube([tophatr*2,tophatr*2,tophath]);
     translate([0,0,-tophatr+tophath]) sphere(r=tophatr);
  }
}
