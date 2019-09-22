// it would be nice to bevel the deges, but we'll rely
// on build direction and skeinforge to do that for us
$fs=0.35;
$fa=1;

tol = 0.01;

basew = 25/2+1;  // wide enough for 1/2" double sided sticky tape with some slop

// ethernet
hole = 9;
gap = 6;

// power cable or video?
// hole = 12;
// gap = 7;

wall = 3;
basel = (hole + wall)*2;

sidecurveoff = wall*0.3;
sidecurvez = wall*0.9;
sidecurveh = basel/2+sidecurvez;
sidecurvew = basew/3;

difference() {
 union(){
  // base
  translate([0 , -basel/2, -wall])  cube([ basew, basel, wall ]);
  // body
  intersection() {
    rotate([0,90,0])
       cylinder(h=basew+tol*2, r=basel/2);
    translate([0,-basel/2, 0])
      cube([ basew, basel, basel/2]);
  }
 }
  // hole
  translate([-tol, 0, hole/2])
     rotate([0,90,0])
        cylinder(h=basew+tol*2, r=hole/2);
  // gap
  translate([-tol , -gap/2, hole/2-tol]) 
    cube([tol*2+basew, gap, tol*2+wall+hole/2]);
  // take a nick out of the top of the gap
  translate([-tol, 0, wall*1.4+hole])
    rotate([0,90,0])
       cylinder(h=basew+tol*2, r=gap/2+wall/2);
  // take some material off of the sides too
  translate([0,-basel/2-tol,sidecurveh-sidecurvez]) rotate([0,90,90]){   
    translate([0,sidecurveoff,0])
      scale([sidecurveh/10,sidecurvew/10,1])cylinder(h=basel+tol*2,r=10);
    translate([0,-basew-sidecurveoff,0])
      scale([sidecurveh/10,sidecurvew/10,1])cylinder(h=basel+tol*2, r=10);

  }
}