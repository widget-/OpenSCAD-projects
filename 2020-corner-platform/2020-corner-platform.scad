in = 25.4;
cm = 10;
mm = 1;

// params
wall_thickness = 15*mm;
corner_offset = 30*mm; // clearance due to corner braces

platform_width = 8*in;
platform_length = 8*in;
platform_thickness = wall_thickness;
platform_mirror = 0; // 1 to flip horizontally

// constants
2020_width = 21*mm;
2020_center_width = 6*mm;
2020_center_depth = .3*mm;

outer_width = 2020_width + wall_thickness*2;
outer_height = 2020_width + wall_thickness;

module 2020_hug(length) {
    difference() {
        // tube
        cube(size=[length, outer_width, outer_height]);

        // subtract where 2020 goes
        translate([-0.01, wall_thickness, -0.01])
        cube(size=[length+0.02, 2020_width, 2020_width+0.02]);
    }

    // outside snap indent
    translate([0, wall_thickness, 2020_width/2-2020_center_width/2])
    cube(size=[length,2020_center_depth,2020_center_width]);
    
    // inside snap
    translate([0, outer_width-wall_thickness-2020_center_depth, 2020_width/2-2020_center_width/2])
    cube(size=[length,2020_center_depth,2020_center_width]);
    
    // top snap
    translate([0, wall_thickness+2020_width/2-2020_center_width/2, 2020_width-2020_center_depth])
    cube(size=[length,2020_center_width,2020_center_depth]);
}

module top_platform() {
    // top flat part
    translate([0, 0, 2020_width])
    difference() {
        cube(size=[platform_width, platform_length, platform_thickness]);

        // remove where vertical 2020+corner brace goes
        translate([-0.01, -0.01, -0.01])
        cube(size=[2020_width+wall_thickness, 2020_width+wall_thickness, outer_height+platform_thickness+0.02]);
    }

    // extra support around the outside perimeter
    translate([outer_width, platform_length-wall_thickness, 0])
    cube([platform_width-outer_width, wall_thickness, outer_height]);

    translate([platform_width-wall_thickness, outer_width, 0])
    cube([wall_thickness, platform_length-outer_width, outer_height]);
}

rotate([180,0,0])
mirror([platform_mirror, 0, 0]) {
    translate([outer_width+corner_offset, 0, 0])
    2020_hug(platform_width-outer_width-corner_offset);

    translate([outer_width, outer_width+corner_offset, 0])
    rotate([0, 0, 90])
    2020_hug(platform_length-outer_width-corner_offset);

    top_platform();
}
