include <BOSL2/std.scad>
// use -D on cli to render one part
// -D=top_leg
// -D=bottom_leg
// -D=top_ring
// -D=mid_ring_segment
// -D=bottom_ring
// empty for full-size preview
part="";

ball_radius = 215;

wall_thickness = 1;

strut_thickness = 10;
strut_connector_length = 10;
strut_repeat_x = 1;
strut_repeat_y = 2;
strut_count = 16;

_wall_thickness_angle = wall_thickness/ball_radius*180/PI;
_strut_connector_length_angle = strut_connector_length/ball_radius*180/PI;

strut_width = (strut_thickness - wall_thickness) * strut_repeat_x+wall_thickness;
strut_height = (strut_thickness - wall_thickness) * strut_repeat_y+wall_thickness;

neck_hole_radius = 110;

center_band_width = 50;
_center_band_angle = atan(center_band_width/ball_radius)/2;

_top_cutout_radius = strut_count*(strut_width+wall_thickness)/PI/2;
_top_ring_height_offset = sqrt(ball_radius^2-_top_cutout_radius^2);
_top_ring_height_angle = asin(_top_ring_height_offset/ball_radius);

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

hollow = true; // for resin prints
screw_holes = false; // for fdm prints

slop = 0.1; // slop for combining holes

rough_render = false;
explode = false;
explode_distance = 50;

$fa = $preview ? 1 : 1;
$fs = $preview ? 5 : 5;

module render_if_rendering() {
    // yeah this is stupid but OpenSCAD needs it to make repeats way faster while rendering
    if (!$preview)
        render()
        children();
    else
        children();
}

module strut_outer_2d() {
    render() {
        // top arc
        _arc_points = strut_width;
        _angle = atan(strut_width/2 / ball_radius);
        _step = _angle / _arc_points;
        points = [for (a=[-_angle : _step : _angle]) [sin(a)*ball_radius, cos(a)*ball_radius]];
        fwd(points[0][1] - strut_height/2)
        polygon(points);

        // outer perimiter
        difference() {
            rect([strut_width, strut_height], center=true);
            offset(delta=slop/2)
            rect([strut_width-wall_thickness*2, strut_height-wall_thickness*2], center=true);
        }

        // diagonal struts
        offset(delta=-slop/2)
        xcopies(spacing=strut_thickness-wall_thickness, n=strut_repeat_x)
        ycopies(spacing=strut_thickness-wall_thickness, n=strut_repeat_y) {
            zrot_copies([45, -45])
            rect([wall_thickness, strut_thickness * sqrt(2)], center=true, chamfer=wall_thickness/2);
        }
    }
}

module strut_inner_2d() {
    render()
    difference() {
        difference() {
            rect([strut_width-wall_thickness, strut_height-wall_thickness], center=true);

            offset(delta=slop)
            strut_outer_2d();
        }

        offset(delta=-wall_thickness)
        difference() {
            rect([strut_width-wall_thickness, strut_height-wall_thickness], center=true);
            strut_outer_2d();
        }
    }
}

module long_strut_arc_outer(sa, ea) {
    render_if_rendering()
    yrot(-sa)
    xrot(90)
    rotate_extrude(angle=ea-sa)
    right(ball_radius - strut_height/2)
    zrot(-90)
    strut_outer_2d();
}

module long_strut_arc_inner(sa, ea) {
    render_if_rendering()
    yrot(-sa)
    xrot(90)
    rotate_extrude(angle=ea-sa)
    right(ball_radius - strut_height/2)
    zrot(-90)
    strut_inner_2d();
}

module lat_strut_arc_outer(sa, ea, long_angle) {
    render_if_rendering()
    yrot(-sa)
    rotate_extrude(angle=ea-sa)
    zrot(long_angle)
    right(ball_radius - strut_height/2)
    zrot(-90)
    strut_outer_2d();
}

module lat_strut_arc_inner(sa, ea, long_angle) {
    render_if_rendering()
    yrot(-sa)
    rotate_extrude(angle=ea-sa)
    zrot(long_angle)
    right(ball_radius - strut_height/2)
    zrot(-90)
    strut_inner_2d();
}



module top_ring() {
    // numbers we need
    _ring_center_height = _top_ring_height_offset - strut_height*sin(_top_ring_height_angle)/2;
    _ring_center_radius = cos(_top_ring_height_angle)*(_ring_center_height);
    _circumscribed_outer_ring_center_radius = _ring_center_radius / cos(180/strut_count);
    _top_ring_connector_end_angle = _top_ring_height_angle - _strut_connector_length_angle;
    
    // the ring part
    up(_ring_center_height)
    zrot(180/strut_count)
    rotate_extrude($fn=strut_count)
    right(_circumscribed_outer_ring_center_radius - strut_width / 2)
    skew(sxy=cos(_top_ring_height_angle))
    strut_outer_2d();

    // legs that stick out
    
    zrot_copies(n=strut_count)
    long_strut_arc_inner(_top_ring_height_angle + _wall_thickness_angle, _top_ring_connector_end_angle);
}

module top_leg() {
    // hull()
    long_strut_arc_outer(_center_band_angle, _top_ring_height_angle);

    zrot(strut_width/ball_radius*90/PI) {
    // hull()
        lat_strut_arc_outer(0, 360/strut_count-strut_width/ball_radius*180/PI, _center_band_angle+_strut_connector_length_angle/2);
    // hull()
        lat_strut_arc_outer(0, 360/strut_count-strut_width/ball_radius*180/PI, (_top_ring_height_angle-(_center_band_angle+_strut_connector_length_angle/2))*1/3+_center_band_angle+_strut_connector_length_angle/2);
    // hull()
        lat_strut_arc_outer(0, 360/strut_count-strut_width/ball_radius*180/PI, (_top_ring_height_angle-(_center_band_angle+_strut_connector_length_angle/2))*2/3+_center_band_angle+_strut_connector_length_angle/2);
        // lat_strut_arc_outer(0, 360/strut_count-strut_width/ball_radius*180/PI, (_top_ring_height_angle-(_center_band_angle+_strut_connector_length_angle/2))*3/4+_center_band_angle+_strut_connector_length_angle/2);
    }
}

module mid_ring_segment() {
    zflip_copy()
    union() {
        zrot(-strut_width/ball_radius*90/PI)
        lat_strut_arc_outer(0, 360/strut_count, _center_band_angle-strut_width/ball_radius*90/PI);

        long_strut_arc_inner(_center_band_angle-_wall_thickness_angle, _center_band_angle+_strut_connector_length_angle);
    }
    
    
    long_strut_arc_outer(-_center_band_angle+strut_width/ball_radius*180/PI, _center_band_angle-strut_width/ball_radius*180/PI);
}

// color("cyan")
// strut_outer_2d();

// color("green")
// strut_inner_2d();

// hull()
union() {

if (part=="") {
    
    // top ring
    up(explode ? explode_distance*2 : 0)
    color("#66CC0099")
    // hull()
    top_ring();

    // middle sections
    color("#FFFF0055")
    zrot_copies(n=strut_count)
    render_if_rendering()
    mid_ring_segment();

    // top legs
    up(explode ? explode_distance : 0)
    color("#AACCFF55")
    zrot_copies(n=strut_count)
    render_if_rendering()
    top_leg();

} else if (part=="top_leg") {

    xrot(90)
    long_strut_arc_outer(_center_band_angle, _top_ring_height_angle);
    
} else if (part=="top_ring") {

    xrot(180)
    top_ring(_center_band_angle, _top_ring_height_angle);
    
} else if (part=="mid_ring_segment") {

    mid_ring_segment();
    
}
}