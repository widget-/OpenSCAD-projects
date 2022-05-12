include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

radius = 42/2;
extra_radius = 10;
length = 20;

center_radius = 10;
center_height = 10;

thickness = 2;
bump_thickness = 1;

$fa = 3;
$fs = .5;

up(center_height/2)
difference() {
    hull() {
        cyl(r=center_radius+thickness*2, h=center_height+thickness);
        
        down(center_height/2)
        cyl(r=radius+extra_radius, h=thickness, fillet2=thickness/2);
    }

    down(thickness/2+.01)
    cyl(r=center_radius, h=center_height);
}

// back_half()
// up(thickness/2)
// difference() {
//     cyl(r=radius+extra_radius, h=thickness, fillet2=thickness/2);
//     cyl(r=center_radius+thickness*2, h=thickness+1);
// }

down(length/2)
difference() {
    cyl(r=radius, h=length, chamfer1=thickness);
    cyl(r=radius-thickness, h=length+.01);
}

down(length/2-thickness/2)
zspread(l=length-thickness*4, n=4)
difference() {
    zdistribute(bump_thickness) {
        cyl(r1=radius, r2=radius+bump_thickness, h=bump_thickness);
        cyl(r1=radius+bump_thickness, r2=radius, h=bump_thickness);
    }
    cyl(r=radius, h=thickness*2+1);
}