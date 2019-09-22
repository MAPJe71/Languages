//*************************************
// Description:
// 
// A two part box consisting of a lower and upper shell
// with mounting bosses for PCB
// 
// Designed for Lyre project
// 
//
// Fabrication:
//
// print lower part (box_lower = true)
// print upper part (box_lower = false)
//
// Copyright CC-BY-SA Bob Cousins 2010
//
// Rev 1, initial version
// Rev 2, put bosses in correct places for Lyre V1 PCB
//        exploded_view mode -  draw pcb, screws
//*************************************

// assume all units are mm


// A simple tray shape
module box_shell()
{
    difference() 
    {
        cube([outer_x, outer_y, outer_z],
            center = false);

        translate ([wall,wall,wall]) 
            cube([inner_x, inner_y, inner_z+wall], 
                center = false);
    }
}

// draw a mounting boss
// dimensions are relative to inner dimensions 
module boss (x, y, z, boss_h, boss_diam)
{
$fs=0.1;
    translate ([x+wall, y+wall, z])
    translate ([0, 0, boss_h/2 - fudge])
    cylinder (h = boss_h + fudge, r = boss_diam/2, center=true);
}

// vertical hole for screw in a boss
module screw_hole (x, y, boss_h, hole_depth, hole_diam)
{
$fs=0.1;
    translate ([x+wall, y+wall, 0])
    
    translate ([0, 0, boss_h+wall-hole_depth])
    cylinder (h = hole_depth+fudge, r = hole_diam/2);
}

// countersink for vertical hole in a boss 
// assume counter sink head is 2*diameter and height is diam/2
module countersink_hole (x, y, z, screw_depth, screw_diam)
{
$fs=0.5;
    translate ([x+wall, y+wall, z-fudge])
    
    cylinder (h = screw_diam/2 + fudge, r1 = screw_diam, r2 = screw_diam/2);
}

module csink_head (x, y, z, screw_depth, screw_diam)
{
$fs=0.5;
    translate ([x+wall, y+wall, z])
    cylinder (h = screw_diam/2 + fudge, r1 = screw_diam, r2 = screw_diam/2);
}

// vertical screw
module screw (x, y, z, screw_len, screw_diam, countersink)
{
$fs=0.1;
    translate ([x+wall, y+wall, z])
    cylinder (h = screw_len, r = screw_diam/2);
    if (countersink)
        csink_head (x,y,z, screw_len, screw_diam);
    else
    {
        translate ([x+wall, y+wall, z+screw_len])
        cylinder (h = screw_diam/2, r = screw_diam);
    }
    
}

module pcb (x,y,z, size_x, size_y, size_z)
{
    size = case_boss_diam + 1;

    translate ([0, 0, z])
    difference ()
    {
        translate ([x+wall, y+wall, 0])
           cube ([size_x, size_y, size_z]);

        // make a cutout for case bosses
        // allow space for clearance
        
        boss (case_boss_x, case_boss_y1, 0, pcb_h+fudge, size);
        translate ([case_boss_x+wall, case_boss_y1+wall-size/4, pcb_h/2])
        cube ([size, size/2, pcb_h+fudge*2], center=true);
        
        boss (case_boss_x, case_boss_y2, 0, pcb_h+fudge, size);
        translate ([case_boss_x+wall, case_boss_y2+wall+size/4, pcb_h/2])
        cube ([size, size/2, pcb_h+fudge*2], center=true);
        
        // draw PCB mounting holes
        boss (pcb_boss_x1, pcb_boss_y1, 0, pcb_h+fudge, screw_diam); 
        boss (pcb_boss_x1, pcb_boss_y2, 0, pcb_h+fudge, screw_diam);
        
        boss (pcb_boss_x2, pcb_boss_y1, 0, pcb_h+fudge, screw_diam); 
        boss (pcb_boss_x2, pcb_boss_y2, 0, pcb_h+fudge, screw_diam);
    }
}

// A lid with lipped edge
// option: solid_lid = 0 or 1
module box_lid ()
{
    // flip the lid over
    translate ([outer_x,0,wall+lip_z])
    rotate ([0,180,0])
    
    difference() {

        union() {
            translate ([0,0,lip_z])
            cube([outer_x, outer_y, wall], center = false);
    
            translate ([wall,wall,0])
            cube([inner_x, inner_y, lip_z+wall/2], center = false);
        }

        if (solid_lid == 0)
        {
            translate ([wall+lip_width, wall+lip_width, -wall/2])
                    cube([inner_x - lip_width*2, 
                  inner_y - lip_width*2, 
                  lip_z+wall/2], center = false);
        }
    }
}

