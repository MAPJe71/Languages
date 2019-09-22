paper_holder_width=112;
paper_holder_depth=30;
paper_holder_height=115;

pencil_holder_width=100;
pencil_holder_depth=40;
pencil_holder_height=100;

wall_thickness=2.5;

perf_hole_diameter=8.5;
perf_hole_spacing=10;

difference() {
	union() {
		translate([0,pencil_holder_depth-wall_thickness,0]) paper_holder(paper_holder_width,paper_holder_depth,paper_holder_height,wall_thickness);
		translate([(paper_holder_width-pencil_holder_width)/2,0,0]) pencil_holder(pencil_holder_width,pencil_holder_depth,pencil_holder_height,wall_thickness);
	}
	for (zcount=[1:floor(pencil_holder_height/perf_hole_spacing)-1]) {
		for (xcount=[1:floor(pencil_holder_width/perf_hole_spacing)-1-zcount%2]) {
			translate([(paper_holder_width-pencil_holder_width)/2+xcount*10+zcount%2*perf_hole_spacing/2,pencil_holder_depth+paper_holder_depth,zcount*perf_hole_spacing]) rotate(v=[1,0,0],a=90) cylinder(r=perf_hole_diameter/2,h=pencil_holder_depth+paper_holder_depth,$fn=8);
		}
	}
}
module pencil_holder(width,depth,height,thickness) {
	difference() {
		pencil_holder_shape(width,depth,height);
		translate([thickness,thickness,thickness]) pencil_holder_shape(width-thickness*2,depth-thickness*2,height);
		
	}
}
module pencil_holder_shape(width,depth,height) {
	union() {
		translate([width/2,depth/2,0]) scale([1,depth/width,1]) cylinder(r=width/2,h=height);
		translate([0,depth/2,0]) cube([width,depth/2,height]);
	}
	
}


module paper_holder(width,depth,height,thickness) {
	difference() {
		paper_holder_shape(width,depth,height);
		translate([thickness,thickness,thickness]) paper_holder_shape(width-thickness*2,depth-thickness*2,height);
		translate([width/2,depth/2,height]) rotate(v=[1,0,0], a=90) scale([2,1,1]) cylinder(r=width/6,h=depth);
	}
}

module paper_holder_shape(width,depth,height) {
	cube([width,depth,height]);
}