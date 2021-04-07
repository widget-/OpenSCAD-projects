
include <BOSL2/std.scad>

// include <BOSL/constants.scad>
// use <BOSL/transforms.scad>
// use <BOSL/shapes.scad>
// use <BOSL/masks.scad>

// !!! include fonts here by referencing their TTF files directly !!!
// (good luck on figuring out what OpenSCAD wants their name to be.
// check the Help > Font List dialog once you've loaded this with the
// TTF file referenced.)
// use <C:\Users\Widget\AppData\Local\Microsoft\Windows\Fonts\iosevka-type-slab-regular.ttf>
use <C:\Users\Widget\AppData\Local\Microsoft\Windows\Fonts\RobotoMono-VariableFont_wght.ttf>

/// 0 capsule size:
size = "0";
capsule_diameter = 7.35;
// capsule_length = 18.35;
capsule_length = 17.5;
capsule_top_diameter = 7.64;
capsule_top_length = 10.85;
slop = 0.085;

// // / 00 capsule size:
// size = "00";
// capsule_diameter = 8.26; // orig 8.56 - measured 8.32
// capsule_length = 20.22; // measured 20.05
// capsule_top_diameter = 8.56;
// capsule_top_length = 11.80;
// slop = 0.1;

// /// 000 capsule size:
// size = "000";
// capsule_diameter = 9.55; // measured 9.44
// // capsule_length = 22.2; // measured 21.75
// capsule_length = 20; // measured 21.75
// capsule_top_diameter = 9.91;
// capsule_top_length = 12.95;
// slop = 0.02;

extra_neck_length = 8;
// extra_neck_length = 15;

radius = capsule_diameter*1.5;
funnel_height = 13;
thickness = 2;
cylinder_thickness = 3;
base_extra_radius = 7;


font_size = radius - thickness*2 - len(size)+1;
// monospace fonts work best:
font = "Roboto Mono:style=Medium";
font_scale_mult = .4;
// font = "Iosevka Type Slab-Regular:style=Regular";
// font_scale_mult = .4;
// font = "Consolas:style=Bold";
// font_scale_mult = .45; // depends on width of characters
// font = "Liberation Mono:style=Bold";
// font_scale_mult = .4; // depends on width of characters
// font = "Liberation Mono:style=Bold";
// font_scale_mult = .4; // depends on width of characters

popout_hole_radius = capsule_diameter/2.5;
smush_stick_radius = capsule_diameter/2-slop-.5;

// $fn = 200;
$fa = 3;
$fs = .2;


// lower base surrounding funnel
up(funnel_height/4 - .005)
difference() {
    down(thickness/2)
    cyl(r1=radius+thickness/2+slop, r2=radius+thickness+funnel_height/2+slop, h=funnel_height/2-.01);

    down(thickness/2)
    difference() {
        cyl(r1=radius+slop, r2=radius+funnel_height/2+slop, h=funnel_height/2);
        down(funnel_height/4-thickness/2)
        cyl(r1=radius+slop, r2=radius+thickness+slop, h=thickness);
    }

    // small cutout for resin print suction avoidance
    down(funnel_height/4)
    back(radius+thickness+1)
    xrot(45)
    cyl(r=1, h=thickness*4);



    // // text
    // _text_max_height = (base_extra_radius)*2*font_scale_mult;

    // _capsule_size_string = str(size);
    // _capsule_size_text_size = min(_text_max_height, 100);

    // _mm_size_string = str(capsule_diameter/2-slop, "mm");
    // _mm_text_size = min(_text_max_height, (_text_max_height*3/len(_mm_size_string)));

    // down(funnel_height/4-thickness/2)
    // linear_extrude(height=thickness, center=true, convexity=10) 
    // ydistribute(spacing=(base_extra_radius - thickness)*4) {
    //     text(_mm_size_string, halign="center", valign="center", size=_mm_text_size, font=font);
    //     text(_capsule_size_string, halign="center", valign="center", size=_capsule_size_text_size, font=font);
    // }

    // hole for stab stick
    cyl(r=popout_hole_radius+slop, h=10);

    // prevent suction on stab stick
    down(funnel_height/4+thickness/2)
    yrot(90)
    cyl(r=3/4, h=radius*2+thickness+funnel_height);
}

