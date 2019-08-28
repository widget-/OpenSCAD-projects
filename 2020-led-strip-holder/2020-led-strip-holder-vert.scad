// units
in = 25.4;
cm = 10;
mm = 1;
inf = 10e10;
nc = 10e-3;
$fn = 200;

// params
wall_thickness = 5*mm;
led_clip_thickness = 2*mm;

length = 18*cm;
shield_length = 3*cm;
back_shield_length = 1.5*cm;
clip_length = 1.3*cm;
led_strip_space = 5*mm;
clip_spacing = 3*cm;
clip_angle = 30; //degrees


// constants
2020_width = 20.4*mm;
2020_center_width = 6*mm;
2020_center_depth = .4*mm;
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
    translate([0, wall_thickness+2020_width/2-2020_center_width/2, 2020_width-2020_center_depth*3])
    cube(size=[length,2020_center_width,2020_center_depth*3]);
}


2020_hug(length);

// user-side shield
translate([0, 2020_width+wall_thickness, outer_height-led_clip_thickness])
cube([length, shield_length+wall_thickness, led_clip_thickness]);

// back-side shield
translate([0, 2020_width+wall_thickness, 0])
cube([length, back_shield_length+wall_thickness, led_clip_thickness]);

color("red")
for (i=[0:clip_spacing:length-led_clip_thickness]) {
    translate([i/10*1*cm+clip_spacing/2, outer_width+led_strip_space, outer_height-led_clip_thickness-clip_length])
    cube([led_clip_thickness, led_clip_thickness*2, clip_length]);
}

color("purple")
// led clip notch
translate([0, outer_width+led_strip_space-1, outer_height-led_clip_thickness-clip_length])
cube([length, led_clip_thickness*2+1, led_clip_thickness]);
