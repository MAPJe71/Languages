// paramteric peristaltic pump
// tigger@interthingy.com 
// 201105302342

include <metric_fastners-0.1.scad>

$fn = 50;

// mode 
// 1 : assembled , 2 : exploded , 3 : print 
// 4-8 individual parts 
mode = 8;

// pipe
pipe_od = 10;
pipe_wall = 3;

// base dims 
pump_radius = 50;
outer_edge = 5;

base_thickness =10;
wall_thickness = 2*pipe_od;
bolt_size = 4; 
bolt_length = 40;
clearance = 2;
rotor_arms = 4;

// drive shaft
shaft_size = 10;
motor_shaft = 5;


// internal landing
landing_height = 5;
landing_width = 30;

//pipe entry
entry_angle = 30;
entry_width = 30;
entry_radius = 5;
entry_gap = 5;

// rotor dims
rotor_thickness =bolt_size*2+clearance;
rotor_size = 2*bolt_size;

// wheel
wheel_thickness = 18;
wheel_radius = 10;

// arm
arm_size = pump_radius-wall_thickness/2-wheel_radius-pipe_wall;

pump_height = wheel_thickness+2*rotor_thickness+5*clearance;


module pump_shell()
{
	color([0,1,0])
	scale([outer_edge+pump_radius*2,outer_edge+pump_radius*2,base_thickness])
	cube([1,1,1],center=true);
	translate([0,0,base_thickness/2])
	union()
	{
		difference()
		{
			cylinder(h=pump_height,r=pump_radius);
			cylinder(h=pump_height+clearance,r=pump_radius-wall_thickness/2);
		}
	}
}


module pipe_entry()
{
	translate([0,0,base_thickness+landing_height-clearance])
	intersection()
	{
		rotate(90-entry_angle,[0,0,1])
		cube([pump_radius,pump_radius,pump_height]);
		rotate(entry_angle,[0,0,1])
		cube([pump_radius,pump_radius,pump_height]);

	}
}

module entry_side(rot=-39.5)
{
	rotate(rot,[0,0,1])
	translate([0,pump_radius-wall_thickness/4,base_thickness/2])
	cylinder(h=pump_height,r=wall_thickness/4);
}

module full_shell()
{
	difference()
	{
		pump_shell();
		pipe_entry();
		translate([0,0,-pump_height/2])
		cylinder(h=pump_height,r=20);
	}
	entry_side(rot=entry_angle);
	entry_side(rot=-entry_angle);
}

module wheel()
{
	color([0.5,0.5,0.5])
	difference()
	{
		cylinder(h=wheel_thickness,r=wheel_radius);
		translate([0,0,-clearance/2])
		cylinder(h=wheel_thickness+clearance,r=bolt_size/2);
	}
}

module anti_wheel()
{
		cylinder(h=2*wheel_thickness+clearance,r=wheel_radius+clearance);
}

module place_wheels()
{
	step = 360/rotor_arms;
	for(z =[0:rotor_arms])
	{
		rotate(z*step,[0,0,1])
		translate([arm_size,0,0])
		wheel();
	}

}

module place_wheels_print()
{
	step = 360/rotor_arms;
	for(z =[0:rotor_arms])
	{
		rotate(z*step,[0,0,1])
		translate([wheel_radius*1.6+clearance,0,0])
		wheel();
	}

}

module drive_coupling()
{
	step = 360/rotor_arms;
	color([1,0,0])
	rotate(step/2,[0,0,1])
	cylinder(h=pump_height+2*clearance,r=shaft_size,$fn=6);
}

module drive_coupling_mount()
{
	difference()
	{
		drive_coupling();
		translate([0,0,-clearance])
		cylinder(h=pump_height,r=motor_shaft/2);
	}
}

module lower_rotor()
{
	step = 360/rotor_arms;
	union()
	{
		difference()
		{
			difference()
			{
				union()
				{
					cylinder(h=rotor_thickness,r=pump_radius-wall_thickness/2-clearance);
					cylinder(h=rotor_thickness+wheel_thickness/2+clearance/2,r=pump_radius-wall_thickness/2-pipe_od-clearance);
	
				}
				union()
				{
					for(z =[0:rotor_arms])
					{
						rotate(z*step,[0,0,1])
						translate([arm_size,0,rotor_thickness])
						anti_wheel();
						rotate(z*step,[0,0,1])
						translate([arm_size,0,-rotor_thickness/2])
						cylinder(h=rotor_thickness*2,r=bolt_size/2);
						rotate(z*step,[0,0,1])
						translate([arm_size,0,-clearance])
						cylinder(h=bolt_size*1.3,r=bolt_size/1.2);
					}
				}
			}
			union()
			{
				rotate([0,0,step])
				translate([0,0,-clearance])
				drive_coupling();
			}
		}
		for(z =[0:rotor_arms])
		{
			rotate(z*step+step/2,[0,0,1])
			translate([arm_size-bolt_size*2,0,rotor_thickness+wheel_thickness/2])
			sphere(bolt_size,$fn=8);
		}
	}
}

