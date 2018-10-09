module simple_gear(
    cyl_length_mm           = 10,
    cyl_diameter_mm         = 20,
    center_hole_diameter    = 8,
    num_of_teeth            = 40,
    groove_depth_mm         = 1.5
){
    // -------------- Calculated Values -------------- \\
    center_hole_radius  = center_hole_diameter/2;
    star_teeth_num      = num_of_teeth*2;
    start_diameter      = cyl_diameter_mm/2;

    // this module is taken from openScad examples
    module star(num, radii, thickness) {
        function r(a) = (floor(a / 10) % 2) ? 10 : 8;
        linear_extrude(height = cyl_length_mm, center = true, twist = 0)
        polygon([for (i=[0:num-1], a=i*360/num, r=radii[i%len(radii)]) [ r*cos(a), r*sin(a) ]]);
    }

    difference(){
        star(star_teeth_num, [(start_diameter-groove_depth_mm),start_diameter], cyl_length_mm);
        cylinder(h=cyl_length_mm+0.1, r1=center_hole_radius, r2=center_hole_radius, center=true, $fn=100);
    };
}


// examples:
//-------------------------------------
// simple_gear();

// translate([30, 0, 0])
// simple_gear(
//     cyl_length_mm=15,
//     cyl_diameter_mm=18,
//     center_hole_diameter=2,
//     num_of_teeth=20,
//     groove_depth_mm=1
// );

