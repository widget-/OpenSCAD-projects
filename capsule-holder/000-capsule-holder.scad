
include <BOSL2/std.scad>

// include <BOSL/constants.scad>
// use <BOSL/transforms.scad>
// use <BOSL/shapes.scad>
// use <BOSL/masks.scad>

// use <C:\Users\Widget\AppData\Local\Microsoft\Windows\Fonts\RobotoMono-Bold.ttf>
// use <C:\Users\Widget\AppData\Local\Microsoft\Windows\Fonts\RobotoMono-Bold.ttf>

// /// 0 capsule size:
// size = "0";
// capsule_diameter = 7.35;
// // capsule_length = 18.35;
// capsule_length = 17.5;
// capsule_top_diameter = 7.64;
// capsule_top_length = 10.85;

// / 00 capsule size:
size = "00";
capsule_diameter = 8.16; // orig 8.56 - measured 8.32
capsule_length = 20.22; // measured 20.05
capsule_top_diameter = 8.56;
capsule_top_length = 11.80;

// /// 000 capsule size:
// size = "000";
// capsule_diameter = 9.55; // measured 9.44
// // capsule_length = 22.2; // measured 21.75
// capsule_length = 20; // measured 21.75
// capsule_top_diameter = 9.91;
// capsule_top_length = 12.95;

extra_neck_length = 8;
// extra_neck_length = 15;

radius = capsule_diameter*1.5;
funnel_height = 13;
thickness = 2;
cylinder_thickness = 3;
base_extra_radius = 7;


slop = 0.0;
font_size = radius - thickness*2 - len(size)+1;
// font = "Roboto Mono-Bold:style=Bold";
font = "Consolas:style=Bold";

popout_hole_radius = capsule_diameter/2.5;

// $fn = 200;
$fa = 3;
$fs = .3;


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

    // text
    down(thickness/2+funnel_height/4)
    xflip()
    linear_extrude(height=thickness, center=true, convexity=10) 
    xscale(.8)
    fwd(font_size/4)
    ydistribute(spacing=popout_hole_radius*2 + font_size*3/4) {
        text(str("(+",slop,")"), halign="center", valign="baseline", size=font_size/2, font=font);
        text(size, halign="center", valign="baseline", size=font_size, font=font);
    }

    // hole for stab stick
    cyl(r=popout_hole_radius+slop, h=10);

    // prevent suction on stab stick
    down(funnel_height/4+thickness/2)
    yrot(90)
    cyl(r=3/4, h=radius*2+thickness+funnel_height);

    // // very bottom should be slightly wider
    // down(thickness/2+funnel_height/4)
    // xflip()
    // linear_extrude(height=.2, center=true, convexity=10)
    // offset(r=.2)
    // xscale(.8)
    // ydistribute(spacing=font_size*1.25) {
    //     text(size, halign="center", valign="center", size=font_size, font=font);
    //     text(str("s",slop), halign="center", valign="center", size=font_size*2/3, font=font);
    // }
}

// upper half
difference() {
    union() {
        // center cylinder
        up(capsule_length/2 + extra_neck_length/2 + 5)
        cyl(r=capsule_diameter/2+cylinder_thickness+slop, h=capsule_length+extra_neck_length+10);

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
    difference() {
        cyl(r=capsule_diameter/2-slop+base_extra_radius, h=thickness, $fn=8);

        zflip_copy(thickness/2)
        fillet_cylinder_mask(capsule_diameter/2-slop+base_extra_radius-.25, thickness/2);
        
        down(thickness/2)
        linear_extrude(height=thickness, center=true, convexity=10) 
        xflip()
        xscale(.8)
        ydistribute(spacing=capsule_diameter/2*1.25) {
            text(str(capsule_diameter/2-slop, "mm"), halign="center", valign="center", size=(capsule_diameter/2), font=font);
            text(str("Size ",size), halign="center", valign="center", size=((capsule_diameter-1)/2), font=font);
        }
    }

    top_half()
    difference() {
        cyl(r=capsule_diameter/2-slop, h=capsule_length*2+extra_neck_length*2+funnel_height*2, fillet2=capsule_diameter/10);
      
        down(thickness)
        cyl(r=capsule_diameter/2-slop-thickness, h=capsule_length*2+extra_neck_length*2+funnel_height*2-thickness*3, chamfer=(capsule_diameter/2-slop-thickness));

        up(thickness/2+1.5)
        xrot(90)
        cyl(r=1.5, h=capsule_diameter*3);

        // up(capsule_length+extra_neck_length+funnel_height+capsule_diameter*1/3)
        // sphere(r=capsule_diameter*2/3-slop+.01);
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