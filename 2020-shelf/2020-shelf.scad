include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
// use <BOSL/masks.scad>
// use <BOSL/metric_screws.scad>
include <../lib/2020.scad>

$fn=50;

platform_width = 70;
platform_depth = 70;
thickness = 15;

2020_width = 20.5;
2020_thickness = 5;

zrot(180)
2020_hug_front_hole(length=thickness, 2020_width=2020_width, thickness=2020_thickness);

left(2020_width/2+platform_width/2+1)
back(platform_depth/2-2020_thickness/2-2020_width/2)
cuboid([platform_width, platform_depth, thickness]);