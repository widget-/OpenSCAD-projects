// units
mm = 1;
cm = 10*mm;
in = 2.4*mm;
nc = 0.001;

// parameters
tray_width = 4*cm;
tray_length = 15*cm;
tray_height = 4*cm;
tray_bottom_thickness = 2.4*mm;
tray_hole_width = 10*mm;
tray_hole_height = 1.8*mm;
tray_hole_spacing = 1.2*mm;
tray_extra_height = 4*mm;
tray_extra_margin = 0.5*mm;

module hole_panel(width, length, thickness, hole_width, hole_height, hole_spacing_x, hole_spacing_y) {
    linear_extrude(height=thickness) {
        render()
        difference() {
            square([width, length]);

            for (x = [0:ceil(width/hole_spacing_y)-2]) {
                for (y = [0:ceil(length/hole_spacing_y)-2]) {
                    translate([(x+.5)*hole_spacing_x, (y+.5)*hole_spacing_y])
                    square([hole_width, hole_height]);
                }
            }
        }
    }
}

// bottom
hole_panel(tray_width, tray_length, tray_bottom_thickness,
    tray_hole_width, tray_hole_height, tray_hole_width+tray_hole_spacing, tray_hole_height+tray_hole_spacing);

// front
translate([0, tray_bottom_thickness, 0])
rotate([90, 0, 0])
hole_panel(tray_width, tray_height, tray_bottom_thickness,
    tray_hole_width, tray_hole_height, tray_hole_width+tray_hole_spacing, tray_hole_height+tray_hole_spacing);

// back
translate([0, tray_length, 0])
rotate([90, 0, 0])
hole_panel(tray_width, tray_height, tray_bottom_thickness,
    tray_hole_width, tray_hole_height, tray_hole_width+tray_hole_spacing, tray_hole_height+tray_hole_spacing);
    
// left
rotate([90, 0, 90])
hole_panel(tray_length, tray_height, tray_bottom_thickness,
    tray_hole_width, tray_hole_height, tray_hole_width+tray_hole_spacing, tray_hole_height+tray_hole_spacing);

// right
translate([tray_width-tray_bottom_thickness, 0, 0])
rotate([90, 0, 90])
hole_panel(tray_length, tray_height, tray_bottom_thickness,
    tray_hole_width, tray_hole_height, tray_hole_width+tray_hole_spacing, tray_hole_height+tray_hole_spacing);

// extra height/stacking area
translate([0, 0, tray_height])
linear_extrude(height=tray_extra_height) {
    difference() {
        offset(delta=tray_bottom_thickness+tray_extra_margin)
        square(size=[tray_width, tray_length]);

        offset(delta=tray_extra_margin)
        square(size=[tray_width, tray_length]);
    }
}

difference() {
    hull() {
        // extra height/stacking area
        translate([0, 0, tray_height])
        linear_extrude(height=nc) {
            offset(delta=tray_bottom_thickness+tray_extra_margin)
            square(size=[tray_width, tray_length]);
        }

        translate([0, 0, tray_height-tray_bottom_thickness])
        linear_extrude(height=tray_bottom_thickness) {
                square(size=[tray_width, tray_length]);
        }
    }

    cube(size=[tray_width, tray_length, 1000]);
}
