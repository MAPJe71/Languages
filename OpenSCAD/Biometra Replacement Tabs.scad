/* Replacement bit for thermal cycler in Lab.
Requirements:
	- Bit Length and Depth
	- Two screw-holes flanking tab.
		- Distances from bit end.
		- Radius
	- Tab poking out that can hold lid.
		- Tab distance from bit end.
		- Tab Width
		- Tab Depth
		- Tab Bevel
	- Thickness overall
	
*/

// ===Parameters===
// ----- Global -----
Thickness = 2.2;
$fn = 10;

// ----- Spine -----
SpineDepth = 12; // How deep it is from the root of the tabs to the back of the thing.
SpineLength = 34; // How long the thing is overall from one end to the other.

// ----- Tab -----
TabDepth = 16; //How much depth has the tab? NB: Measures from back of spine!
TabLength = 8.4; //How long a tab is from one side to another
TabDistance = 12.415; //How far from one end of the spine does the tab start?

// ----- Screw Holes -----
Screw1Distance = 7.5;
Screw2Distance = 25.73;
ScrewHoleRadius = 1.5;
ScrewHoleInset = 6.74;

// ===Modelling===
difference(){
	union(){
	// Spine:
	translate([-SpineLength/2,-TabDepth/2,0])
		cube([SpineLength,SpineDepth,Thickness]);

	// Tab:
	translate([TabDistance-SpineLength/2,-TabDepth/2,0])
		cube([TabLength,TabDepth,Thickness]); // Tab
	}

	// Screwholes:
	translate([Screw1Distance-SpineLength/2, ScrewHoleInset-TabDepth/2, Thickness/2])
		linear_extrude(height = Thickness*1.2, center = true)
			circle(r=ScrewHoleRadius);

	translate([Screw2Distance-SpineLength/2, ScrewHoleInset-TabDepth/2, Thickness/2])
		linear_extrude(height = Thickness*1.2, center = true)
			circle(r=ScrewHoleRadius);

}
