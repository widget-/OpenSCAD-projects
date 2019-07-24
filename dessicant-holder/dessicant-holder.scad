// units
mm = 1;
cm = 10*mm;
in = 2.4*mm;
nc = 0.001;

// parameters
tray_width = 12*cm;
tray_length = 6*cm;
tray_height = 2*cm;
tray_bottom_thickness = 1.2*mm;
tray_hole_size = 1.8*mm;
tray_hole_spacing = .8*mm;
tray_extra_height = 4*mm;

module hole_panel(width, length, thickness, hole_size, hole_spacing) {
    linear_extrude(height=thickness) {
        render()
        difference() {
            square([width, length]);

            for (x = [0:ceil(width/hole_spacing)-2]) {
                for (y = [0:ceil(length/hole_spacing)-2]) {
                    translate([(x+.5)*hole_spacing, (y+.5)*hole_spacing])
                    square([hole_size, hole_size]);
                }
            }
        }
    }
}

// bottom
hole_panel(tray_width, tray_length, tray_bottom_thickness,
    tray_hole_size, tray_hole_size+tray_hole_spacing);

// front
translate([0, tray_bottom_thickness, 0])
rotate([90, 0, 0])
hole_panel(tray_width, tray_height, tray_bottom_thickness,
    tray_hole_size, tray_hole_size+tray_hole_spacing);

// back
translate([0, tray_length, 0])
rotate([90, 0, 0])
hole_panel(tray_width, tray_height, tray_bottom_thickness,
    tray_hole_size, tray_hole_size+tray_hole_spacing);
    
// left
rotate([90, 0, 90])
hole_panel(tray_length, tray_height, tray_bottom_thickness,
    tray_hole_size, tray_hole_size+tray_hole_spacing);

// right
translate([tray_width-tray_bottom_thickness, 0, 0])
rotate([90, 0, 90])
hole_panel(tray_length, tray_height, tray_bottom_thickness,
    tray_hole_size, tray_hole_size+tray_hole_spacing);

// extra height/stacking area
translate([0, 0, tray_height-tray_bottom_thickness])
linear_extrude(height=tray_extra_height) {
    difference() {
        offset(r=tray_bottom_thickness)
        square(size=[tray_width, tray_length]);

        square(size=[tray_width, tray_length]);
    }
}