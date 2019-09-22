/**
 * Parametric Chassis - Version 001
 * ================================
 *
 * by Bernhard "HotKey" Slawik, http://www.bernhardslawik.de
 * Have fun! MakerBot FTW!
 *
 */

l = 35;		// Length (x-size) (Matchbox: 60)
w = 25;		// Width (y-size) (Matchbox: 36)
h = 12;		// Height (z-size) (Matchbox: 15; Recommendation add an extra mm for each 7.5mm)

wall = 1.0;			// Wall thickness [mm]
					//	1mm: (recommended)
					//		Floor: 3 solid layers
					//		Side : 2 layers, no filling

floorOverlap = 2.5;						// Overlapping of floor wall into top piece [mm] (Recommendation: > 2mm)

boltRadius = (3.0 / 2) - 0.25;			// Radius of bolts (bolt holes)
boltSlantExtraRadius = 0.75 + 0.25;		// Watch out! Don't make it too close to the outer walls! Leave ~1mm
boltSlantHeight = 1.0;					// Watch out! Keep the slant angle > 45 deg. (i.e. boltSlantHeight > boltSlantExtraRadius)

// Internals
boltWall = 1.5;							// Strength of bolt-surrounding (Recommendation: > 1mm)
boltIndent = boltRadius*2 + boltWall*2;	// Spacing for bolts and overlap [mm]

boltSides = 12;							// Number of sides for bolt holes
extra = 0.5;								// Extra overlap For boolean operations



boltPositions = [
	[-boltIndent/2, -boltIndent/2, 0],
	[-boltIndent/2, w + boltIndent/2, 0],
	
	[l/2, -boltIndent/2, 0],				// Comment out these two lines if you only want 4 bolts in the corners
	[l/2, w + boltIndent/2, 0],

	[l + boltIndent/2, -boltIndent/2, 0],
	[l + boltIndent/2, w + boltIndent/2, 0]
];


module chassis(l, w, h) {
	//cube([l, w, h]);
	s = w + boltIndent*2 + wall*2;

	translate([-l/2, -w/2, 0]) {


	// Generate TOP and BOTTOM at the same time

		// Floor
		translate([0, -(s/2 + extra), wall])		chassisFloor(l, w, h);

		// Top
		translate([0, w + (s/2 + extra), h + wall])
			rotate([180, 0, 0])
				chassisTop(l, w, h);

	// Generate parts separately
/*
		// Floor
		translate([0, 0, wall])		chassisFloor(l, w, h);
*/
/*
		// Top
		translate([0, w, h + wall])
			rotate([180, 0, 0])
				chassisTop(l, w, h);
*/


	}

}


module bolt(bh) {
	difference() {
		// Perfect cylinder wall
		//cylinder(r = boltRadius+boltWall, h = bh, $fn = boltSides);

		// Heavy cubic wall
		translate([-boltIndent/2, -boltIndent/2, 0]) {
			cube([boltIndent, boltIndent, bh]);
		}

		cylinder(r = boltRadius, h = bh, $fn = boltSides);
	}
}
module boltHole(bh) {
	union() {
		// Hole
		translate([0, 0, -extra]) {
			cylinder(r = boltRadius, h = bh + extra*2, $fn = boltSides);
		}

		// Slant
		cylinder(r1 = boltRadius+boltSlantExtraRadius, r2 = boltRadius, h = boltSlantHeight, $fn = boltSides);

	}
}

module chassisFloor(l, w, h) {
	difference() {
		union() {
			// Sub-Floor
			translate([-(wall + boltIndent), -(wall + boltIndent), -wall])
				cube([l + (wall + boltIndent)*2, w + (wall + boltIndent)*2, wall]);

			// Overlapping Block ("Bolt indent")
			translate([-boltIndent, -boltIndent, 0])
				cube([l + boltIndent*2, w + boltIndent*2, floorOverlap]);
		}

		// Minus...
		union() {
			// The space itself
			cube([l, w, floorOverlap + extra]);

/*
			// Thinnen it out
			translate([-(boltIndent - wall), 0, 0])
				cube([l + (boltIndent - wall)*2, w, floorOverlap + extra]);

			translate([0, -(boltIndent - wall), 0])
				cube([l, w + (boltIndent - wall)*2, floorOverlap + extra]);
*/

			// Bolt-Holes on floor plane
			translate([0, 0, -wall]) {
				for (p = boltPositions) {
					translate(p)
						boltHole(wall + floorOverlap);
				}
			}

		}
	}
}


module chassisTop(l, w, h) {
	union() {
		difference() {
			// Ewwrifing
			translate([-(wall + boltIndent), -(wall + boltIndent), 0])
				cube([l + (wall + boltIndent)*2, w + (wall + boltIndent)*2, h + wall]);

			// Inner
			translate([-boltIndent, -boltIndent, 0])
				cube([l + boltIndent*2, w + boltIndent*2, h]);
		}

		// Bolts in top part
		translate([0, 0, floorOverlap]) {
			for (p = boltPositions) {
				translate(p)
					bolt(h - floorOverlap);
			}
		}
	}
}



// Provide the INNER dimension of the box (the space YOU need). Real dimensions will be "plus 2x wall"
chassis(l, w, h);

