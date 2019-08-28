include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <BOSL/sliders.scad>
use <BOSL/masks.scad>
use <BOSL/beziers.scad>

thickness = 1;
radius = 75;
height = 75;
submerged_height = 60;
grid_height = 5;
$fn=200;

difference() {
    cyl(h=height, r=radius);

    up(thickness)
    cyl(h=height, r=radius-thickness);

    up(submerged_height/2)
    zrot_copies(n=60)
    cuboid(size=[radius*3, 2, height-submerged_height-5]);

    down(height/2-thickness)
    zrot_copies(n=8, r=radius)
    cyl(h=7, r=1.5, orient=ORIENT_X);
}

difference() {
    intersection() {
        cyl(h=height, r=radius);

        union() {
            down(height/2-grid_height)
            xspread(l=radius*2, spacing=3)
            cube([thickness,radius*2,thickness],center=true);
            
            down(height/2-grid_height)
            yspread(l=radius*2, spacing=3)
            cube([radius*2,thickness,thickness],center=true);

            down(height/2-grid_height/2)
            yspread(l=radius*2, spacing=3)
            xspread(l=radius*2, spacing=3)
            cube([thickness,thickness,grid_height],center=true);

        }
    }

    down(height/2-thickness*2)
    zrot_copies(n=8, r=radius)
    cuboid([7,3,grid_height]);
}