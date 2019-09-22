
// In case you want to see the original for comparison purposes
module drag_chain_extruder_end_orig() {
    translate([-26,0,0]) {
        import_stl("EndCornerExtruder_optional.stl");
    }
}

module drag_chain_extruder_end() {
    translate([0,-8,0]) {
        difference () {
            union() {
                translate([-6,0,0]) cube([41,16,11]);
                // Tab
                translate([25,0,10]) cube([10,16,10]);
                //translate([-4.5, 16, 9.5]) rotate([90,-90,0]) cylinder(r=1.5, h=16, $fn=30);
            }
            union() {
                translate([-1, 4, 1.5]) cube([37,8,10]);
                translate([10, 25, 10.5]) rotate([90,-90,0]) cylinder(r=3.5, h=38, $fn=3);
                translate([-4.5, 17, 9.5]) { // rounded tops
                    difference() {
                        translate([-3, -18, 0]) cube([3, 18, 3]);
                        translate([0,1,0]) rotate([90,-90,0]) cylinder(r=1.5, h=20, $fn=30);
                    }
                }
                // Space around pivots
                translate([-3, 14.5, 6.75]) rotate([90,-90,0]) cylinder(r=6, h=13, $fn=30);

                translate([-7,-1,-1]) cube([7,19,2.5]);
                translate([0,-1,1.5]) rotate([0,-135,0]) cube([10,19,10]);

                // Tab
                translate([30, 25, 15]) rotate([90,-90,0]) cylinder(r=1.8, h=38, $fn=30);
            }
        }
        translate([-3,10.75, 8]) rotate([-90,0,0]) cylinder(r1=0, r2=2, h=4, $fn=30);
        translate([-3,5.25, 8]) rotate([90,0,0]) cylinder(r1=0, r2=2, h=4, $fn=30);
    }
}
//drag_chain_extruder_end_orig();
translate([-18,0,0]) 
  drag_chain_extruder_end();
