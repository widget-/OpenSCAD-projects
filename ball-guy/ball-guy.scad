include <BOSL2/std.scad>

thickness = 1.6;

ball_radius = 215;
neck_hole_radius = 110;

center_band_width = 50;
rear_button_radius = 30;
rear_button_band_width = 15;

eye_and_mouth_border = 6;

eye_width = 48;
eye_height = 72;
eye_separation = 130;

mouth_top_radius_x = 50;
mouth_top_radius_z = 60;
mouth_bottom_radius_x = 87.5;
mouth_bottom_radius_z = 140;
mouth_hole_spacing = 7;
mouth_hole_size = 4;

eye_to_crown = 80;
crown_radius = 580/2/PI;
crown_circumference_minor = 280;
crown_circumference_major = 310;


outer_segment_width = 8;
outer_segments = 24;

hollow = true; // for resin prints
screw_holes = false; // for fdm prints

slop = 0.2; // slop for combining holes

rough_render = false;
explode = false;
explode_distance = 50;

prerender = true;



_top_cutout_radius = outer_segments*outer_segment_width/6;
_top_ring_height_offset = sin(acos(_top_cutout_radius/ball_radius)) * ball_radius;
_bottom_ring_height_offset = -sin(acos((neck_hole_radius+outer_segment_width)/ball_radius)) * ball_radius;
_crown_attachment_length = _top_ring_height_offset + (mouth_bottom_radius_z+mouth_top_radius_z)/2 - eye_to_crown - thickness;


$fa = $preview ? 5 : rough_render ? 10 : 1;
$fs = $preview ? 5 : rough_render ? 10 : 1;

module cache() {
    if (prerender && $preview)
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
            tube(h=outer_segment_width-thickness*2+slop*2, ir=ball_radius-outer_segment_width+thickness-slop, or=ball_radius-thickness+slop, orient=LEFT, center=true);

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
            tube(h=outer_segment_width-thickness*2+slop*2, ir=ball_radius-outer_segment_width+thickness-slop, or=ball_radius-thickness+slop, orient=LEFT, center=true);
            cyl(h=ball_radius+10, r=neck_hole_radius+outer_segment_width, orient=UP, anchor=TOP);
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
            tube(h=outer_segment_width-thickness*2-slop*2, ir=ball_radius-outer_segment_width+thickness+slop, or=ball_radius-thickness-slop, orient=LEFT, center=true, anchor=TOP);
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
            cyl(h=outer_segment_width, r=neck_hole_radius+outer_segment_width, orient=UP, anchor=TOP);

            zrot_copies(n=outer_segments)
            if ($idx<outer_segments/2)
            bottom_half(z=_bottom_ring_height_offset+outer_segment_width*2)
            tube(h=outer_segment_width-thickness*2-slop*2, ir=ball_radius-outer_segment_width+thickness+slop, or=ball_radius-thickness-slop, orient=LEFT, center=true, anchor=TOP);
        }

        // center hole
        cyl(h=ball_radius*2, r=neck_hole_radius, anchor=TOP);
    }
}

module middle_ring() {
    cache()
    front_half()
    left_half(x=outer_segment_width/2-thickness)
    union() {
        intersection() {
            difference() {
                union() {
                    tube(h=center_band_width, or=ball_radius, ir=ball_radius-outer_segment_width, orient=UP, center=true);

                    difference() {
                        right(slop)
                        tube(h=outer_segment_width-thickness*2-slop*2, ir=ball_radius-outer_segment_width+thickness+slop, or=ball_radius-thickness-slop, orient=LEFT, center=true);
                        zflip_copy(offset=center_band_width/2+outer_segment_width)
                        cuboid([outer_segment_width, ball_radius*2, ball_radius], anchor=BOTTOM);
                    }
                }
                // cutout inner tube to make hollow
                intersection() {                
                    difference() {
                        tube(h=center_band_width-thickness*2+slop*2, or=ball_radius-thickness+slop, ir=ball_radius-outer_segment_width+thickness-slop, orient=UP, center=true);
                        
                        zrot(-360/outer_segments+asin(thickness*4/ball_radius))
                        right_half();
                    }
                    sphere(r=ball_radius-thickness+slop);
                }
                
                zrot(-360/outer_segments)
                right_half(x=outer_segment_width/2-thickness);
            }

            sphere(r=ball_radius);
        }
        
        intersection() {                
            difference() {
                tube(h=center_band_width-thickness*2-slop*2, or=ball_radius-thickness-slop, ir=ball_radius-outer_segment_width+thickness+slop, orient=UP, center=true);
                
                zrot(-360/outer_segments-asin(thickness*2/ball_radius))
                right_half();

                zrot(-360/outer_segments+asin(thickness*4/ball_radius))
                left_half();
            }
            sphere(r=ball_radius-thickness-slop);
        }
        
    }
}

module eyes() {
    module ball(r) {
        cache()
        front_half(y=-sin(acos((eye_width*3/2+eye_separation/2)/ball_radius))*ball_radius, s=ball_radius*8)
        left_half(s=ball_radius*8)
        sphere(r=r);
    }

