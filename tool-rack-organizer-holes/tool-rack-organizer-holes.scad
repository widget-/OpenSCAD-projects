/**
 * tools-rack-organizer-holes
 * Copyright 2020 Widget <https://github.com/widget->
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


// This project requires BOSL installed in the OpenSCAD libraries folder.
//
// See https://github.com/revarbat/BOSL for download and installation instructions

include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>

top_width = 14.8;
bottom_width = 12;
mount_depth = 7;
top_depth = 1.25;
fillet = 1; // since many printers will blob corners slightly

slop = 0.3;

// hole_size = 1.5 + slop; // m1.5
// hole_size = 2 + slop; // m2
hole_size = 3 + slop; // m3
// hole_size = 4 + slop; // m4
// hole_size = 5 + slop; // m5
// hole_size = 6 + slop; // m6
// hole_size = 8 + slop; // m8
// hole_size = 10 + slop; // m10
// hole_size = 12 + slop; // m12

length = 15; // past the bottom of the mount

tube_thickness = 1.2;


$fa = 1;
$fs = 0.3;


difference() {
    union() {
        // main inner part of the mount
        cuboid([bottom_width, bottom_width, mount_depth], align=ALIGN_NEG, fillet=fillet, edges=EDGES_Z_ALL);

        // thinner wider part that sits on top
        down(mount_depth)
        cuboid([top_width, top_width, top_depth], align=ALIGN_POS, fillet=fillet, edges=EDGES_Z_ALL);

        // outer ring of cylinder
        cyl(r=hole_size/2+tube_thickness, h=length, align=ALIGN_POS);
    }

    // inner hole for cylinder
    cyl(r=hole_size/2, h=(length+mount_depth)*2);

    // shave off extra tubing in case it's bigger than the hole, like for m10
    up(length/2)
    zrot_copies(r=50/2+bottom_width/2, n=4)
    cuboid([50, 50, length+1]);
}