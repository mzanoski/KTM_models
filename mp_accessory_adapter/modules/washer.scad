module washer(
    diameter_mm             = 10,
    hole_diameter_mm        = 4,
    thickness_mm            = 2,
    slice_angle             = [0,90,0]
){
    PLANE_RADIUS=diameter_mm/2;
    HOLE_RADIUS=hole_diameter_mm/2;
    MARGIN=0.001;
    multiplication_angle = slice_angle+ [0,90,0];

    module washer_plane(){
        rotate_extrude(angle = 360)
        translate([hole_diameter_mm/2, 0,0])
        square([diameter_mm/2-hole_diameter_mm/2,thickness_mm/100],center=false);
    }

    for(slice = [0 : thickness_mm*100])
        translate([slice/100,0,0])
        rotate(multiplication_angle)
        washer_plane();
}


// example:
//--------------------------------------------
// washer(
//     diameter_mm=25,
//     hole_diameter_mm=5,
//     thickness_mm=2,
//     slice_angle=[0,45,0]
// );

// translate([20,0,0])
// washer(
//     diameter_mm=10,
//     hole_diameter_mm=5,
//     thickness_mm=1,
//     slice_angle=[0,0,0]
// );