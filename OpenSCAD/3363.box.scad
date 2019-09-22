//*************************************
// Description:
// 
// A simple box for Lyre project
//
// Fabrication:
//
// print two half shells for one box
//
// Copyright CC-BY-SA Bob Cousins 2010
//
// Rev 2 add lid module
//*************************************

// assume all units are mm

//*************************************
// >>>>  Edit Parameters <<<<
 
// assume uniform wall thickness
wall = 2.5;

// inner dimenions
inner_x = 104;
inner_y = 62;
inner_z = 11;

// parameters for lid
lip_z = 5;
lip_width = 5;

//********* END ***********************


// Calculated dimensions
outer_x = inner_x + wall*2;
outer_y = inner_y + wall*2;
outer_z = inner_z + wall;

origin_x = outer_x / 2;
origin_y = outer_y / 2;
origin_z = 0;
//*************************************

// A simple U-shape tray
module box_shell()
{
	
    translate ([-origin_x, -origin_y, -origin_z])
    difference() 
    {
        cube([outer_x, outer_y, outer_z],
            center = false);

        translate ([wall,wall,wall]) 
            cube([inner_x, inner_y, inner_z+wall], 
                center = false);
    }
}

// A lid with lipped edge
module box_lid ()
{
	translate ([0,0,wall+lip_z])
	rotate ([0,180,0])
    translate ([-origin_x, -origin_y, -origin_z])
    
	difference() {

		union() {
		    translate ([0,0,lip_z])
	        cube([outer_x, outer_y, wall], center = false);
	
		    translate ([wall,wall,0])
	        cube([inner_x, inner_y, lip_z+wall/2], center = false);
		}

		translate ([wall+lip_width, wall+lip_width, -wall/2])
	        cube([inner_x - lip_width*2, 
                  inner_y - lip_width*2, 
                  lip_z+wall/2], center = false);

		
	}
}

// select module as required
//box_shell();

box_lid();
