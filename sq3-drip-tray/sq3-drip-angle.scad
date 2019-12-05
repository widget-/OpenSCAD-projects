include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

width = 31;
depth = 32;
height = 18;
offset = 1;
thickness = 4;
back_thickness = 10;
vertical_gap = 85;

hole_radius = 5/2;

x_rotation = -15;
y_rotation = 35;
z_rotation = 0;

$fn = 50;

difference() {
    cuboid([width+offset+thickness*2, depth+offset+thickness, height+thickness*2], chamfer=thickness/2, edges=EDGES_ALL);
    back((thickness+offset)/2+.01)
    cuboid([width+offset, depth+offset, height+offset]);
}

down(vertical_gap/2+height/2+thickness)
back(depth/2-back_thickness/2+thickness/2+offset/2)
// cuboid([width, back_thickness, vertical_gap]);
// zrot(z_rotation)
// linear_extrude(height=vertical_gap, center=true, twist=z_rotation, $fn=50)
// square([width, back_thickness], center=true);
cuboid([width, back_thickness, vertical_gap+thickness], center=true, chamfer=thickness/2, edges=EDGES_ALL-EDGES_X_ALL);

// down(vertical_gap+height/2+thickness)
// back(depth/2-back_thickness/2+thickness/2+offset/2)
// // right(tan(y_rotation)*width/2)
// yrot(y_rotation)
// // zrot(z_rotation)
// cuboid([width-offset, back_thickness, height-offset], chamfer=thickness/2);


down(vertical_gap+thickness-height/2)
back(offset-back_thickness+thickness/2)
// right(tan(z_rotation)*width/2)
xrot(x_rotation)
yrot(y_rotation)
zrot(z_rotation)
cuboid([width-offset, depth-offset+back_thickness, height-offset], chamfer=thickness/2);