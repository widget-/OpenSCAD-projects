// unit is 1mm


include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <BOSL/sliders.scad>
use <BOSL/masks.scad>


// general
thickness = 4;
$fn = 100;

// top
top_outer_diameter = 130;
top_height = 5;

// filter
filter_bottom_diameter = 75;
filter_top_diameter = 120;
filter_height = 40;

// middle
middle_height = 30;

// bottom
bottom_outer_diameter = 28;
bottom_height = 30;


module filter_inner() {
    difference() {
        cylinder(r1=filter_bottom_diameter/2, r2=filter_top_diameter/2+thickness*3, h=filter_height, center=true, $fn=24);
        cylinder(r1=filter_bottom_diameter/2-thickness, r2=filter_top_diameter/2+thickness, h=filter_height+0.02, center=true, $fn=24);

        zspread(n=5,l=filter_height*3/4) {
            cube(size=[filter_top_diameter*2, filter_top_diameter*2, filter_height/8], center=true);
        }

    }

    zrot_copies(n=24)
    right(filter_bottom_diameter/4 + filter_top_diameter/4 + thickness/2)
    skew_xy(atan((filter_top_diameter-filter_bottom_diameter+thickness*4)/2 / filter_height),0)
    cube(size=[thickness, thickness, filter_height], center=true);
    
    zrot_copies(n=12)
    down(filter_height/2 - thickness/2)
    cube(size=[filter_bottom_diameter, thickness, thickness], center=true);
}

module filter_outer() {
    difference() {
        cylinder(r1=filter_bottom_diameter/2+thickness*2, r2=filter_top_diameter/2+thickness*4, h=filter_height+thickness*2, center=true, $fn=24);
        cylinder(r1=filter_bottom_diameter/2+thickness, r2=filter_top_diameter/2+thickness*3, h=filter_height+thickness*2+0.02, center=true, $fn=24);

        zspread(n=5,l=filter_height*3/4+thickness) {
            cube(size=[filter_top_diameter*2, filter_top_diameter*2, filter_height/8], center=true);
        }

    }

    zrot_copies(n=24)
    right(filter_bottom_diameter/4 + filter_top_diameter/4 + thickness*3)
    skew_xy(atan((filter_top_diameter-filter_bottom_diameter+thickness*1.4)/2 / filter_height),0)
    cube(size=[thickness*2, thickness, filter_height+thickness*2], center=true);
    
    zrot_copies(n=12)
    down(filter_height/2 + thickness/2)
    cube(size=[filter_bottom_diameter+thickness*4, thickness, thickness], center=true);
}

module top() {
    difference() {
        cylinder(r1=filter_bottom_diameter/2+thickness*4, r2=filter_top_diameter/2+thickness*6, h=filter_height+thickness*3, center=true);
        cylinder(r1=filter_bottom_diameter/2+thickness*3, r2=filter_top_diameter/2+thickness*5, h=filter_height+thickness*3+0.02, center=true);
    }
}

module middle() {
    difference() {
        cylinder(r1=bottom_outer_diameter/2, r2=filter_bottom_diameter/2+thickness*4, h=middle_height, center=true);
        cylinder(r1=bottom_outer_diameter/2-thickness, r2=filter_bottom_diameter/2+thickness*3, h=middle_height+0.02, center=true);
    }
}

module bottom() {
    difference() {
        cylinder(r=bottom_outer_diameter/2, h=bottom_height, center=true);
        cylinder(r=bottom_outer_diameter/2-thickness, h=bottom_height*2, center=true);
    }
}


up(filter_height/2 + middle_height/2 + thickness * 1.5)
top();


right(170)
up(filter_height/2 + middle_height/2 + thickness*3.2)
filter_inner();


back(170)
up(filter_height/2 + middle_height/2 + thickness*2)
filter_outer();


middle();

down(middle_height/2 + bottom_height/2)
bottom();
