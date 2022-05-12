include <BOSL2/std.scad>
$fa = 2;
$fs = .5;

thickness = 5;
angle = 15;

outer_width = 62;
fan_diameter = 57;
screw_spacing = 50;
screw_hole_diameter = 5;
thermal_probe_diameter = 4; // optional hole to keep probe near heater

fan_thickness = 15;
heater_thickness = 25;

extra_bottom_spacing = 20;

$debug = false; // check center of mass and alignment

_width = max(max(screw_spacing, fan_diameter), outer_width) + thickness*2;
_height = thickness + extra_bottom_spacing + sin(angle)*heater_thickness + min(_width, outer_width);
_length = sin(angle) * outer_width + cos(angle) * (thickness + fan_thickness + heater_thickness);
_bottom_offset = sin(angle) * (_height - fan_diameter/2 - thickness) * 2 + cos(angle)*(heater_thickness - fan_thickness);
echo("cos(angle)", cos(angle));
echo("sin(angle)", sin(angle));
echo("_bottom_offset", _bottom_offset);

// bottom
// back(_length/2-fan_thickness-thickness/2)
fwd(_bottom_offset/2)
xflip_copy(_width/2) {
    // side legs
    cuboid([thickness*2, _length, thickness], anchor=TOP+RIGHT);

    if ($preview && $debug)
    color("red")
    ycopies(n=3, l=_length)
    cuboid([thickness*2, .1, _height], anchor=BOTTOM);

    // triangle braces
    if (angle != 0)
        back(_bottom_offset/2-cos(angle)*thickness/2)
        down(sin(angle)*thickness)
        right_triangle([cos(angle)*_height, sin(angle)*_height, thickness/2], orient=LEFT, anchor=LEFT+BOTTOM+BACK);
}

// center bar
cuboid([_width, thickness, thickness], anchor=TOP);

// fan mount
down(sin(angle)*thickness/2)
xrot(angle)
union() {
    difference() {
        cuboid([_width, thickness, _height], anchor=BOTTOM);

        // thermal probe cutout
        up(thickness)
        cyl(d=thermal_probe_diameter, h=thickness+1, orient=FRONT);

        up(_height - fan_diameter/2 - thickness) {
            // main fan hole cutout
            cyl(d=fan_diameter, h=thickness+1, orient=FRONT);

            // screw cutouts
            xcopies(screw_spacing)
            zcopies(screw_spacing)
            cyl(d=screw_hole_diameter, h=thickness+1, orient=FRONT);
        }
    }
    
    if ($preview) {
        back(thickness/2 + fan_thickness*2)
        up(_height - fan_diameter/2 - thickness)
        color("white")
        xrot(-angle)
        rotate($vpr)
        up($vpd/2)
        text("fan", halign="center", valign="center", size=6);

        fwd(thickness/2 + heater_thickness*2)
        up(_height - fan_diameter/2 - thickness)
        color("white")
        xrot(-angle)
        rotate($vpr)
        up($vpd/2)
        text("heater", halign="center", valign="center", size=6);

        back(thickness/2)
        up(_height - fan_diameter/2 - thickness)
        color("#FF66CC55")
        cuboid([outer_width, fan_thickness, outer_width], anchor=FRONT);
        

        fwd(thickness/2)
        up(_height - fan_diameter/2 - thickness)
        color("#FFAA6655")
        cuboid([outer_width, heater_thickness, outer_width], anchor=BACK);

        if ($debug) {
            up(_height - fan_diameter/2 - thickness)
            color("#FF0000")
            cuboid([_width+thickness*2, _length, 0.1]);

            color("#FF0000")
            cuboid([_width+thickness*2, 0.1, _height], anchor=BOTTOM);

            fwd((heater_thickness-fan_thickness)/2)
            color("#FF0000")
            cuboid([_width+thickness*2, 0.1, _height], anchor=BOTTOM);
        }
    }
}