    front_half() {
        union() {
            // base
            color("white")
            difference() {
                echo("front half", -sin(acos((eye_width*3/2+eye_separation/2)/ball_radius))*ball_radius);
                ball(r=ball_radius+thickness);
                ball(r=ball_radius);

                left(eye_width/2+eye_separation/2) {
                    zscale(eye_height/eye_width)
                    front_half(y=-sin(acos((eye_width*3/2+eye_separation/2)/ball_radius))*ball_radius+1, s=ball_radius*8)
                    tube(h=ball_radius*3, ir=eye_width, or=ball_radius*2, orient=BACK, center=true);
                }
            }
            
            // outer ring
            color("black")
            difference() {
                ball(r=ball_radius+thickness*2);
                ball(r=ball_radius+thickness);

                left(eye_width/2+eye_separation/2) {
                    zscale(eye_height/eye_width) {
                        front_half(y=-sin(acos((eye_width*3/2+eye_separation/2)/ball_radius))*ball_radius+1, s=ball_radius*8)
                        tube(h=ball_radius*3, ir=eye_width, or=ball_radius*2, orient=BACK, center=true);
                        
                        front_half(y=-sin(acos((eye_width*3/2+eye_separation/2)/ball_radius))*ball_radius+1, s=ball_radius*8)
                        cyl(h=ball_radius*3, r=eye_width-eye_and_mouth_border, orient=BACK);
                    }
                }
            }

            // inner
            color("black")
            difference() {
                ball(r=ball_radius+thickness*2);
                ball(r=ball_radius+thickness);

                left(eye_width/4+eye_separation/2) {
                    zscale(eye_height/eye_width) {
                        front_half(y=-sin(acos((eye_width*3/2+eye_separation/2)/ball_radius))*ball_radius+1, s=ball_radius*8)
                        tube(h=ball_radius*3, ir=eye_width*2/3, or=ball_radius*2, orient=BACK, center=true);
                        front_half(y=-sin(acos((eye_width*3/2+eye_separation/2)/ball_radius))*ball_radius+1, s=ball_radius*8)
                        cyl(h=ball_radius*3, r=eye_width/3, orient=BACK);
                    }
                }
            }
        }
    }
}

module mouth() {
    bottom_half()
    front_half()
    difference() {
        union() {
            // base
            color("red")
            difference() {
                sphere(r=ball_radius+thickness+.1); // +.1 gets around openscad bug for mixed up colors
                sphere(r=ball_radius);

                zscale(mouth_bottom_radius_z/mouth_bottom_radius_x)
                tube(h=ball_radius*3, ir=mouth_bottom_radius_x, or=ball_radius*2, orient=BACK, center=true);

                zscale(mouth_top_radius_z/mouth_top_radius_x)
                cyl(h=ball_radius*3, r=mouth_top_radius_x, orient=BACK);
                
                down(mouth_bottom_radius_z/2)
                xrot(90)
                grid2d(size=[mouth_bottom_radius_x*2, mouth_bottom_radius_z], spacing=mouth_hole_spacing, stagger=true)
                cyl(d=mouth_hole_size, h=ball_radius*2, anchor=BOTTOM);
            }

            // outline top
            color("black")
            difference() {
                sphere(r=ball_radius+thickness*2);
                sphere(r=ball_radius);

                zscale(mouth_bottom_radius_z/mouth_bottom_radius_x)
                tube(h=ball_radius*3, ir=mouth_bottom_radius_x, or=ball_radius*2, orient=BACK, center=true);

                zscale(mouth_bottom_radius_z/mouth_bottom_radius_x)
                cyl(h=ball_radius*3, r=mouth_bottom_radius_x-eye_and_mouth_border, orient=BACK);
            }

            // outline bottom
            color("black")
            difference() {
                sphere(r=ball_radius+thickness*2);
                sphere(r=ball_radius);

                zscale(mouth_top_radius_z/mouth_top_radius_x)
                tube(h=ball_radius*3, ir=mouth_top_radius_x+eye_and_mouth_border, or=ball_radius*2, orient=BACK, center=true);

                zscale(mouth_top_radius_z/mouth_top_radius_x)
                cyl(h=ball_radius*3, r=mouth_top_radius_x, orient=BACK);
            }

        }
        xflip_copy()
        left(eye_width/2+eye_separation/2) {
            zscale(eye_height/eye_width)
            cyl(h=ball_radius*3, r=eye_width, orient=BACK, center=true);
        }
    }
}

module head_approximation() {
    // zscale(760/560)
    yscale(crown_circumference_major/crown_circumference_minor)
    hull()
    zcopies((760-560)/2)
    spheroid(r=570/PI/2);
}


// bottom_half()
// back_half()
union() {
    // color("#FF990099")
    // down((mouth_bottom_radius_z+mouth_top_radius_z)/2)
    // #head_approximation();


    up(explode ? -explode_distance*2 : 0)
    // bottom ring connector
    color("#FF330099")
    bottom_ring();

    // bottom legs
    up(explode ? -explode_distance : 0)
    color("#FFAACC55")
    zrot_copies(n=outer_segments)
    bottom_leg();

    // center ring connector
    color("#FFFF0055")
    zrot_copies(n=outer_segments)
    middle_ring();

    // top legs
    up(explode ? explode_distance : 0)
    color("#AACCFF55")
    zrot_copies(n=outer_segments)
    top_leg();

    up(explode ? explode_distance*2 : 0)
    // top ring connector
    color("#FF990099")
    top_ring();

    // sphere(r=ball_radius);

    xflip_copy()
    eyes();

    mouth();

}
