//project enclosure 
//2010 Nathan Oostendorp

//define the amount of space we want in our enclosure
wall_width = 2;         //how wide we want our exterior walls to be
holewall_width = 1.5;   //how wide we want our screw hole walls to be
holetaper = 0.9;        //how much taper from bottom to top to aid screw fit
interior_z = 35;        //our interior height (exterior is computed)
interior_x = 60;        //our PCB's X horizontal dimension
interior_y = 80;        //our PCB's Y horizontal dimension

//define where our screwholes are on our PCB
//set to 0 if you don't care
mounthole_radius = 1;  //radius of our screwhole
mount_inset_x = 5; //how far center is from the edge of the PCB in X
mount_inset_y = 5.5; //how far center is from the edge of the PCB in Y
mount_z = 6;  //how high we want the mount supports

//note that lid fastener screw holes are added to the X dimension
//if you have something with a bigger print bed you may want to invert X/Y
lidfastenhole_radius = 1; //radius of the screwhole
lidfastenhole_inset = 5;  //measured from center of lid fastening hole

//computed parameters for ease of use
exterior_z = interior_z + wall_width;
exterior_x = interior_x + lidfastenhole_radius * 2 + lidfastenhole_inset * 2 + wall_width * 2;
exterior_y = interior_y + wall_width * 2;

mount_offset_x = interior_x / 2 - mount_inset_x;
mount_offset_y = interior_y / 2 - mount_inset_y;
mount_offset_z = interior_z / 2 - mount_z / 2 - wall_width;

lidmount_offset_x = interior_x / 2 + lidfastenhole_radius + wall_width;
lidmount_offset_y = interior_y / 2 - mount_inset_y;
lidmount_offset_z = wall_width / 2;


module housing() {
   difference() { 
       cube(size = [exterior_x, exterior_y, exterior_z], center = true);
       translate ([0, 0, wall_width]) { cube(size = [exterior_x - wall_width * 2, exterior_y - wall_width * 2, exterior_z - wall_width], center = true); }
   }
}

module pcbmount() {
   difference() {
      cylinder(r = holewall_width + mounthole_radius, h = mount_z, center = true);
      cylinder(r1 = mounthole_radius * holetaper, r2 = mounthole_radius, h = mount_z, center = true);
   }
}

module lidmount(mountsupport) {
   union() {
      difference() {
         cylinder(r = holewall_width + lidfastenhole_radius, h = interior_z, center = true);
         cylinder(r1 = lidfastenhole_radius * holetaper, r2 = lidfastenhole_radius, h = interior_z, center = true);
      }
      translate([(holewall_width + lidfastenhole_radius) * mountsupport, 0, 0]) {  
         cube( size = [lidfastenhole_inset - lidfastenhole_radius, wall_width, interior_z], center = true); 
      }
   }
}

module enclosure_lid() {
   difference() {
        cube( size = [exterior_x + wall_width * 2, exterior_y + wall_width * 2, wall_width * 3], center = true);
        translate([0, 0, wall_width]) { cube( size = [exterior_x, exterior_y, wall_width * 2], center = true); }
        translate([lidmount_offset_x, lidmount_offset_y, -1]) { cylinder( r = lidfastenhole_radius, h = wall_width+2, center = true); }
        translate([-lidmount_offset_x, lidmount_offset_y, -1]) { cylinder( r = lidfastenhole_radius, h = wall_width+2, center = true); }
        translate([-lidmount_offset_x, -lidmount_offset_y, -1]) { cylinder( r = lidfastenhole_radius, h = wall_width+2, center = true ); }
        translate([lidmount_offset_x, -lidmount_offset_y, -1]) { cylinder( r = lidfastenhole_radius, h = wall_width +2 , center = true ); }

   }
}


module project_enclosure() {
   
   union() {
      housing();
      translate([mount_offset_x, mount_offset_y, -mount_offset_z]) { pcbmount(); }
      translate([-mount_offset_x, mount_offset_y, -mount_offset_z]) { pcbmount(); }
      translate([-mount_offset_x, -mount_offset_y, -mount_offset_z]) { pcbmount(); }
      translate([mount_offset_x, -mount_offset_y, -mount_offset_z]) { pcbmount(); }
      translate([lidmount_offset_x, lidmount_offset_y, lidmount_offset_z]) { lidmount(1); }
      translate([-lidmount_offset_x, lidmount_offset_y, lidmount_offset_z]) { lidmount(-1); }
      translate([-lidmount_offset_x, -lidmount_offset_y, lidmount_offset_z]) { lidmount(-1); }
      translate([lidmount_offset_x, -lidmount_offset_y, lidmount_offset_z]) { lidmount(1); }
   }


}


//project_enclosure();
enclosure_lid();