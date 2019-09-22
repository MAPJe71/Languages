/* NEMA17-to-27-adapter gasket
 * By Erik de Bruijn <info@erikdebruijn.nl>
 * GPLv2 or later
*/

// //////////////////////////////
// USER PARAMETERS
// //////////////////////////////
nema27 = 52-5.5;
nema27_holes = 5;// mm (the 4 holes that normally fit the nema 27)
nema27_cylinder_dia = 38.5;
nema17 = 30.0;//32
nema17_holes = 3;// mm (the 4 holes)
nema17_cilinder_dia = 22.05; // mm
use_flanged_bolts = 1; // 0=off or 1=on (for the 4 nema 17 holes)

// //////////////////////////////
// Includes
// //////////////////////////////
//<teardrop.scad>
// See the bottom of the script to comment it out if you don't want to use this include!


max_overhang = 30;
$fn=60;
$fa=0.1;


// //////////////////////////////
// OpenSCAD SCRIPT
// //////////////////////////////

rotate([180,0,0]) // turn around to make printable
	gasket();

module gasket()
{

	difference()
	{
		cube([nema27+3.5,nema27+3.5,4],center=true);

		// nema 17 cylinder
		translate ([0,0,-3])
			cylinder(r1=nema17_cilinder_dia/2,r2=nema17_cilinder_dia/2+0.5,h=6);

		// outer, nema 27 holes
		for(i=[0:3])
		{
			rotate([0,0,90*i])
				translate ([nema27/2,nema27/2,-3]) 
					#cylinder(r=nema27_holes/2,h=6);
		}

		// inner, nema 17 holes
		for(i=[0:3])
		{
			rotate([0,0,90*i])
				translate ([nema17/2,nema17/2,-3]) 
				{
					cylinder(r=nema17_holes/2,h=6);
					if(use_flanged_bolts == 1)
					#cylinder(r1=nema17_holes,r2=0,h=6);
				}
		}

		// material savings
		for(i=[0:3])
		{
			rotate([0,0,90*i])
				translate ([29+nema17/2,0,-3]) 
				{
					cylinder(r=50/2,h=6);
				}
		}
		translate ([0,0,-3])
			cylinder(
				r2=nema27_cylinder_dia/2,
				r1=nema27_cylinder_dia/2+0.5,
				h=3
			);
	}
}










// //////////////////////////////
// OpenSCAD LIBRARIES
// //////////////////////////////

module nut(nutSize,height)
{
// Based on some random measurements:
// M3 = 5.36
// M5 = 7.85
// M8 = 12.87
	hexSize = nutSize + 12.67 - 8; // only checked this for M8 hex nuts!!
	union()
	{
		 for(i=[0:5])
		{
			intersection()
			{
				rotate([0,0,60*i]) translate([0,-hexSize/2,0]) cube([hexSize/2,hexSize,height]);
				rotate([0,0,60*(i+1)]) translate([0,-hexSize/2,0]) cube([hexSize/2,hexSize,height]);
			}
		}
	}
}

/*
module teardrop(radius,height,truncated)
{
	truncateMM = 1;
	union()
	{
		if(truncated == true)
		{
		intersection()
		{
		translate([0,0,height/2]) scale([1,1,height]) rotate([0,0,180]) cube([radius*2.5,radius*2,1],center=true);
		scale([1,1,height]) rotate([0,0,3*45]) cube([radius,radius,1]);
		}
		}
		if(truncated == false)
		{
		scale([1,1,height]) rotate([0,0,3*45]) cube([radius,radius,1]);
		}
		#cylinder(r=radius, h = height);
	}
}
*/