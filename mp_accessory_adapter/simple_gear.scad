// This module is a publicDomainGearV1.1.scad wrapper that makes it simple to size the gear based on outtermost diameter.
// It is less flexible and the groove_depth feature is a crappy hack
use <publicDomainGearV1.1.scad>

module simple_gear(
    cyl_length_mm           = 10,
    cyl_diameter_mm         = 20,
    center_hole_diameter    = 8,
    num_of_teeth            = 40,
    groove_depth_mm         = 1.5
){
    // -------------- Calculated Values -------------- \\
    pi=3.1415926;
    ACTUAL_DIAMETER     = cyl_diameter_mm-groove_depth_mm;
    CYL_CIRCUMFERENCE   = pi*cyl_diameter_mm;
    MM_PER_TOOTH        = (pi*cyl_diameter_mm)/(num_of_teeth+(0.64*pi));
    RADIUS              = ACTUAL_DIAMETER/2;
    HOLE_RADIUS         = center_hole_diameter/2;

    union(){
        gear(
            mm_per_tooth        = MM_PER_TOOTH, 
            number_of_teeth     = num_of_teeth, 
            thickness           = cyl_length_mm, 
            pressure_angle      = 28, 
            hole_diameter       = center_hole_diameter
        );
        difference(){
            cylinder(h=cyl_length_mm, r1=RADIUS, r2=RADIUS, center=true);
            cylinder(h=cyl_length_mm+0.01, r1=HOLE_RADIUS, r2=HOLE_RADIUS, center=true);
        };
    };
}

// examples:
//-------------------------------------
// simple_gear();

// translate([30, 0, 0])
// simple_gear(
//     cyl_length_mm=5,
//     cyl_diameter_mm=10,
//     center_hole_diameter=2,
//     num_of_teeth=15,
//     groove_depth_mm=5
// );

