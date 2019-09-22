
//pulled from http://www.servocity.com/html/hs-311_standard.html
a = 19.82;
b = 13.47;
c = 33.79;
d = 10.17;
e =  9.66;
f = 30.22;
g = 11.68;
h = 26.67;
j = 52.84;
k =  9.35;
l =  4.38;
m = 39.88;
x =  3.05;
spline = 5;


//hs311_servo();
servo_mount();

module servo_mount()
{
	$fs = 0.1;
	
	wall = 5;
	bolt = 3.5;
	width = a+wall*2;
	height = j;
	depth = wall*4;
	splineX = (a/2+wall);
	splineY = (j-(j-m)/2-e);

	//translate([-splineX, -splineY, -(depth+1)])
	rotate([90, 0, 0])
	{
		difference()
		{
			//the main mount body.
			union()
			{
				cube([width, height, depth]); // large vertical piece
				translate([-bolt*2, 0, 0])
					cube([width+bolt*4, wall, depth]); //mounting flanges
			}
			
			//bolt holes for flange
			translate([-bolt, -1, depth/2])
				rotate([-90,0,0])
					cylinder(r=bolt/2, h=wall+2);
			translate([width+bolt, -1, depth/2])
				rotate([-90,0,0])
					cylinder(r=bolt/2, h=wall+2);
					
			//bolt hole cutouts for flange
			translate([-bolt*3, -1, depth/2])
				cube([bolt*2, wall*2, 0.1]);
			translate([width+bolt, 0-1, depth/2])
				cube([bolt*2, wall*2, 0.1]);
		
			//cutout for servo
			translate([wall-0.5, (j-m-1)/2, -1])
				cube([a+1, m+1, h+2]);
				
			//mounting holes for the servo.
			translate([a/2+wall+d/2, splineY+b, -1])
				cylinder(r=bolt/2, h=depth+2);
			translate([a/2+wall-d/2, splineY+b, -1])
				cylinder(r=bolt/2, h=depth+2);
			translate([a/2+wall+d/2, splineY-c, -1])
				cylinder(r=bolt/2, h=depth+2);
			translate([a/2+wall-d/2, splineY-c, -1])
				cylinder(r=bolt/2, h=depth+2);
		}
	}
}

module hs311_servo()
{
	$fs = 0.1;
	
	difference()
	{
		//center the servo on the spline shaft output
		translate([-a/2, -f, -h])
		{
			union()
			{
				//main housing of servo
				cube([a, m, h+k]);
		
				//flanged sides
				translate([0, -(j-m)/2, h])
					cube([a, j, 2]);
			
				//servo spline
				translate([a/2, m-e, h+g])
					cylinder(r=spline/2, h=x);
				translate([a/2, m-e, 0])
					cylinder(r=spline*1.5, h=h+g);  //TODO: radius needs real measurement.
			}
		}
		
		//mounting holes for the servo.
		translate([d/2, b, 0])
			cylinder(r=l/2, h=k, center=true);
		translate([-d/2, b, 0])
			cylinder(r=l/2, h=k, center=true);
		translate([d/2, -c, 0])
			cylinder(r=l/2, h=k, center=true);
		translate([-d/2, -c, 0])
			cylinder(r=l/2, h=k, center=true);		
	}
}
