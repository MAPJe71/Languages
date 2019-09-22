// Grooved Insulator Mount Adapter #3
// by Tony Buser <tbuser@gmail.com>
// uses teardrop module by Erik de Bruijn <info@erikdebruijn.nl>
// GPLv2 or later

// set them slightly larger if printer isn't perfect
barrel_diameter = 16.9; // 16 + .6
barrel_inset_diameter = 13.4; // 13 + .2

plate_length = 40;
plate_width = 25;

// probably don't want to touch the height
plate_height = 10;

// mounting bolts will need to be 15mm long?
mounting_bolt_diameter = 3.4;

// for standard plastruder - left = 13, right = 13
// for printruder II - left = 14, right = 11
left_mounting_bolt_distance = 13;
right_mounting_bolt_distance = 13;

// single horizontal bolt to clamp and hold insulator in place
// will need to be around 45mm long?
clamp_bolt_diameter = 4.2;

$fn = 32;

module teardrop(radius,height,truncated) {
	truncateMM = 1;
	union() {
		if (truncated == true) {
			intersection() {
				translate([0,0,height/2]) scale([1,1,height]) rotate([0,0,180]) cube([radius*2.5,radius*2,1],center=true);
				scale([1,1,height]) rotate([0,0,3*45]) cube([radius,radius,1]);
			}
		}
		if (truncated == false) {
			scale([1,1,height]) rotate([0,0,3*45]) cube([radius,radius,1]);
		}
		cylinder(r=radius, h = height);
	}
}

module plate() {
	difference() {
		union() {
			cube([plate_length, plate_width, plate_height]);

			// mounting bolt reinforcement
			translate([0, -plate_width/3+5, 0]) {
				cube([plate_length/3, plate_width/3-5, plate_height]);
			}

			translate([plate_length-plate_length/3, -plate_width/3+5, 0]) {
				cube([plate_length/3, plate_width/3-5, plate_height]);
			}
		}

		// barrel top
		translate([plate_length/2, plate_width/2, plate_height/2]) {
			cylinder(r=barrel_diameter/2, h=plate_height/2+1);
		}

		// barrel inset
		translate([plate_length/2, plate_width/2, -1]) {
			cylinder(r=barrel_inset_diameter/2, h=plate_height/2+2);
		}

		// mounting bolt left hole
		translate([plate_length/2-left_mounting_bolt_distance, plate_width/2, -1]) {
			cylinder(r=mounting_bolt_diameter/2, h=plate_height+2);
		}

		// mounting bolt right hole
		translate([plate_length/2+right_mounting_bolt_distance, plate_width/2, -1]) {
			cylinder(r=mounting_bolt_diameter/2, h=plate_height+2);
		}

		/*
		// mounting bolt head space left
		translate([plate_length/2-14, plate_width/2, -1]) {
			cylinder(r=mounting_bolt_head_diameter/2, h=plate_height/2+1);
		}

		// mounting bolt head space right
		translate([plate_length/2+11, plate_width/2, -1]) {
			cylinder(r=mounting_bolt_head_diameter/2, h=plate_height/2+1);
		}
		*/

		// clamp bolt		
		translate([-1, plate_width/2-barrel_inset_diameter/2-clamp_bolt_diameter/2, plate_height/2-clamp_bolt_diameter/2]) {
			rotate([0, 90, 0]) {
				teardrop(clamp_bolt_diameter/2, plate_length+2, false);
			}
		}
	}
}

module cutout() {
	intersection() {
		// carve a curve around the border
		union() {
			translate([plate_length/2, plate_width/2/2, -1]) {
				cylinder(r=plate_length/2, h=plate_height+2);
			}
			translate([0, -plate_width/2/2-plate_width/2, -1]) {		
				cube([plate_length, plate_width, plate_height+2]);
			}
		}

		difference() {
			plate();

			// top cutout
			translate([plate_length/2-barrel_diameter/2, -10, plate_height/2]) {
				cube([barrel_diameter, plate_width/2+10, plate_height/2+1]);
			}

			// bottom cutout
			translate([plate_length/2-barrel_inset_diameter/2, -1, -1]) {
				cube([barrel_inset_diameter, plate_width/2+1, plate_height/2+2]);
			}

			// remove 0.5mm from bottom to make it slide on easier
			translate([-5,-5,-1]) {
				cube([plate_length+10, plate_width+10, 1.5]);
			}
		}
	}
}

module print() {	
	// center and orient it to print correctly
	translate([-plate_length/2, -plate_width/2, -0.5]) cutout();
}

//plate();
//cutout();
//reinforcement();
print();