module nuts_and_bolts()
{
	step = 360/rotor_arms;
	for(z =[0:rotor_arms])
	{
		color([0.3,0.3,0.3])
		rotate(z*step,[0,0,1])
		translate([arm_size,0,0])
		cap_bolt(bolt_size,bolt_length);
	}
	for(z =[0:rotor_arms])
	{
		color([0.3,0.3,0.3])
		rotate(z*step,[0,0,1])
		translate([arm_size,0,bolt_length-bolt_size])
		flat_nut(bolt_size);
		
	}
}

module  upper_rotor()
{
	step = 360/rotor_arms;
	union()
	{
		difference()
		{
			difference()
			{
				union()
				{
					//cylinder(h=rotor_thickness,r=pump_radius-wall_thickness+clearance);
					cylinder(h=rotor_thickness+wheel_thickness/2+clearance/2,r=pump_radius-wall_thickness/2-pipe_od-clearance);
					for(z =[0:rotor_arms])
					{
						rotate(z*step,[0,0,1])
						translate([arm_size,0,0])
						cylinder(h=rotor_thickness,r=3*bolt_size/2);
					}
				}
				union()
				{
					for(z =[0:rotor_arms])
					{
						rotate(z*step,[0,0,1])
						translate([arm_size,0,rotor_thickness])
						anti_wheel();
						rotate(z*step,[0,0,1])
						translate([arm_size,0,-rotor_thickness])
						cylinder(h=rotor_thickness*3,r=bolt_size/2);
					}
				}
				union()
				{
				for(z =[0:rotor_arms])
				{
					rotate(z*step+step/2,[0,0,1])
					translate([arm_size-bolt_size*2,0,rotor_thickness+wheel_thickness/2])
					sphere(bolt_size,$fn=8);
				}
				}
			}
			//translate([0,0,-pump_height/2])
			union()
			{
				translate([0,0,-clearance])
				drive_coupling();
			}

		}
	}
}


module pipe()
{
	color([0,0,1])
	rotate_extrude(convexity = 10)
	translate([pump_radius-wall_thickness/2-pipe_od/2, 0, 0])
	circle(r = pipe_od/2);
}



// assembled
module assembled()
{
	union()
	{
		translate([0,0,base_thickness+clearance+rotor_thickness+pipe_od]) pipe();
		translate([0,0,base_thickness+clearance+rotor_thickness+clearance/2]) place_wheels();
		translate([0,0,base_thickness+clearance]) lower_rotor();
		rotate(180,[1,0,0])translate([0,0,-base_thickness-2*rotor_thickness-wheel_thickness-2*clearance])upper_rotor();
		translate([0,0,base_thickness+clearance+bolt_size])nuts_and_bolts();
		//drive_coupling();
		full_shell();
	}
}

exploder = pump_height;

module exploded()
{
	union()
	{
		translate([0,0,3.5*exploder]) pipe();
		translate([0,0,2.9*exploder]) place_wheels();
		translate([0,0,1.5*exploder]) lower_rotor();
		translate([0,0,4.5*exploder])rotate(180,[1,0,0]) upper_rotor();
		translate([0,0,2*exploder])nuts_and_bolts();
		translate([0,0,0.3*exploder])drive_coupling();
		full_shell();
	}
}

module single_print()
{
	gap = pump_radius*2-wall_thickness;
	union()
	{
		translate([pump_radius*2,0,0]) place_wheels_print();
		translate([0,pump_radius*2,0]) lower_rotor();
		translate([gap,gap,0])upper_rotor();
		translate([0,0.0])drive_coupling_mount();
		translate([0,0,base_thickness/2])full_shell();
	}
}

if(mode == 1){assembled();}
if(mode == 2){exploded();}
if(mode == 3){single_print();}
if(mode == 4){translate([0,0,base_thickness/2])full_shell();}
if(mode == 5){translate([0,0.0])drive_coupling_mount();}
if(mode == 6){upper_rotor();}
if(mode == 7){lower_rotor();}
if(mode == 8){place_wheels_print();}
