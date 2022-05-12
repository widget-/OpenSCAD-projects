include <BOSL2/std.scad>

thickness = 5;
rows = 6;
cols = 2;

outer_diameter = 35;
center_diameter = 25;
lower_height = 23;
upper_height = 10;

$fa = 1;
$fs = 1;

difference() {
    _length = outer_diameter * rows + thickness * (rows + 1);
    _width =outer_diameter * cols + thickness * (cols + 1);
    _height = lower_height+upper_height;
    cuboid([_length, _width, _height], rounding=outer_diameter/2+thickness, edges="Z");

    ycopies(n=cols, spacing=outer_diameter+thickness)
    xcopies(n=rows, spacing=outer_diameter+thickness)
    down(.1) {
        cyl(d=center_diameter, h=_height+1);

        down(_height/2)
        cyl(d=outer_diameter, h=lower_height-thickness+.1, anchor=BOTTOM, chamfer2=(outer_diameter-center_diameter)/2);

        up(_height/2-upper_height)
        cyl(d=outer_diameter, h=upper_height+1, anchor=BOTTOM);
    }
}