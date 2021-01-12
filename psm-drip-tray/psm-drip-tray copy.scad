include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <BOSL/sliders.scad>

bottom_thickness = 3;
mount_thickness = 7.75;
side_thickness = 3;
base_screw_hole_size = 6; // m5 plus slop
mount_screw_hole_size = 8.5; // screw for the build plate

angle = 20; // tilt of the hoolder

width = 50; // 60 will prevent plate from rotating on stand
length = 30;
height = 55;

// internal:
top_mount_length = 25;
main_wall_height = height-bottom_thickness-sin(angle)*top_mount_length;
top_mount_height = cos(angle)*top_mount_length;

// resolution - can be lower for FDM printers ($fa=1;$fs=21; is probably good enough in that case)
$fa = 3;
$fs = .5;

// bottom base with the screw hole
down(bottom_thickness/2)
difference() {
    cuboid([width, length, bottom_thickness], fillet=width/12, edges=EDGES_Z_FR);
    cyl(r=base_screw_hole_size/2, h=bottom_thickness+1);
}

// the main section, with the vertical wall and extra support pillars
up(main_wall_height/2) {
    // back wall
    // back(length/2-side_thickness/2)
    // cuboid([width, side_thickness, main_wall_height]);
    xflip_copy((width-width/6)/2)
    back(length/2-side_thickness/2)
    cuboid([width/6, side_thickness, main_wall_height]);

    // side parts of the back wall for extra stiffness
    back(length/4+length/6-side_thickness)
    xflip_copy(width/2-side_thickness/2) {
        // rectangle part
        cuboid([side_thickness, length/6, main_wall_height]);
        
        // triangle part
        left(length/6-length/24)
        zrot(180)
        right_triangle([length/6, length/6, main_wall_height], align=ALIGN_CENTER, orient=ORIENT_Z);
    }

    // bottom (vertical) half of the pillars
    fwd(length/2-width/12)
    xflip_copy((width-width/6)/2)
    down(main_wall_height/4)
    cuboid([width/6, width/6, main_wall_height/2], fillet=width/12, edges=EDGE_FR_RT);

    // top (tilted) half of the pillars
    up(main_wall_height/4)
    xflip_copy((width-width/6)/2)
    skew_xy(0,atan((length-width/6)/main_wall_height*2))
    cuboid([width/6, width/6, main_wall_height/2], fillet=width/12, edges=EDGE_FR_RT);
}

// some extra thickness along the edges along the Y-axis of the base so the base doesn't flex
xflip_copy((width-width/6)/2)
cuboid([width/6, length, bottom_thickness*2], fillet=width/12, edges=EDGE_FR_RT);

// triangle under the top section so that FDM printers don't have issues with severe/floating overhangs
up(main_wall_height-top_mount_height/4)
back(length/2-length/12-side_thickness/2)
xrot(180)
right_triangle([width, length/6+side_thickness, top_mount_height/2], orient=ORIENT_X, align=ALIGN_CENTER);

// the part that actually holds the build plate
up(main_wall_height+top_mount_height/2-abs(sin(angle)*mount_thickness/2)){
    back(length/2-cos(angle)*mount_thickness/2-sin(angle)*top_mount_length/2)
    xrot(angle)
    difference() {
        cuboid([width, mount_thickness, top_mount_length], fillet=width/4, edges=EDGES_Y_TOP);
        up(top_mount_length/4+.01)
        cuboid([mount_thickness, mount_screw_hole_size, top_mount_length/2+.02], fillet=side_thickness, edges=EDGES_Y_BOT);
    }
}