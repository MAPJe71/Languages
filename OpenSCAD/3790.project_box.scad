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
	
	module mount()
	{
		linear_extrude(height=34)
		{
			difference()
			{
				union()
				{
					circle(r=5.5/2);
					translate([-6,-5.5/2])square([6,5.5]);
				}
				circle(r=2.5/2);
			}
			
		}	
	}

	difference()
	{	
	linear_extrude(height=34)
	roundedsquare(r=5,w=78,h=115);
	
	translate([2.5,2.5,2.5])linear_extrude(height=40)
	roundedsquare(r=5-2.5,w=78-5,h=115-5);
    }
    
    translate([7.5,78/2,0])mount();

    translate([115-7.5,78/2,0])	rotate([0,0,180])mount();
}

main();
