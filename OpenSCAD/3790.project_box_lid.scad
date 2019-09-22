$fn=50;
module main()
{
	module roundedsquare(r,w,h)
	{
		union()
		{
			translate([r,r])circle(r=r);
			translate([r,w-r])circle(r=r);
			translate([h-r,r])circle(r=r);
			translate([h-r,w-r])circle(r=r);
			translate([0,r])square([h,w-(r*2)]);	
			translate([r,0])square([h-(r*2),w]);
		}	
	}
	
	difference()
	{
	linear_extrude(height=2.5) roundedsquare(r=5,w=78,h=115);
	translate([7.5,78/2,-5])cylinder(r=3.2/2,h=10);
	translate([115-7.5,78/2,-5])cylinder(r=3.2/2,h=10);
	}
}

main();
