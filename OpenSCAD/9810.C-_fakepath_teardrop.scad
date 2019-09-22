// Improved teardrop library
// Copyright 2011, Matthew Roberts
//
// API Extends... http://www.thingiverse.com/thing:3457
// (code is all new)


// internal code - don't call this...
module teardrop2(r, l, a, a2, n) {
	rotate([0,a,0])
		assign(m=(a>45) ? sqrt(1 - pow(sin(90-a),2)) : 0)
		for (i = [1:n])
			assign(u=a2+360*i/n, v=a2+360*(i+1)/n)
			assign(x1=r*sin(u), y1=r*cos(u), x2=r*sin(v), y2=r*cos(v))
			union() {
				linear_extrude(height=l, center=true) polygon([[0,0], [x1,y1], [x2,y2]]);
				if (m > 0) {
					linear_extrude(height=l, center=true) polygon([[0,0], [x2-abs(y2)*m,0], [x2,y2]]);
					linear_extrude(height=l, center=true) polygon([[0,0], [x1,y1], [x1-abs(y1)*m,0]]);
				}
			}
}

/*
	teardrop

	 make sure to only specify one radius or diameter parameter - there are several to choose from
	"r" or "or" specify the maximum or outer radius of the object,
	"ir" specifies the minimum or inner radius
	"d", "od" and "id" are the same for specifying in terms of diameter - "id" is useful for specifying the across flats distance for nuts

	"length" is the length of the teardrop
	"angle" is the angle from vertical of the teardrop - 0 degrees is a vertical hole, 90 degrees is horizontal

	"fn" is the number of sides of the 'cylinder' - set to 6 for a teardrop hex nut
	"angle2" is the rotation of the 'cylinder' around its axis
*/

module teardrop(r=0, length, angle=90, angle2=0, fn=30, or=0,ir=0, d=0,od=0,id=0) {
	assign(a=1/cos(360/fn/2))
		if (r != 0) { teardrop2(r, length, angle, angle2, fn); }
		else if (or != 0) { teardrop2(or, length, angle, angle2, fn); }
		else if (ir != 0) { teardrop2(a*ir, length, angle, angle2, fn); }
		else if (d != 0) { teardrop2(d/2, length, angle, angle2, fn); }
		else if (od != 0) { teardrop2(od/2, length, angle, angle2, fn); }
		else if (id != 0) { teardrop2(a*id/2, length, angle, angle2, fn); }
}


// test code...
module test_teardrop(){
	translate([0,-60,0]) {
		translate([0, 0, 0]) teardrop(5, 20, 90);		// test compatibility with thing 3457
		translate([0, 15, 0]) teardrop(5, 20, 60);		// test compatibility with thing 3457
		translate([0, 30, 0]) teardrop(5, 20, 45);		// test compatibility with thing 3457
		translate([0, 45, 0]) teardrop(5, 20, 90, fn=6);
		translate([0, 60, 0]) teardrop(5, 20, 60, fn=6);
		translate([0, 75, 0]) teardrop(5, 20, 45, fn=6);
		translate([0, 90, 0]) teardrop(id=10, length=20, angle=45, fn=6, angle2=90);
		translate([0, 105, 0]) teardrop(id=10, length=20, angle=30, fn=5, angle2=45);
		translate([0, 120, 0]) teardrop(id=10, length=20, angle=70, fn=5, angle2=45);
	}
}

//test_teardrop();
