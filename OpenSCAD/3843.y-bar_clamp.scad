rodsize = 8;
fn = 90;

partthick = rodsize * 2;

module rod(length) cylinder(h = length, r = rodsize / 2, center = true, $fn = fn);

module ybar_clamp() difference() {
	union() {
		translate([0, 0, -rodsize / 2]) cube([partthick, partthick, rodsize], center = true);
		translate([0, -partthick / 4, partthick / 4]) cube([partthick, partthick / 2, partthick / 2], center = true);
		rotate([0, 90, 0]) cylinder(h = partthick, r = partthick / 2, center = true, $fn = fn);
		translate([0, 0, -rodsize]) rotate([90, 0, 0]) cylinder(h = partthick, r = partthick / 2, center = true, $fn = fn);
	}
	translate([0, 0, partthick - rodsize]) cube([rodsize * sin(45), partthick * 2, partthick * 2], center = true);
	rotate([0, 90, 0]) rod(partthick + 1);
	translate([0, 0, -rodsize]) rotate([90, 0, 0]) rod(partthick + 1);
}

translate([0, 0, partthick / 2]) rotate([90, 0, 0]) ybar_clamp();