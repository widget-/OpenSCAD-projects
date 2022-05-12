include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <BOSL/sliders.scad>
use <BOSL/masks.scad>
use <BOSL/paths.scad>

include <../lib/2020.scad>

// needs to stick out 15mm (5mm past wall thickness)
// headphone top is 30mm

width = 15;
headphone_headband_width = 30;
headphone_offset = 5;

down(21+10)
fwd((21+20)/2)
left(width/2)
2020_hug(length=width);


// this was originally on the top-right but then i realized it made a
// lot more sense to put it on the bottom-right so the top notch could
// hold more of the static rotational stress

back(21/2+10)
down(21/2)
xrot(-90)
{
    yrot(-90)
    linear_extrude(height=width, center=true)
    polygon(points=[[0,0],[0,41/2],[headphone_offset,41/2],[headphone_offset,21/2]]);

    back(31/2)
    up((10+headphone_headband_width)/2+headphone_offset)
    cube([width,10,headphone_headband_width+10],center=true);

    back(31/2+10/2)
    up(10/2+headphone_headband_width+headphone_offset*2)
    xrot(180)
    yrot(-90)
    linear_extrude(height=width, center=true)
    polygon(points=[
        [0,0],
        [0,41/2],
        [headphone_offset,41/2],
        [headphone_offset*2,21/2],
        [headphone_offset*2,0]
    ], paths=[[for (i=[0:6]) i]]);
}