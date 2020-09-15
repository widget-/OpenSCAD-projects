include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

bottle_diameter = 82;
depth = 150;

radial_thickness = 4;
depth_thickness = 4;
end_thickness = 5;
rotations = 1/3;
threads = 6; // even number only for now

slop = 0.1;

_wire_depth = depth-end_thickness*2-PI*bottle_diameter/threads+depth_thickness*2;

$fa = 3;
$fs = 3;

echo("hello");
echo(_wire_depth);

grid2d(cols=2, rows=3, spacing=bottle_diameter+radial_thickness, stagger=true) {
    difference() {
        union() {
            difference() {
                cyl(r=bottle_diameter/2+radial_thickness, h=depth);
                // cyl(r=bottle_diameter/2+1, h=depth-end_thickness*4);

                zrot_copies(n=threads/2)
                zrot(180/threads)// `sa` isn't working above?
                render()
                cuboid([bottle_diameter+radial_thickness*2+1, bottle_diameter+radial_thickness*2+1, depth-end_thickness*2], chamfer=bottle_diameter/2+radial_thickness, edges=EDGES_X_ALL);

                
                cyl(r=bottle_diameter/2, h=depth+1);

                cyl(r=bottle_diameter/2+radial_thickness*2+1, h=_wire_depth-depth_thickness);
            }

            linear_extrude(height=_wire_depth, center=true, convexity=10, twist=360*rotations) {
                zrot_copies(n=threads, r=bottle_diameter/2+radial_thickness/2)
                square([radial_thickness, depth_thickness], center=true);
            }

            linear_extrude(height=_wire_depth, center=true, convexity=10, twist=-360*rotations) {
                zrot_copies(n=threads, r=bottle_diameter/2+radial_thickness/2)
                square([radial_thickness, depth_thickness], center=true);
            }
        }

        xspread(bottle_diameter*2)
        cuboid([bottle_diameter-radial_thickness, bottle_diameter, depth+1]);

        right(bottle_diameter/2+depth_thickness/2)
        zflip_copy(depth/2-depth_thickness*2)
        cuboid([radial_thickness+1, depth_thickness+slop, depth_thickness*2+slop]);
    }

    left(bottle_diameter/2+depth_thickness/2)
    zflip_copy(depth/2-depth_thickness*2)
    cuboid([radial_thickness, depth_thickness-slop, depth_thickness*2-slop], chamfer=radial_thickness/2, edges=EDGE_BOT_LF);

}