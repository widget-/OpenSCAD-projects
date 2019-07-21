in = 25.4;
cm = 10;
mm = 1;
inf = 10e10;
nc = 10e-3;


// tube is the part of the holder
// roll is the part that the filament is wound around

// params
wall_thickness = 10*mm;
tube_diameter = 2*cm;
roll_extra_space = 0.5*cm; // on each side of roll
tube_extra_space = 2*mm;
stand_buffer_space = 2*cm; // space to prevent the stand from bumping the wall of the container it's in
fn = 50; // $fn for cylinders

// measurements
roll_width = 10*cm;
roll_diameter = 26*cm;
roll_hole_diameter = 6*cm;
roll_suspend_height = (roll_diameter+roll_hole_diameter-tube_diameter) / 2 + 0*cm;

print_area_width = 20*cm;
print_area_height = 21*cm;

// calculations
roll_suspend_height_center = (roll_suspend_height-tube_diameter/2);
holder_height = roll_suspend_height_center*2;
holder_width = roll_width + roll_extra_space*2;
holder_length = holder_height + stand_buffer_space;
holder_tube_gap_radius = tube_diameter/2 + tube_extra_space;
holder_tube_gap_ypos = roll_suspend_height+1.5*cm;

center_height = print_area_height < holder_height ? print_area_height / 2 : holder_height / 2;
center_length = print_area_width < holder_length ? print_area_width / 2 : holder_length / 2;

// from https://gist.github.com/boredzo/fde487c724a40a26fa9c:
/*skew takes an array of six angles:
 *x along y
 *x along z
 *y along x
 *y along z
 *z along x
 *z along y
 */
module skew(dims) {
    matrix = [
        [ 1, tan(dims[0]), tan(dims[1]), 0 ],
        [ tan(dims[2]), 1, tan(dims[3]), 0 ],
        [ tan(dims[4]), tan(dims[5]), 1, 0 ],
        [ 0, 0, 0, 1 ]
    ];
    multmatrix(matrix)
    children();
}

module right_triangular_cylinder(width, length, depth) {
    // makes a right triangle with the right angle at the top-right corner
    rotate([90, 0, -90])
    linear_extrude(height=depth)
    polygon(points=[
        [0,0],
        [0,width],
        [length, 0]
    ], paths=[
        [0,1,2]
    ]);
}

module stand_polygon() {
    difference() {
        square(size=[holder_length, holder_height]);

        rotate([0, 0, 45])
        square(size=[holder_height*2, holder_height]);

        translate([holder_tube_gap_ypos, roll_suspend_height])
        rotate([0, 0, 90])
        circle(r=holder_tube_gap_radius, $fn=fn);
        
        translate([holder_tube_gap_ypos-holder_tube_gap_radius, roll_suspend_height])
        square(size=[holder_tube_gap_radius*2, inf]);
    }
}

module stand_solid() {
    linear_extrude(height=wall_thickness, center=false, convexity=10, twist=0) {
        intersection() {
            difference() {
                stand_polygon();

                offset(r=-wall_thickness)
                stand_polygon();
            }

            translate([holder_length-print_area_width, 0])
            square([print_area_width, print_area_height]);
        }
    }
}

module stand() {
    stand_solid();

    translate([0, 0, holder_width-wall_thickness])
    stand_solid();

    // bottom connects
    translate([holder_length-print_area_width, 0, 0])
    cube([wall_thickness, wall_thickness, holder_width]);

    translate([holder_length-wall_thickness, 0, 0])
    cube([wall_thickness, wall_thickness, holder_width]);

    // front connects
    translate([0, -center_height/3, 0]) {
        translate([holder_length-wall_thickness, holder_width-2*wall_thickness-holder_width*tan(30)/2, 0])
        skew([0,0,0,30,0,0])
        cube([wall_thickness, wall_thickness, holder_width]);

        translate([holder_length-wall_thickness, holder_width-2*wall_thickness+holder_width*tan(30)/2, 0])
        skew([0,0,0,-30,0,0])
        cube([wall_thickness, wall_thickness, holder_width]);
    }

    translate([holder_length, print_area_height-wall_thickness*3, wall_thickness])
    right_triangular_cylinder(width=holder_width/2-wall_thickness, length=holder_width/4, depth=wall_thickness);
    
    translate([holder_length, print_area_height-wall_thickness*3, holder_width-wall_thickness])
    mirror([0,0,1])
    right_triangular_cylinder(width=holder_width/2-wall_thickness, length=holder_width/4, depth=wall_thickness);

    translate([holder_length-wall_thickness, print_area_height-wall_thickness*3, 0])
    difference() {
        // wire guide
        cube([wall_thickness, wall_thickness*3, holder_width]);

        translate([-nc, wall_thickness*3/2, holder_width/2])
        scale([1, 1, 3])
        rotate([0, 90, 0])
        cylinder(r=wall_thickness, h=holder_width+2*nc, center=false, $fn=fn);

        translate([-nc, wall_thickness*2+nc, holder_width/2-wall_thickness/4])
        cube([wall_thickness+2*nc, wall_thickness, wall_thickness/2]);
    }

    // vertical connects
    translate([holder_tube_gap_ypos-wall_thickness+wall_thickness/2, 0, 0])
    cube([wall_thickness, roll_suspend_height-holder_tube_gap_radius, wall_thickness]);

    translate([holder_tube_gap_ypos-wall_thickness+wall_thickness/2, 0, holder_width-wall_thickness])
    cube([wall_thickness, roll_suspend_height-holder_tube_gap_radius, wall_thickness]);
    
    translate([holder_length-print_area_width, 0, 0])
    cube([wall_thickness, holder_length-print_area_width, wall_thickness]);

    translate([holder_length-print_area_width, 0, holder_width-wall_thickness])
    cube([wall_thickness, holder_length-print_area_width, wall_thickness]);

    // top connect
    // translate([print_area_height, print_area_height-wall_thickness, 0])
    // cube([holder_length-print_area_height, wall_thickness, wall_thickness]);
    
    // translate([print_area_height, print_area_height-wall_thickness, holder_width-wall_thickness])
    // cube([holder_length-print_area_height, wall_thickness, wall_thickness]);

    translate([print_area_height, print_area_height-wall_thickness, 0])
    skew([0,0,-45,0,0,0])
    cube([(holder_length-print_area_height), wall_thickness, wall_thickness]);
    
    translate([print_area_height, print_area_height-wall_thickness, holder_width-wall_thickness])
    skew([0,0,-45,0,0,0])
    cube([(holder_length-print_area_height), wall_thickness, wall_thickness]);
}

translate([print_area_width-holder_length, 0, 0])
rotate([90, 0, 0])
// minkowski() {
    // sphere(r=5*mm, $fs=5);
    stand();
// }