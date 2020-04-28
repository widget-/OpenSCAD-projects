include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>


module model() {
    import("ear-saver.stl", convexity=4);
}

module sketch() {
    left(1) // shrug
    import("ear-saver.dxf");
}

module positive() {
    model();

    zscale(5)
    bottom_half(500)
    down(1)
    model();

    down(5-2/2) {
        xspread(l=125, n=5)
        cuboid([2, 50, 2]);

        xspread(l=125)
        yspread(l=25)
        cuboid([70, 2, 2]);
    }
}

sw = 85;
st = 23;
stm = 13;
sbm = -20;
sb = -15;
me = 25;



linear_extrude(height=1, center=true)
xrot(180)
offset(5)
sketch();

difference() {
    up(11/2)
    linear_extrude(height=11-1, center=true, convexity=4)
    xrot(180)
    difference() {
        offset(5)
        sketch();

        offset(3.5)
        sketch();
    }

    up(10) {
        xspread(l=125, n=5)
        cuboid([2, 80, 2]);

        xspread(l=125)
        yspread(l=25)
        cuboid([70, 2, 2]);
    }
}


color("#99990066")
up(6)
yrot(180)
positive();