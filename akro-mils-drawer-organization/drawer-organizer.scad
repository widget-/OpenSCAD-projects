include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

// drawer parameters
layer = "top"; // "top" or "bottom"
stack_size = "tall"; // "tall" or "short"
rows = 2; // shortways across the insert
columns = 4; // longways across the insert

// model parameters
wall_thickness = 1;
inner_fillet_radius = 2;
outer_fillet_radius = 3;
$fs = .5;
$fa = 2.5;

bottom_width = 50;
bottom_length = 64;
bottom_height = 17;

top_width = 52;
top_length = 135;
top_height = 17;


_stack = stack_size == "short" ? 2 : 1;
_width = layer == "top" ? top_width : bottom_width;
_length = layer == "top" ? top_length : bottom_length;
_height = layer == "top" ? top_height / _stack : bottom_height / _stack;
_inner_fillet = inner_fillet_radius < (_height-wall_thickness)/2 ? inner_fillet_radius : (_height-wall_thickness)/2;
_outer_fillet = outer_fillet_radius < _height/2 ? outer_fillet_radius : _height/2;

difference() {
    // outer shell
    cuboid([_width, _length, _height], fillet=_outer_fillet, edges=EDGES_ALL-EDGES_TOP);

    // inner cutouts
    up(wall_thickness)
    yspread(n=rows, spacing=(_length-wall_thickness)/rows)
    xspread(n=columns, spacing=(_width-wall_thickness)/columns)
    cuboid([(_width-wall_thickness*2)/columns-wall_thickness, _length/rows-wall_thickness*2, _height], fillet=_inner_fillet, edges=EDGES_ALL-EDGES_TOP);
}
