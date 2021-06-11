// This model requires the BOSL2 library. Get it from https://github.com/revarbat/BOSL2
include <BOSL2/std.scad>

corner_inset = 25;

extrusion_width = 20;
extrusion_height = 20;
extrusion_notch = 6; // 6.2 officially

bolt_diameter = 5;
nut_diameter = 8;
nut_thickness = 4.6;

thickness = 10;

panel_width = 280;
panel_thickness = 25.4/4;
panel_bolt_diameter = 25.4/4;

panel_spacing = 1;

$fa = 0.5;
$fs = 0.2;

module panel_preview() {
    left(panel_width/2-extrusion_width/4-panel_spacing/2)
    back(panel_width/2-extrusion_width/4-panel_spacing/2)
    difference() {
        cuboid([panel_width, panel_width, panel_thickness], rounding=panel_thickness/2, edges=TOP);

        xcopies(panel_width-corner_inset*2)
        ycopies(panel_width-corner_inset*2)
        cyl(d=panel_bolt_diameter, h=panel_thickness+1);
    }
}

module corner_bracket() {
    _width = corner_inset + panel_bolt_diameter + thickness - extrusion_width/2 - panel_spacing/2;
    down(extrusion_width/2)
    left(_width/2)
    back(_width/2)
    difference() {
        cuboid([_width, _width, extrusion_height]);

        left((_width - thickness - panel_bolt_diameter)/2)
        back((_width - thickness - panel_bolt_diameter)/2) {
            cyl(h=extrusion_height+1, d=bolt_diameter);
        }
        // m6 hole

    }
}

corner_bracket();

color("#FFFFFF66")
up(panel_thickness/2)
panel_preview();

