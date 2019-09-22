// Rounded Parametric Frame Vertex by Whosawhatsis
// 2010.06.18
// 
// I don't know if it's an improvement, but I wanted to learn OpenSCAD and
// wondered what this would look like with smooth, round edges. It is
// completely rewritten, but the holes are aligned with the original, so
// it should work as a drop-in replacement.
// 
// The DXF file is no longer required.
//
// Derived from Parametric Frame Vertex 4-hole by Ethan Dicks
// 2010.02.11
// http://www.thingiverse.com/thing:1799
//
// After calculating the time it would take to print this part
// on a 7mm/s Repstrap (McWire), I decided it would be a good idea
// to tune the part for build-time efficiency.  The middle three
// holes are not presently used in the Mendel, and printing them
// adds almost 10% to the print time (and increases the raw material
// required about 5%).  It might not make a difference on a 28mm/s
// Cupcake, but for slow Repstraps, it's significant time savings.
//
// The associated DXF file (vertex-body-fixed-qcad.dxf) needs no changes.
//
// Derived from Parametric Frame Vertex by Tonokip
// 2009.02.08
// http://www.thingiverse.com/thing:1780
//
// Vertex Body derived from: frame-vertex_6off.aoi::body - edges
// http://reprap.svn.sourceforge.net/viewvc/reprap/trunk/mendel/mechanics/solid-models/cartesian-robot-m4/printed-parts/
// Fixed body geometry flaw per http://dev.forums.reprap.org/read.php?1,30132,30398
//
// License GNU GPL v2 or newer.

M8=4.5; //RADIUS for M8 hole
FN=180; //facets in an arc

module teardrop (radius, length, angle) {
	rotate (a = [90, -45, angle + 90]) union() {
		cylinder (r = radius, h = length, center = true, $fn=FN);
		translate ([0, 0, -length/2]) cube (size = [radius, radius, length], center = false);
	}
}

difference() {
	union() {
		difference() {
			cylinder(h = 20, r = 55, center = true, $fn=FN);
			cylinder(h = 50, r = 25, center = true, $fn=FN);
			for (angle = [-130,130]) rotate (a = angle) translate (v = [0, -60, -15]) cube(size = [60, 120, 30]);
		}
		for (angle = [-40,40]) rotate (a = angle) translate(v = [40, 0, 0]) cylinder(h = 20, r=15, center = true, $fn=FN);
	}
	for (angle = [-30,30]) teardrop(M8, 120, angle);
	for (angle = [-47, 47]) rotate (a = angle) translate(v = [40, , 0]) cylinder (h = 30, r = M8, center = true, $fn=FN);
}