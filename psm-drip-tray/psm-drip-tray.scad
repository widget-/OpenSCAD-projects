include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <BOSL/sliders.scad>

fsm_mount_width = 60;
fsm_mount_height = 8;
fsm_mount_depth = 20;
fsm_plate_screw_dia = 8;

thickness = 3;
angle_y = -45;
angle_x = -25;
angle_z = 15;
offset_x = -25; // from left center of main mount
offset_y = -4.9;
offset_z = -10; // from left center of main mount
slop = 0.2; // assumed resin printing

$fa = 1;
$fs = 1;

zrot(90)
xrot(-90) {
    // main attachment
    difference() {
        // cuboid([fsm_mount_width+thickness*2, fsm_mount_depth, fsm_mount_height+thickness*2]);
        sparse_strut(l=fsm_mount_width+thickness*2, h=fsm_mount_depth, thick=fsm_mount_height+thickness*2, strut=thickness, maxang=45, orient=ORIENT_X_90);
        cuboid([fsm_mount_width+slop, fsm_mount_depth+1, fsm_mount_height+slop]);
    }

    // angled plate
    left(fsm_mount_width/2)
    fwd(fsm_mount_depth/2)
    translate([offset_x, sin(angle_x)*fsm_mount_depth+offset_y, offset_z])
    xrot(angle_x)
    yrot(angle_y)
    zrot(angle_z)
    difference() {
        union() {
            sparse_strut(l=fsm_mount_width+2, h=fsm_mount_depth*2, thick=fsm_mount_height-slop, strut=thickness, maxang=50, orient=ORIENT_X_90);
            
            fwd(fsm_mount_depth*3/4-thickness/2)
            left(1)
            cuboid([fsm_plate_screw_dia+thickness*2, fsm_mount_depth/2+thickness, fsm_mount_height-slop], fillet=min(fsm_mount_depth/2+thickness, fsm_mount_height-slop)/2, edges=EDGES_Z_BK);

        }
    // cuboid([fsm_mount_width+2, fsm_mount_depth*2, fsm_mount_height-slop]);
        fwd(fsm_mount_depth*3/4+.01)
        left(1)
        cuboid([fsm_plate_screw_dia+slop, fsm_mount_depth/2+.02, fsm_mount_height+1], fillet=fsm_plate_screw_dia/2, edges=EDGES_Z_BK);
    }

    // connect the two
    // yflip_copy(fsm_mount_depth/2-thickness)
    // hull() {
    //     // bottom part of main attachment
    //     down(fsm_mount_height/2+thickness/2)
    //     cuboid([fsm_mount_width+thickness*2, thickness*2, thickness-slop*2]);
        
    //     back(thickness/2)
    //     left(fsm_mount_width/2)
    //     translate([offset_x, 0, offset_z])
    //     yrot(angle_y)
    //     right(abs(offset_x)-thickness/4)
    //     cuboid([thickness/2, thickness, fsm_mount_height-slop]);
    // }

    hull() {
        // left part of main attachment
        left(fsm_mount_width/2+thickness-.01)
        cuboid([.02, fsm_mount_depth, fsm_mount_height+thickness*2]);
        
        // right edge of angled plate
        left(fsm_mount_width/2)
        fwd(fsm_mount_depth/2)
        translate([offset_x, sin(angle_x)*fsm_mount_depth+offset_y, offset_z])
        xrot(angle_x)
        yrot(angle_y)
        zrot(angle_z)
        right(fsm_mount_width/2+1-.01)
        back(fsm_mount_depth/2)
        cuboid([.02, fsm_mount_depth, fsm_mount_height-slop]);
    }
}