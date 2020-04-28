include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>


module model() {
    import("ear-saver.stl", convexity=4);
}

model();

zscale(5)
bottom_half(500)
down(1)
model();

down(5-2/2)
xspread(l=125, spacing=25)
cuboid([2, 80, 2]);