// ****************************************************************************
// draw complete box half 
// option: box_lower = true or false
module box(box_lower)
{
    difference () 
    {
        // draw solid parts: case shell, bosses 
        union ()
        {
            box_shell();

            // draw through bosses for case 
            boss (case_boss_x, case_boss_y1, wall, inner_z, case_boss_diam);
            boss (case_boss_x, case_boss_y2, wall, inner_z, case_boss_diam);
            
            // draw blind bosses for PCB mount
            boss (pcb_boss_x1, pcb_boss_y1, wall, pcb_boss_h, pcb_boss_diam); 
            boss (pcb_boss_x1, pcb_boss_y2, wall, pcb_boss_h, pcb_boss_diam);
            
            boss (pcb_boss_x2, pcb_boss_y1, wall, pcb_boss_h, pcb_boss_diam); 
            boss (pcb_boss_x2, pcb_boss_y2, wall, pcb_boss_h, pcb_boss_diam);
        }

        // draw apertures: screw holes
        
        // holes for case bosses
        if (box_lower)
        {
            screw_hole       (case_boss_x, case_boss_y1, inner_z,  inner_z+wall*2, screw_diam);    
            countersink_hole (case_boss_x, case_boss_y1, 0,        inner_z+wall*2, screw_diam);
            
            screw_hole       (case_boss_x, case_boss_y2, inner_z, inner_z+wall*2, screw_diam);
            countersink_hole (case_boss_x, case_boss_y2, 0,       inner_z+wall*2, screw_diam);
        }
        else
        {
            screw_hole  (case_boss_x, case_boss_y1, inner_z, case_boss_hole_d, screw_diam);    
            screw_hole  (case_boss_x, case_boss_y2, inner_z, case_boss_hole_d, screw_diam);
        }
        
        // holes for PCB bosses
        screw_hole (pcb_boss_x1, pcb_boss_y1, pcb_boss_h, pcb_boss_hole_d, screw_diam); 
        screw_hole (pcb_boss_x1, pcb_boss_y2, pcb_boss_h, pcb_boss_hole_d, screw_diam);
        
        screw_hole (pcb_boss_x2, pcb_boss_y1, pcb_boss_h, pcb_boss_hole_d, screw_diam); 
        screw_hole (pcb_boss_x2, pcb_boss_y2, pcb_boss_h, pcb_boss_hole_d, screw_diam);
    }
}
//*************************************

// exploded view
module exploded_view ()
{
    screw  (case_boss_x, case_boss_y1, -screw_len2-5,      screw_len2, screw_diam-fudge, true);
    screw  (case_boss_x, case_boss_y2, -screw_len2-5,      screw_len2, screw_diam-fudge, true);
    
    box (true);
    
    y2 = outer_z + 10;
//    y2 = wall+pcb_boss_h;
    pcb (in_center_x - 52.07, in_center_y-30.48, y2, pcb_size_x, pcb_size_y, pcb_h);

    y3 = y2 + 2 + 10;
    screw  (pcb_boss_x1, pcb_boss_y1,  y3, screw_len1, screw_diam-fudge, false);    
    screw  (pcb_boss_x1, pcb_boss_y2,  y3, screw_len1, screw_diam-fudge, false);    
    screw  (pcb_boss_x2, pcb_boss_y1,  y3, screw_len1, screw_diam-fudge, false);    
    screw  (pcb_boss_x2, pcb_boss_y2,  y3, screw_len1, screw_diam-fudge, false);    

    y4 = y3 + screw_len1 + 10;
    translate ([0,0,y4 + outer_z])
    mirror ([0,0,1])
    box (false);    
}

//*************************************
// Constants
col_silver = [0.5,0.5,0.5];

//*************************************
// >>>>  Edit Parameters Here <<<<

// set true or false for lower or upper half
box_lower = false;
 
// assume uniform wall thickness
wall = 2.5;

// inner dimensions
inner_x = 104;
inner_y = 62;
inner_z = 11;

// for PCB mounting
pcb_boss_h    = 5;
pcb_boss_diam = 5;

// for case
case_boss_h    = inner_z;
case_boss_diam = 5.5;

// No.4 screws
screw_diam = 2.9;
screw_len1 = 6.4; // 1/4"
screw_len2 = 19;  // 3/4"

// For the Lyre v1 PCB, the boss positions are referenced from the inner center
in_center_x = inner_x /2;
in_center_y = inner_y /2;

pcb_boss_x1  = in_center_x - 25;
pcb_boss_x2  = in_center_x + 15;

pcb_boss_y1  = in_center_y - 28.48;
pcb_boss_y2  = in_center_y + 28.48;

case_boss_x  = in_center_x;
case_boss_y1 = in_center_y - 28.39;
case_boss_y2 = in_center_y + 28.39;

pcb_size_x = 77;
pcb_size_y = 61;
pcb_h      = 1.6;  // PCB thickness, typically 1.6mm
//********* End Parameters ***********************


//*************************************
// Calculated dimensions
outer_x = inner_x + wall*2;
outer_y = inner_y + wall*2;
outer_z = inner_z + wall;

center_x = outer_x / 2;
center_y = outer_y / 2;
center_z = 0;

screw_r = screw_diam / 2;

pcb_boss_r      = pcb_boss_diam/2;
pcb_boss_hole_d = screw_len1 - pcb_h;

case_boss_r      = case_boss_diam/2;
case_boss_hole_d = screw_len2 - inner_z;  
//*************************************

// a fudge factor to avoid non-manifold errors
fudge = 0.1;
exploded = false;
//*************************************


// centre at (0,0)
translate ([-center_x, -center_y, -center_z])
if (exploded)
    exploded_view();
else
    box(box_lower);


//*************************************
//end