// upper half
difference() {
    union() {
        // center cylinder
        difference() {
            up(capsule_length/2 + extra_neck_length/2 + 5)
            cyl(r=capsule_diameter/2+cylinder_thickness+slop, h=capsule_length+extra_neck_length+10);

            // text
            _text_max_height = (base_extra_radius)*2*font_scale_mult;
            _outer_radius = capsule_diameter/2+cylinder_thickness+slop;

            _capsule_size_string = str(size);
            _capsule_size_text_size = min(_text_max_height, 100);

            _mm_size_string = str(capsule_diameter+slop*2, "mm");
            _mm_text_size = min(_text_max_height, (_text_max_height*3/len(_mm_size_string)));

            up(capsule_length/2+thickness/2)
            zrot(90) {
                render() // first render is slow but then it should be cached
                right(_outer_radius-.499)
                skew(szx=1/2) // make the text a bit slanty to prevent completely flat overhangs
                yrot(90)
                linear_extrude(height=1, center=true)
                text(_capsule_size_string, halign="center", valign="center", size=_capsule_size_text_size, font=font);

                render() // first render is slow but then it should be cached
                zrot(180)
                right(_outer_radius)
                skew(szx=1/2) // make the text a bit slanty to prevent completely flat overhangs
                yrot(90)
                linear_extrude(height=1, center=true)
                text(_mm_size_string, halign="center", valign="center", size=_mm_text_size, font=font);
            }
        }

        // top funnel
        up(capsule_length + funnel_height/2 + extra_neck_length - .005)
        cyl(r1=capsule_diameter/2+thickness+slop, r2=capsule_diameter/2+thickness+funnel_height+slop, h=funnel_height-.01);
    }

    // cutouts for center cylinder
    up(capsule_length/2) {
        // center cutout
        up(thickness*3/2+extra_neck_length/2)
        cyl(r=capsule_diameter/2+slop, h=capsule_length+thickness*2+extra_neck_length, rounding=capsule_diameter/2);

        // side cutouts for removal
        xcopies(l=capsule_diameter*2+thickness*4, n=2)
        up(thickness/2)
        cyl(r=capsule_diameter+thickness+slop, h=capsule_length, chamfer=(capsule_diameter)/2);
    }
    
    // funnel negative
    up(capsule_length + funnel_height/2 + extra_neck_length - .005) {
        // up(thickness/2)
        cyl(r1=capsule_diameter/2+slop, r2=capsule_diameter/2+funnel_height+slop, h=funnel_height);
        cyl(r=capsule_diameter/2+slop, h=funnel_height+.01);
    }

    // cap slot
    up(capsule_length + extra_neck_length - .005 + capsule_diameter/2)
    cyl(r=capsule_top_diameter/2+slop, h=capsule_top_length);
    
    // hole for stab stick
    cyl(r=popout_hole_radius, h=10);
}

// smushy stick

*right(0) {
    hex_base_radius = capsule_diameter/2-slop+base_extra_radius;

    // hexagonal base
    cyl(r=capsule_diameter/2-slop+base_extra_radius, h=thickness, chamfer=thickness/3, circum=true, $fn=6);

    // extra slope to help the strength a bit
    cyl(r=smush_stick_radius+thickness*sqrt(3)/2 /*???*/, h=thickness, anchor=BOTTOM, chamfer2=thickness, chamfang=60, circum=true, $fn=6);


    difference() {
        _height = capsule_length+extra_neck_length+funnel_height;
        _hex_height = _height * 3/8;
        _radius = smush_stick_radius;
        union() {
            cyl(r=_radius, h=_height, anchor=BOTTOM, rounding2=capsule_diameter/10);
            cyl(r=_radius, h=_height*3/8, anchor=BOTTOM, chamfer2=1, chamfang=25, circum=true, $fn=6);
        }

        
        // labels
        up(_hex_height/2)
        zrot(180/6) {
            _capsule_size_string = str(size);
            _capsule_size_text_size = min(2*_hex_height*font_scale_mult/max(len(_capsule_size_string),2), _radius-.5);

            render() // first render is slow but then it should be cached
            right(_radius)
            skew(szx=1/2) // make the text a bit slanty to prevent completely flat overhangs
            yrot(90)
            linear_extrude(height=1, center=true)
            text(_capsule_size_string, halign="center", valign="center", size=_capsule_size_text_size, font=font);


            _mm_size_string = str(smush_stick_radius*2, "mm");
            _mm_text_size = min(2*_hex_height*font_scale_mult/max(len(_mm_size_string),2), _radius-.5);
            
            render() // first render is slow but then it should be cached
            zrot(180)
            right(_radius)
            skew(szx=1/2) // make the text a bit slanty to prevent completely flat overhangs
            yrot(90)
            linear_extrude(height=1, center=true)
            text(_mm_size_string, halign="center", valign="center", size=_mm_text_size, font=font);
        }


      
        // down(thickness)
        // cyl(r=capsule_diameter/2-slop-thickness, h=capsule_length*2+extra_neck_length*2+funnel_height*2-thickness*3, chamfer=(capsule_diameter/2-slop-thickness));

        // up(thickness/2+1.5)
        // xrot(90)
        // cyl(r=1.5, h=capsule_diameter*3);
    }
}


