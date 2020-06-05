include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

thickness = 2;

hard_drive_height = 30;
hard_drive_width = 100;
hard_drive_screw_spacing = 100;
hard_drive_screw_to_bottom_spacing = 6.5;

length = 115; // including thickness, based on printer dimensions
height = hard_drive_height+thickness*5; // 2 thicknesses on bottom and 3 on top

screw_diameter = 4; // 3.5mm plus some slop

slop = 0.1;

$fa = 1;
$fs = .5;

difference() {
    cuboid([thickness, length, height], align=ALIGN_POS, chamfer=thickness/4, edges=EDGES_BOTTOM+EDGES_RIGHT);

    yspread(hard_drive_screw_spacing)
    up(thickness*2+hard_drive_screw_to_bottom_spacing-thickness)
    cuboid([max(thickness+1, screw_diameter), screw_diameter, thickness*5], fillet=screw_diameter/2, align=ALIGN_POS, edges=EDGES_X_ALL);
}

right(-thickness*2)
difference() {
    cuboid([thickness*4, length, thickness*2], align=ALIGN_POS, chamfer=thickness/4, edges=EDGES_BOTTOM);
    cuboid([thickness*2+slop, length-thickness*2+slop*2, thickness*2+slop], chamfer=thickness/2, edges=EDGES_Y_TOP);

    // for resin printers to prevent resin pooling:
    yspread(length/2)
    cuboid([thickness+slop, thickness, thickness*3], align=ALIGN_POS);
}

up(height) {
    left(thickness*2)
    cuboid([thickness*4, length, thickness], align=ALIGN_NEG);

    down(thickness)
    left(thickness*2)
    yrot(180)
    right_triangle([thickness*4, length, thickness*2], align=ALIGN_POS);

    left(thickness*2)
    cuboid([thickness*2-slop, length-thickness*2-slop*2, thickness*2-slop], chamfer=thickness/2, edges=EDGES_Y_TOP);
}