include <BOSL2/std.scad>

thickness = 3;

ball_radius = 215;
neck_hole_radius = 110;

center_band_width = 50;
rear_button_radius = 30;
rear_button_band_width = 15;

eye_width = 60;
eye_height = 90;
eye_separation = 130;

outer_segment_width = 15;
outer_segments = 12;

hollow = true; // for resin prints
screw_holes = false; // for fdm prints

slop = 0.1; // slop for combining holes

rough_render = true;
explode = false;
explode_distance = 50;

prerender = true;



// _segment_inner_angle = (outer_segment_width/ball_radius) * (360/(2*PI));
_top_cutout_radius = outer_segments*outer_segment_width/6;
_top_ring_height_offset = sin(acos(_top_cutout_radius/ball_radius)) * ball_radius;
_bottom_ring_height_offset = -sin(acos(neck_hole_radius/ball_radius)) * ball_radius;


// $fa = $preview ? 5 : rough_render ? 10 : .5;
// $fs = $preview ? 5 : rough_render ? 10 : .5;
$fa = 5;
$fs = 5;

module cache() {
    if (prerender)
        render()
        children();
    else
        children();
}

module top_leg() {
    cache()
    intersection() {
        front_half()
        top_half(z=center_band_width/2)
        difference() {
            // vertical ring
            tube(h=outer_segment_width, ir=ball_radius-outer_segment_width, or=ball_radius, orient=LEFT, center=true);
            // inner cutout
            intersection() {
                tube(h=outer_segment_width-thickness*2, ir=ball_radius-outer_segment_width+thickness, or=ball_radius-thickness, orient=LEFT, center=true);

                union() {
                    cuboid([ball_radius*3, ball_radius*3, center_band_width/2+outer_segment_width+thickness], anchor=BOTTOM);
                    
                    cyl(h=ball_radius, r=_top_cutout_radius+outer_segment_width+thickness, anchor=BOTTOM);
                }
            }
            // top cutout
            cyl(h=ball_radius+10, r=_top_cutout_radius, orient=UP, anchor=BOTTOM, $fn=outer_segments, realign=true);

        }
        sphere(r=ball_radius);
    }
}

module bottom_leg() {
    cache()
    intersection() {
        front_half()
        bottom_half(z=-center_band_width/2)
        difference() {
            // vertical ring
            tube(h=outer_segment_width, ir=ball_radius-outer_segment_width, or=ball_radius, orient=LEFT, center=true);
            // inner cutout
            tube(h=outer_segment_width-thickness*2, ir=ball_radius-outer_segment_width+thickness, or=ball_radius-thickness, orient=LEFT, center=true);
            // bottom cutout (the sqrt(neck_hole_radius/6) accounts for outer round part of radius)
            cyl(h=ball_radius+10, r=neck_hole_radius+sqrt(neck_hole_radius/6), orient=UP, anchor=TOP, $fn=outer_segments, realign=true);
        }
        sphere(r=ball_radius);
    }
}

module top_ring() {
    cache()
    difference() {
        union() {
            up(_top_ring_height_offset)
            cyl(h=outer_segment_width, r=_top_cutout_radius, orient=UP, anchor=TOP, $fn=outer_segments, realign=true);

            zrot_copies(n=outer_segments)
            if ($idx<outer_segments/2)
            tube(h=outer_segment_width-thickness*2, ir=ball_radius-outer_segment_width+thickness, or=ball_radius-thickness, orient=LEFT, center=true, anchor=TOP);
        }
        // exclude bottom half
        cuboid(ball_radius*2, anchor=TOP);
        // limit length of connectors
        tube(h=ball_radius*2, ir=_top_cutout_radius+outer_segment_width, or=ball_radius);
        // center hole
        cyl(h=ball_radius*2, r=_top_cutout_radius-outer_segment_width, anchor=BOTTOM);
        // cutout inner tube to make hollow
        // up(_top_ring_height_offset - outer_segment_width/2)
        // tube(h=outer_segment_width-thickness*2, or=_top_cutout_radius-thickness, ir=_top_cutout_radius-outer_segment_width+thickness, orient=UP, center=true);
    }
}

module bottom_ring() {
    cache()
    bottom_half(s=ball_radius*3)
    top_half(z=_bottom_ring_height_offset)
    difference() {
        union() {
            up(_bottom_ring_height_offset+outer_segment_width)
            cyl(h=outer_segment_width, r=neck_hole_radius, orient=UP, anchor=TOP);

            zrot_copies(n=outer_segments)
            if ($idx<outer_segments/2)
            tube(h=outer_segment_width-thickness*2, ir=ball_radius-outer_segment_width+thickness, or=ball_radius-thickness, orient=LEFT, center=true, anchor=TOP);
        }
        // limit length of connectors
        tube(h=ball_radius*2, ir=neck_hole_radius+outer_segment_width, or=ball_radius, anchor=TOP);
        // center hole
        cyl(h=ball_radius*2, r=neck_hole_radius-outer_segment_width, anchor=TOP);
        // cutout inner tube to make hollow
        #up(_bottom_ring_height_offset + outer_segment_width/2)
        tube(h=outer_segment_width-thickness*2, or=neck_hole_radius-thickness, ir=neck_hole_radius-outer_segment_width+thickness, orient=UP, center=true);
    }
}

module middle_ring() {
    cache()
    intersection() {
        difference() {
            union() {
                tube(h=center_band_width, or=ball_radius, ir=ball_radius-outer_segment_width, orient=UP, center=true);

                zrot_copies(n=outer_segments)
                if ($idx<outer_segments/2)
                cache()
                difference() {
                    tube(h=outer_segment_width-thickness*2, ir=ball_radius-outer_segment_width+thickness, or=ball_radius-thickness, orient=LEFT, center=true);
                    zflip_copy(offset=center_band_width/2+outer_segment_width)
                    cuboid([outer_segment_width, ball_radius*2, ball_radius], anchor=BOTTOM);
                }
            }
            // cutout inner tube to make hollow
            tube(h=outer_segment_width-thickness*2, or=ball_radius-thickness, ir=ball_radius-outer_segment_width+thickness, orient=UP, center=true);
        }
        sphere(r=ball_radius);
    }
}


// bottom_half()
// back_half()
// union() {
    // up(explode ? -explode_distance*2 : 0)
    // // top ring connector
    // color("#FF330099")
    // bottom_ring();

    // // bottom vertical rings
    // up(explode ? -explode_distance : 0)
    // color("#FFAACC55")
    // zrot_copies(n=outer_segments)
    // bottom_leg();

    // center ring connector
    color("#FFFF0055")
    // zrot_copies(n=outer_segments)
    middle_ring();

    // // top vertical rings
    // up(explode ? explode_distance : 0)
    // color("#AACCFF55")
    // zrot_copies(n=outer_segments)
    // top_leg();

    // up(explode ? explode_distance*2 : 0)
    // // top ring connector
    // color("#FF990099")
    // top_ring();


// }
