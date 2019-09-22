module flashspacer() {
	union() {
		linear_extrude(
			height = 2,
			convexity = 4
		) polygon(
			points = [
				// Right-Hand Wing
				[7.6, 4.9], [7.6, -5.4], [10.05, -5.4], [9, -0.95], [9, 8.45],
				// Left-Hand Wing
				[-9, 8.45], [-9, -0.95], [-10.05, -5.4], [-7.6, -5.4], [-7.6, 4.9]
			],
			paths = [
				[0,1,2,3,4,5,6,7,8,9]
			],
			convexity = 4
		);
		translate(v = [-6.2, -8.45, 0])
			cube(size = [12.4, 16.9, 3.1]);
		rotate(a = [0, -90, 0])
			linear_extrude(height = 18, center = true)
			polygon(
				points = [[0, -6],[0, -9],[2, -8.45],[2, -6]],
				paths = [[0,1,2,3]]
			);
	}
}

flashspacer();