include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <BOSL/sliders.scad>
use <BOSL/masks.scad>
use <BOSL/beziers.scad>


thickness = 2;
tank_radius = 50;
platform_radius = 45;
height = 60;
grid_height = 5;
grid_spacing = 5;
$fn=50;

difference() {
    cyl(h=height, r=platform_radius);

    cyl(h=height+1, r=platform_radius-thickness);

    zrot_copies(n=60)
    cuboid(size=[platform_radius*3, 2, height-5]);

}

difference() {
    intersection() {
        cyl(h=height, r=platform_radius);

        union() {
            down(height/2)
            xspread(l=platform_radius*2, spacing=grid_spacing)
            cube([thickness,platform_radius*2,thickness],center=true);
            
            down(height/2)
            yspread(l=platform_radius*2, spacing=grid_spacing)
            cube([platform_radius*2,thickness,thickness],center=true);


        }
    }

}




// right(tank_radius*2)
difference() {
    cyl(h=height+10, r=tank_radius);

    up(thickness)
    cyl(h=height+11, r=tank_radius-thickness);
}