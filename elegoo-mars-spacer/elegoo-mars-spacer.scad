// unit is 1 mm

include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <BOSL/sliders.scad>
use <BOSL/masks.scad>

thickness = 3;
mars_inner_diameter = 187;
mars_outer_diameter = 197;
roundness = 15;

bottom_height = 3;
middle_height = 35;
top_height = 3;

// m10 washer is 10mm ID and 20mm OD
washer_hole_diameter = 14; // leave some extra space
washer_snap_diameter = 20.5; // indent for washer to "snap" in
washer_thickness = 2;
washer_hole_zoffset = middle_height/2-top_height-7;

$fn=100;

// 58 to 80 from plate holder OD


module square_border(inner_diameter, thickness, corner_radius, height) {
    difference() {
        cuboid([inner_diameter + thickness, inner_diameter + thickness, height], fillet=corner_radius, edges=EDGES_Z_ALL);
        cuboid([inner_diameter, inner_diameter, height + 1], fillet=corner_radius, edges=EDGES_Z_ALL);
    }
}

module slanted_square_border(id1, id2, t1, t2, r1, r2, height) {
    difference() {
        rounded_prismoid([id1+t1, id1+t1], [id2+t2, id2+t2], height, r=r1, center=true);
        rounded_prismoid([id1, id1], [id2, id2], height+1, r1=r1, r2=r2, center=true);
    }
}

module nylon_washer_holder(t=thickness, wt=washer_thickness, id=washer_hole_diameter, od=washer_snap_diameter) {
    cylinder(r=id/2, h=t*2, center=true);

    translate([0,0,(t-washer_thickness+.2)/2]) {
        cylinder(r=washer_snap_diameter/2, h=wt+.2, center=true);

        left(100/2)
        cube([100, washer_snap_diameter, wt], center=true);
    }
    
    translate([0,0,-(t-washer_thickness+.2)/2]) {
        cylinder(r=washer_snap_diameter/2, h=wt+.2, center=true);

        left(100/2)
        cube([100, washer_snap_diameter, wt], center=true);
    }
}

difference() {
    union() {
        up((middle_height+top_height)/2)
        zscale(.01)
        square_border(mars_inner_diameter, thickness, roundness+5, top_height*100);

        up((middle_height+top_height)/2)
        zscale(.01)
        square_border(mars_outer_diameter+6, 3, roundness, top_height*100);

        zscale(.01)
        slanted_square_border(mars_outer_diameter-thickness, mars_inner_diameter, thickness+4, mars_outer_diameter-mars_inner_diameter+9, roundness, roundness+5, 100*middle_height);
        
        translate([-mars_outer_diameter/2, 0, washer_hole_zoffset-1.5])
        xflip_copy()
        yrot(90)
        up(4)
        prismoid(
            size1=[washer_hole_diameter+9.5, washer_hole_diameter+12],
            size2=[washer_hole_diameter+7, washer_hole_diameter+7],
            h=1,
            shift=[-2.5,0],
            center=true
        );
    }

    forward(mars_outer_diameter/2-(58+80)/2)
    cube([mars_outer_diameter-thickness, 22, 301], center=true);

    // forward(60)
    left(mars_outer_diameter/2)
    up(washer_hole_zoffset)
    yrot(90)
    nylon_washer_holder(t=6);
}

down((bottom_height+middle_height)/2)
zscale(.01)
square_border(mars_outer_diameter-thickness, thickness+4, roundness, bottom_height*100);