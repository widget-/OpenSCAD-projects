include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

model_height = 2;

silicone_thickness = 5;
bottom_thickness = 3;

extra_top_space = 2;

fdm_mold_thickness = 1.5;
fdm_mold_bottom_thickness = 1;

module model() {
    import("ear-saver.stl", convexity=4);
}

module sketch() {
    projection()
    model();
}

module positive() {
    model();

    down(extra_top_space/2-0.01)
    linear_extrude(height=extra_top_space, center=true, convexity=6)
    offset(1)
    sketch();

    down(extra_top_space-2/2) {
        xspread(l=125, n=5)
        cuboid([2, 50, 2]);

        xspread(l=125)
        yspread(l=25)
        cuboid([70, 2, 2]);
    }
}

module negative() {
    linear_extrude(height=1, center=true)
    offset(fdm_mold_thickness+silicone_thickness)
    sketch();

    difference() {
        up(extra_top_space+fdm_mold_bottom_thickness/2+bottom_thickness/2)
        linear_extrude(height=extra_top_space+bottom_thickness+model_height, center=true, convexity=6)
        difference() {
            offset(fdm_mold_thickness+silicone_thickness)
            sketch();

            offset(silicone_thickness)
            sketch();
        }

        up(extra_top_space+5) {
            xspread(l=125, n=5)
            cuboid([2, 80, 2]);

            xspread(l=125)
            yspread(l=25)
            cuboid([70, 2, 2]);
        }
    }
}

color("#09F")
negative();

color("#FF05")
up(6)
yrot(180)
positive();