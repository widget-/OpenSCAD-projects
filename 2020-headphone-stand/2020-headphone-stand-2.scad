include <../lib/2020.scad>

include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

thickness = 4;
width = 10;
bottom_length = 20;
2020_height = 20+thickness;
height = 2020_height;

chamfer = 1;

up(2020_height/2)
2020_hug(length=width, wall_thickness=thickness, chamfer=chamfer, edges=EDGES_Y_ALL+EDGES_X_BK+EDGES_Z_BK);

fwd(2020_height/2 + bottom_length) {
    up(thickness/2)
    cuboid([width, bottom_length * 2, thickness], chamfer=chamfer, edges=EDGES_Y_ALL);
    
    up(thickness/2 + height/2)
    cuboid([width, bottom_length, thickness], chamfer=chamfer, edges=EDGES_Y_ALL);

    yflip_copy()
    back(bottom_length*3/4-thickness/4)
    up(height*3/4)
    skew_xz(0,45)
    cuboid([width, bottom_length/2-thickness/2, thickness], chamfer=chamfer, edges=EDGES_Y_ALL);

    fwd(bottom_length)
    up(height/2)
    cuboid([width, thickness, height], chamfer=chamfer, edges=EDGES_Y_ALL+EDGES_X_FR+EDGES_Z_FR);
}