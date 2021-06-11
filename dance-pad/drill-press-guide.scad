// This model requires the BOSL2 library. Get it from https://github.com/revarbat/BOSL2
include <BOSL2/std.scad>

corner_inset = 30;

thickness = 5;
side_thickness = 5;

hole_diameter = 25.4*5/16;

width = 45;
length = 120;

$fs = 0.2;
$fa = 1;

difference() {
    union() {
        difference() {
            cuboid([length, width, thickness], anchor=BOTTOM+LEFT+BACK);
            cuboid([length-thickness, width-thickness, thickness], anchor=BOTTOM+LEFT+BACK);
        }
        difference() {
            cuboid([width, length, thickness], anchor=BOTTOM+LEFT+BACK);
            cuboid([width-thickness, length-thickness, thickness], anchor=BOTTOM+LEFT+BACK);
        }
        zrot(-45)
        // cuboid([sqrt((length-width)^2*2), thickness, thickness], anchor=BOTTOM+LEFT);
        cuboid([60, thickness, thickness], anchor=BOTTOM+LEFT);

        cuboid([side_thickness, length, thickness+side_thickness], anchor=BOTTOM+RIGHT+BACK);
        cuboid([length, side_thickness, thickness+side_thickness], anchor=BOTTOM+LEFT+FRONT);
        cuboid([side_thickness, side_thickness, thickness+side_thickness], anchor=BOTTOM+RIGHT+FRONT);

        right(corner_inset)
        fwd(corner_inset)
        // cyl(d=hole_diameter+thickness*4, h=thickness, anchor=BOTTOM);
        cyl(d=thickness*5, h=thickness, anchor=BOTTOM);
    }

    right(corner_inset)
    fwd(corner_inset)
    // cyl(d=hole_diameter, h=thickness+.1, anchor=BOTTOM);
    down(.2)
    cyl(d2=0, d1=thickness*2, h=thickness, anchor=BOTTOM);

    zrot(45)
    fwd(60-thickness*2)
    // right(width/4)
    up(thickness/2)
    linear_extrude(thickness/2+.1)
    text("Countersink", halign="center", valign="center", size=thickness/2, $fs=1, font="Liberation Mono:style=Bold");
    

    // right(length/2)
    // fwd(width/4)
    // up(thickness/2)
    // linear_extrude(thickness/2+.1)
    // text("6mm diameter", halign="center", valign="center", size=width/6, $fs=1);

    // // right(2*length/3)
    // // fwd(3*width/4)
    // // up(thickness/2)
    // // linear_extrude(thickness/2+.1)
    // // text("(for threaded inserts)", halign="center", valign="center", size=width/10, $fs=1);

    // fwd(length/2)
    // right(width/4)
    // up(thickness/2)
    // linear_extrude(thickness/2+.1)
    // zrot(90)
    // text("30mm inset", halign="center", valign="center", size=width/6, $fs=1);
}