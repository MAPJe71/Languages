// I modified the original Libs.scad library. Else the rendering of teardrop objects takes
// forever (due to a bug in OpenScad, I guess).
// Therefore I recommend to use the Libs.scad library from http://www.thingiverse.com/thing:7656
// Copy the Libs.scad file in the same directory as this file.
//
// For reference and credit:
// Get the original Libs.scad by Randy Young here: http://www.thingiverse.com/thing:6021

include <Libs.scad>

upperBracketPart1();
//upperBracketPart2();
//lowerBracket();

module gleitlagerBlock()
{
	difference() {
		translate([0,-2,0]) cube([35,20,15], center=true);
		union()
		{
			cylinder(h=22, r=8.25, center=true);
			translate([0,5,0]) cube([16.5,9,20], center=true);
		}	
	}
}

module lowerBracket()
{
	union()
	{	
	difference()
	{
		translate([0,-5.5,0])cube([80, 44, 15], center = true);
		cylinder(h=20, r=11.5, center=true);
		translate ([30,0,0]) rotate([0,0,90]) teardrop(2, 55);
		translate ([-30,0,0]) rotate([0,0,90]) teardrop(2, 55); 
		translate ([0,15,11]) rotate([0,90,90]) cylinder(h=29, r=12, center=true);
	}
		translate ([40,-27.5,-7.0]) cylinder(h=1, r=4, center=true);
		translate ([40,16.5,-7.0]) cylinder(h=1, r=4, center=true);
		translate ([-40,-27.5,-7.0]) cylinder(h=1, r=4, center=true);
		translate ([-40,16.5,-7.0]) cylinder(h=1, r=4, center=true);
	}
}


module upperBracket()
{
	difference()
	{
		translate([0,0,3]) cube([80, 30, 58], center = true);
		rotate([90,0,0]) cylinder(h=31, r1=23.75, r2=24, center=true);
		translate ([30,0,0]) cylinder(h=65, r=2.2, center=true);
		translate ([-30,0,0]) cylinder(h=65, r=2.2, center=true); 
	}
}

module upperBracketPart1()
{
	union()
	{	
	difference()
	{
		upperBracket();
		translate ([0,0,19]) cube([81, 31, 40], center = true);
	}
		translate ([40,-15,-25.5]) cylinder(h=1, r=4, center=true);
		translate ([40,15,-25.5]) cylinder(h=1, r=4, center=true);
		translate ([-40,-15,-25.5]) cylinder(h=1, r=4, center=true);
		translate ([-40,15,-25.5]) cylinder(h=1, r=4, center=true);
	}
}

module upperBracketPart2()
{
	union()
	{	
	rotate([180,0,0]) difference()
	{
		upperBracket();
		translate ([0,0,-19]) cube([81, 31, 40], center = true);
	}
		translate ([40,-15,-31.5]) cylinder(h=1, r=4, center=true);
		translate ([40,15,-31.5]) cylinder(h=1, r=4, center=true);
		translate ([-40,-15,-31.5]) cylinder(h=1, r=4, center=true);
		translate ([-40,15,-31.5]) cylinder(h=1, r=4, center=true);
	}
}

//gleitlagerBlock();
//upperBracket();
