include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
// use <BOSL/masks.scad>
// use <BOSL/metric_screws.scad>

_2020_center_depth = 0.8;
_2020_top_center_depth = 2;
_2020_center_width = 5.5;
_2020_width = 21;
_2020_thickness = 5;
_2020_hole_radius = 6/2; // 6mm for M5 bolts+slop


floor_thickness = 5;
wall_thickness = 8;

$fa=1;
$fs=1;

// ps2 slim SCPH-70001 dimensions: 230 × 28 × 152 mm / 9 × 1 × 6 in (w/h/d)
platform_width = 152+_2020_width+wall_thickness*2;
platform_depth = 230+wall_thickness*2;
wall_height = 50;

side_wall_hole_width = 15;
side_wall_thickness = 3;
side_wall_hole_height = 30;



module clamp_negative() {
    difference() {
        cuboid([_2020_width, _2020_width, wall_height+.1]);
        zrot_copies(n=4, r=_2020_width/2-_2020_center_depth/2+.05) {
            cuboid([_2020_center_depth+.1, _2020_center_width+.1, wall_height+.2]);
        }
    }
    zrot_copies(n=4, r=_2020_width/2+wall_thickness/2-_2020_center_depth/2) {
        cyl(r=_2020_hole_radius, h=wall_thickness+_2020_center_depth+1, orient=ORIENT_X);
    }
}

module clamp_hole() {
    up(wall_height/2)
    difference() {
        union() {
            difference() {
                cuboid([_2020_width+wall_thickness*2, _2020_width+wall_thickness*2, wall_height]);
                cuboid([_2020_width, _2020_width, wall_height+.1]);
            }
            zrot_copies(n=4, r=_2020_width/2-_2020_center_depth/2) {
                cuboid([_2020_center_depth, _2020_center_width, wall_height]);
            }
        }
        zrot_copies(n=4, r=_2020_width/2) {
            cyl(r=_2020_hole_radius, h=_2020_width/2+_2020_center_depth/2+wall_thickness/2, orient=ORIENT_X);
        }
    }
}

module platform() {
    difference() {
        union() {
            // outer wall
            difference() {
                cuboid([platform_width+wall_thickness*2, platform_depth+wall_thickness*2, wall_height]);

                up(floor_thickness/2)
                cuboid([platform_width, platform_depth, wall_height]);

                // holes on the side of the walls:
                // cutouts along y axis
                down(wall_height/2-floor_thickness/2-side_wall_hole_height/2)
                xspread(l=platform_width - wall_thickness - side_wall_hole_width, spacing=side_wall_hole_width+side_wall_thickness)
                cuboid([side_wall_hole_width,platform_depth+wall_thickness*3,side_wall_hole_height]);
                
                // cutouts along x axis
                // zspread(l=wall_height-wall_thickness*2, spacing=(wall_height-side_wall_thickness)/2)
                down(wall_height/2-floor_thickness/2-side_wall_hole_height/2)
                yspread(l=platform_depth - wall_thickness - side_wall_hole_width, spacing=side_wall_hole_width+side_wall_thickness)
                cuboid([platform_width+wall_thickness*3,side_wall_hole_width,side_wall_hole_height]);
            }
            // 2020 wall
            right(platform_width/2+wall_thickness-_2020_width/2-wall_thickness)
            fwd(platform_depth/2+wall_thickness-_2020_width/2-wall_thickness)
            cuboid([_2020_width+wall_thickness*2, _2020_width+wall_thickness*2, wall_height]);
        }
        
        right(platform_width/2+wall_thickness-_2020_width/2-wall_thickness)
        fwd(platform_depth/2+wall_thickness-_2020_width/2-wall_thickness)
        clamp_negative();
    }
    
}

// left(_2020_width/2+wall_thickness)
// back(_2020_width/2+wall_thickness)
// clamp_hole();

platform();
