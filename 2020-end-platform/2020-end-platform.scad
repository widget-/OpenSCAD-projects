include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

// parameters:
width = 210;
length = 200;
thickness = 5;
strut_thickness = 1.2;
strut_height = 15;
bottom_thickness = .6;
screw_cutout_radius = 5.5/2; // m5 with some tolerance
screw_holes_per_side = 1;
brace_spacing = 25;
2020_size = 20.3;
2020_holder_length = 50;
2020_notch_width = 5.8; // 6 with tolerance
2020_notch_depth = 1.5; // measured at 1.9, Zyltech doesn't list this dimension

// there aren't many circles here, so more precision is fine:
$fa = 1;
$fs = .5;

// xspread and yspread can't "stretch" the spacing to fill, so calculate it manually:
_brace_count_w = floor((width-thickness)/brace_spacing);
_brace_spacing_w = (width-thickness)/_brace_count_w;
_brace_count_l = floor((length-thickness)/brace_spacing);
_brace_spacing_l = (length-thickness)/_brace_count_l;

// top platform
down(bottom_thickness/2)
cuboid([width, length, bottom_thickness], fillet=thickness/4, edges=EDGES_Z_ALL);

// braces under the top
up(strut_height/2) {
    difference() {
        union() {
            // spread along y axis, with thicker outside edges
            yspread(l=length-thickness, spacing=_brace_spacing_l)
            if ($idx == 0 || $idx == (_brace_count_l))
                cuboid([width, thickness, strut_height], fillet=thickness/4, edges=EDGES_Z_ALL);
            else
                cuboid([width, strut_thickness, strut_height], fillet=strut_thickness/2, edges=EDGES_Z_ALL);

            // spread along x axis
            xspread(l=width-thickness/2, spacing=_brace_spacing_w)
            if ($idx == 0 || $idx == (_brace_count_w))
                cuboid([thickness, length, strut_height], fillet=thickness/4, edges=EDGES_Z_ALL);
            else
                cuboid([strut_thickness, length, strut_height], fillet=strut_thickness/2, edges=EDGES_Z_ALL);

            // diagonals
            zrot_copies([atan(length/width), 180-atan(length/width)])
            cuboid([sqrt(width*width+length*length)-thickness*3/2, thickness, strut_height], chamfer=thickness/4, edges=EDGES_Z_ALL);
        }

        cuboid([2020_size, 2020_size, strut_height+.02]);
    }
}

// part to hold the 2020
up(2020_holder_length/2) {
    // main square shell
    difference() {
        union() {
            // main shell
            difference() {
                cuboid([2020_size+thickness*2, 2020_size+thickness*2, 2020_holder_length]);
                
                // main center hole
                up(thickness)
                cuboid([2020_size, 2020_size, 2020_holder_length]);
            }
            
            // notches
            zrot_copies(n=4, r=2020_size/2-2020_notch_depth/2+.01)
            cuboid([2020_notch_depth, 2020_notch_width, 2020_holder_length]);
        }

        // m5 spots
        up(strut_height)
        // zspread(n=screw_holes_per_side, l=2020_holder_length/2)
        zrot_copies(n=4, r=2020_size/2-2020_notch_depth/2+thickness/2)
        yrot(90)
        cyl(r=screw_cutout_radius, h=thickness+2020_notch_depth+.02);

        // spacing around holes so the notches don't block the t-nuts
        up(strut_height)
        // zspread(n=screw_holes_per_side, l=2020_holder_length/2)
        zrot_copies(n=4, r=2020_size/2-2020_notch_depth-.01)
        cuboid([2020_notch_depth*2+.02, screw_cutout_radius*6, screw_cutout_radius*6], chamfer=2020_notch_depth+.01, edges=EDGES_RIGHT);

    }
}