// popout stab stick

*left(0) {
    difference() {
        cyl(r=capsule_diameter/2-slop+base_extra_radius, h=thickness, $fn=8);

        zflip_copy(thickness/2)
        fillet_cylinder_mask(capsule_diameter/2-slop+base_extra_radius-.25, thickness/2);
        
        down(thickness/2)
        linear_extrude(height=thickness, center=true, convexity=10) 
        xflip()
        xscale(.8)
        ydistribute(spacing=capsule_diameter/2*1.25) {
            text("Popout", halign="center", valign="center", size=((capsule_diameter-1)/2), font=font);
            text(str(size), halign="center", valign="center", size=(capsule_diameter/2), font=font);
        }
    }

    top_half()
    difference() {
        cyl(r=popout_hole_radius-slop, h=capsule_length*2+extra_neck_length*2+funnel_height*2, fillet2=capsule_diameter/10);
      
        // down(thickness)
        // cyl(r=capsule_diameter/2-slop-thickness, h=capsule_length*2+extra_neck_length*2+funnel_height*2-thickness*3, chamfer=(capsule_diameter/2-slop-thickness));

        // up(thickness/2+1.5)
        // xrot(90)
        // cyl(r=1.5, h=capsule_diameter*3);

        up(capsule_length+extra_neck_length+funnel_height+capsule_diameter*1/3)
        sphere(r=capsule_diameter/2);
    }
}

// capsule cap (lid? (the top part)) holder
*difference() {
    _total_height = capsule_length+funnel_height*1.5;
    _outer_radius = capsule_top_diameter/2+thickness+slop;

    union() {
        cyl(r=_outer_radius, h=_total_height, anchor=DOWN, chamfer1=thickness/2, chamfang=25);

        cyl(r=_outer_radius, h=_total_height/2, anchor=DOWN, circum=true, chamfer=thickness/2, chamfang=25, $fn=6);
    }

    up(_total_height)
    cyl(r=capsule_top_diameter/2+slop, h=capsule_top_length*3/2, rounding=capsule_top_diameter/2+slop/2);

    // air channel to prevent succ while printing on a resin printer
    up((_total_height)/2) {
        cyl(r=1, h=(_total_height)/2, anchor=DOWN);

        yflip_copy()
        skew(syz=1/2) // syz = "slope of y/z along the y-z plane" instead of angle for some reason
        cyl(r=1, h=_total_height/2, anchor=UP);
    }

    // labels on the sides this time:
    up(_total_height/4)
    zrot(180/6) {
        _capsule_size_string = str(size);
        _capsule_size_text_size = (_total_height*font_scale_mult/max(len(_capsule_size_string),2.5));

        render() // first render is slow but then it should be cached
        right(_outer_radius)
        skew(szx=1/2) // make the text a bit slanty to prevent completely flat overhangs
        yrot(90)
        linear_extrude(height=1, center=true)
        text(_capsule_size_string, halign="center", valign="center", size=_capsule_size_text_size, font=font);


        _mm_size_string = str(capsule_diameter/2-slop, "mm");
        _mm_text_size = (_total_height*font_scale_mult/len(_mm_size_string));
        render() // first render is slow but then it should be cached
        zrot(180)
        right(_outer_radius)
        skew(szx=1/2) // make the text a bit slanty to prevent completely flat overhangs
        yrot(90)
        linear_extrude(height=1, center=true)
        text(_mm_size_string, halign="center", valign="center", size=_mm_text_size, font=font);

    }
}
