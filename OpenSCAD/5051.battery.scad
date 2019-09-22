/*
A Battery Compartment generator
enter the battery-type and the number of batteries you need and 
export the stl file. Print on a 3D-Printer and add some metall pieces into the slits
on the side
*/

AA = [ 14.5, 50.5 ];
AAA = [ 10.5,44.5 ];
C = [ 26.2, 50 ];
D = [ 34.2, 61.5 ]; 

// CHOOSE BATTERY TYPE AND COUNT 
typ = AA;
num =2;


translate( v = [-typ[1]/2 -4,-typ[0]*num/2 -2,0] ) {

difference() {
union() {
difference() {
   cube( size = [ typ[1] + 8, typ[0] * num + 4, typ[0] + 2] );
   translate( v = [2,2,2] ) {
   	cube( size = [typ[1] +4, typ[0] * num, typ[0] + 1 ]);
   }
}


translate( v= [2,2,2] ) {
for( i = [0:num-1] ) {
	translate( v = [0, typ[0] * i, 0] ) {
		difference() {
			cube( size = [typ[1]+4, typ[0], typ[0]/2] );
			translate( v = [ 0, typ[0]/2, typ[0]/2 ] ) {
				rotate( v = [0,1,0], a = 90 ) {
					cylinder( h = typ[1]+4, r = typ[0]/2, $fn=50 );
				}
			}
		}
	}
}
}
}
union() {
if ( num % 2 == 0 ) {
	for( i = [0:2:num-2] ) {
		translate( v = [2, typ[0] * i+3,2 ] ) {
			cube( size = [0.5, typ[0] * 2 - 2 , typ[0]]  );
		}	
	}
	if ( num  > 2 ) {
		for( i = [1:2:num-3] ) {
			translate( v = [5.5 + typ[1], typ[0] * i+3,2 ] ) {
				cube( size = [0.5, typ[0] * 2 - 2 , typ[0]]  );
			}	
		}
	}
	translate( v = [5.5+typ[1], 3, 2] ) {
		cube( size = [0.5, typ[0]-2, typ[0]]);
	}

	translate( v = [5.5+typ[1], 3, typ[0] - 2]) {
		cube( size = [3, typ[0]-2, 0.5] );
	}

	translate( v = [5.5+typ[1], 3+typ[0] * (num-1), 2] ) {
		cube( size = [0.5, typ[0]-2, typ[0]]);
	}

	translate( v = [5.5+typ[1], 3+typ[0] * (num-1), typ[0] - 2]) {
		cube( size = [3, typ[0]-2, 0.5] );
	}

	
} else {
	if ( num  > 1 ) {
		for( i = [0:2:num-2] ) {
			translate( v = [2, typ[0] * i+3,2 ] ) {
				cube( size = [0.5, typ[0] * 2 - 2 , typ[0]]  );
			}	
		}
		for( i = [1:2:num-2] ) {
			translate( v = [5.5 + typ[1], typ[0] * i+3,2 ] ) {
				cube( size = [0.5, typ[0] * 2 - 2 , typ[0]]  );
			}	
		}
	}
	translate( v = [5.5+typ[1], 3, 2] ) {
		cube( size = [0.5, typ[0]-2, typ[0]]);
	}
	translate( v = [5.5+typ[1], 3, typ[0] - 2]) {
		cube( size = [3, typ[0]-2, 0.5] );
	}

	translate( v = [2, 3+typ[0] * (num-1), 2] ) {
		cube( size = [0.5, typ[0]-2, typ[0]]);
	}
	translate( v = [-0.5, 3+typ[0] * (num-1), typ[0] - 2]) {
		cube( size = [3, typ[0]-2, 0.5] );
	}

} 
}
}

}