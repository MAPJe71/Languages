rodsize = 6;
rodspacing = 30;
partthick = rodsize * 2;
nutsize = rodsize * 2;

module z_leadscrew_nut_clamp() difference() {
	union() {
		linear_extrude(height = partthick / 2 + nutsize, center = true, convexity = 5) difference() {
			union() {
				for(side = [1, -1]) translate([side * rodspacing / 2, 0, 0]) circle(r = partthick / 2, center = true);
				square([rodspacing, partthick / 2 + rodsize * sin(45)], center = true); 
				square([partthick / 2 + nutsize, partthick / 2 + rodsize * sin(45) + rodsize], center = true); 
			}
			for(side = [1, -1]) translate([side * rodspacing / 2, 0, 0]) circle(r = rodsize / 2, center = true);
			square([rodspacing, rodsize * sin(45)], center = true); 
		}
	}
	rotate([90, 0, 0]) cylinder(r = rodsize / 2 + 0.5, h = partthick / 2 + rodsize * sin(45) + rodsize + 1, center = true);
	for(side = [1, -1]) translate([0, side * (rodsize * sin(45) / 2 + partthick / 2), 0]) rotate([90, 0, 0]) cylinder(r = partthick / 2, h = partthick / 2, center = true, $fn = 6);
}

translate([0, 0, partthick / 2]) z_leadscrew_nut_clamp(); 