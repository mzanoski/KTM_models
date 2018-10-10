// TODO: documentation
// TODO: images and definitions
// TOOD: adjust values as per test prints

use <modules/washer.scad>
use <modules/quadriatic_bezier.scad>
use <modules/simple_gear.scad>

///////////////////////////// Module parameters /////////////////////////////
ADAPTER_Margin                          = 0.5;

// mid section cylinder - 'Rick' bar
BAR_Length                              = 175;
BAR_Diameter                            = 17;
BAR_InnerHoleDiameter                   = 9.7;
BAR_NumberOfTeeth                       = 20;
BAR_ToothDepth                          = 1;

// post adapter section
ADAPTER_WasherDiameter                  = 17.5;
ADAPTER_WasherHoleDiameter              = 5;
ADAPTER_WallThickness                   = 2;
ADAPTER_ConeLength                      = 40;
ADAPTER_EndDiameter                     = 11;

// post adapter - cylynder transition
ADAPTER_RickBarLength                   = 10;
ADAPTER_SmoothBarLength                 = 10;

//////////////////////// 'Private' Calculated Values ////////////////////////
// Rick bar section
prv_BarDiameter                 = BAR_Diameter;
prv_BarRadius                   = BAR_Diameter/2;
prv_BarInnerHoleDiameter        = BAR_InnerHoleDiameter+ADAPTER_Margin*2;
prv_BarInnerHoleRadius          = (BAR_InnerHoleDiameter/2)+ADAPTER_Margin;
prv_BarNumberOfTeeth            = BAR_NumberOfTeeth;
prv_BarToothDepth               = BAR_ToothDepth;
prv_BarMidSectionLength         = BAR_Length-2*ADAPTER_RickBarLength-2*ADAPTER_SmoothBarLength;

// post adapter section
prv_PostWallThickness           = ADAPTER_WallThickness;
prv_PostConeWasherSideRadius    = (ADAPTER_WasherDiameter+ADAPTER_Margin)/2;
prv_PostWasherOutterDiameter    = (prv_PostConeWasherSideRadius*2)+prv_PostWallThickness*2;
prv_PostWasherInnerDiameter     = ADAPTER_WasherHoleDiameter+ADAPTER_Margin;
prv_PostConeRiderSideRadius     = (ADAPTER_EndDiameter+ADAPTER_Margin)/2;
prv_PostConeRiderEndCapRadius   = prv_PostConeRiderSideRadius+prv_PostWallThickness+0.5;
prv_PostConeLength              = ADAPTER_ConeLength+ADAPTER_Margin;
prv_PostSmoothBarLength         = ADAPTER_SmoothBarLength;
prv_PostRickBarLength           = ADAPTER_RickBarLength;

// Z and Y axis are same for every bar section
prv_BarZAxisPosition                = prv_BarRadius-prv_PostConeLength;
prv_PostSmoothBarZAxisPosition      = prv_BarRadius-prv_PostConeLength;
prv_PostRickBarZAxisPosition        = prv_BarRadius-prv_PostConeLength;

prv_BarYAxisPosition                = -prv_PostWallThickness;
prv_PostSmoothBarYAxisPosition      = -prv_PostWallThickness;
prv_PostRickBarYAxisPosition        = -prv_PostWallThickness;
// X-axis is different for every bar section
prv_PostSmoothBarXAxisPosition      = prv_PostWasherOutterDiameter/2;
prv_PostRickBarXAxisPosition        = prv_PostSmoothBarXAxisPosition+(prv_PostRickBarLength/2)+prv_PostSmoothBarLength;
prv_BarXAxisPosition                = prv_PostRickBarXAxisPosition+(prv_PostRickBarLength/2)+prv_BarMidSectionLength/2;

prv_PostRightAdapterXPosition       = 2*prv_PostConeWasherSideRadius+2*prv_PostRickBarLength+2*prv_PostSmoothBarLength+prv_BarMidSectionLength+2*prv_PostWallThickness;

module screen_post_adapter(){
    union(){
        // ============ shape1: cone washer end ============
        translate([0,0,prv_PostConeLength+prv_PostWallThickness*2])
        rotate([0,90,0])
        washer(
            diameter_mm         = prv_PostWasherOutterDiameter,
            hole_diameter_mm    = prv_PostWasherInnerDiameter,
            thickness_mm        = prv_PostWallThickness,
            slice_angle         = [0,0,0]
        );

        // ============ shape2: cone body ============
        rotate([0,0,-135])
        color("yellow") bezier_cone(
            p0              = [prv_PostConeWasherSideRadius,prv_PostConeLength],
            p1              = [10,15],  // TODO: WARNING - this curve is not parametarized
            p2              = [prv_PostConeRiderSideRadius,0],
            w               = prv_PostWallThickness,
            fill_degrees    = 180
        );

        // ============ shape3: cone rider end cap ============
        translate([0,0,-0.5])
        cylinder(
            h   = prv_PostWallThickness, 
            r1  = prv_PostConeRiderEndCapRadius, 
            r2  = prv_PostConeRiderEndCapRadius
        );

        // ============ shape4: smooth cylinder section ============
        rotate([0,90,0])
        translate([prv_PostSmoothBarZAxisPosition,prv_PostSmoothBarYAxisPosition,prv_PostSmoothBarXAxisPosition])
        color("yellow") 
        difference(){
            cylinder(
                h   = prv_PostSmoothBarLength, 
                r1  = prv_BarRadius, 
                r2  = prv_BarRadius
            );
            translate([0,0,prv_PostWallThickness])
            cylinder(
                h   = prv_PostSmoothBarLength, 
                r1  = prv_BarInnerHoleRadius, 
                r2  = prv_BarInnerHoleRadius
            );
        };

        // ============ shape5: grooved cylinder section ============
        rotate([0,90,0])
        translate([prv_PostRickBarZAxisPosition,prv_PostRickBarYAxisPosition,prv_PostRickBarXAxisPosition])
        color("yellow") simple_gear(
            cyl_length_mm           = prv_PostRickBarLength,
            cyl_diameter_mm         = prv_BarDiameter,
            center_hole_diameter    = prv_BarInnerHoleDiameter,
            num_of_teeth            = prv_BarNumberOfTeeth,
            groove_depth_mm         = prv_BarToothDepth
        );
    };

    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // This section creates a cone that fills the inside of shape1 (cone body).  This is then used to
    // subtract the cylinder overvlow, (portion that went through the cone body), to create a fill shape  
    // that fills the space between shape1 and shape4.  

    // WARNING: Nothing about this section is parametarized and requries manual changes if any of the below
    //          module parameter values are changed:
    //          ADAPTER_WasherDiameter, ADAPTER_WasherHoleDiameter, ADAPTER_WallThickness, 
    //          ADAPTER_ConeLength,     ADAPTER_EndDiameter
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    difference(){
            // ============ shape6: cone fill ============
        rotate([0,90,0])
        translate([prv_PostSmoothBarZAxisPosition,prv_PostRickBarYAxisPosition,prv_PostSmoothBarXAxisPosition-(prv_PostWallThickness*3.5)])
        color("green") 
        cylinder(
            h   = prv_PostWallThickness*3.5, 
            r1  = prv_BarRadius, 
            r2  = prv_BarRadius
        );
        // ============ shape7: gap fill ============
        rotate([0,0,-135])
        color("red") bezier_cone(
            p0              = [prv_PostConeWasherSideRadius-6,prv_PostConeLength-4],
            p1              = [10-5.5,15],  // TODO: parametarize curve values
            p2              = [prv_PostConeRiderSideRadius-6,0],
            w               = prv_PostWallThickness+4,
            fill_degrees    = 360
        ); 
    };
}

module mid_bar(){
    // middle accessory attachment
    rotate([0,90,0])
    translate([prv_BarZAxisPosition,prv_BarYAxisPosition,prv_BarXAxisPosition]) 
    color("yellow")
    simple_gear(
        cyl_length_mm           = prv_BarMidSectionLength,
        cyl_diameter_mm         = prv_BarDiameter,
        center_hole_diameter    = prv_BarInnerHoleDiameter,
        num_of_teeth            = prv_BarNumberOfTeeth,
        groove_depth_mm         = prv_BarToothDepth
    );
}


// // left side
// screen_post_adapter();
// // right side
// translate([prv_PostRightAdapterXPosition+10,0,0])
// mirror()
// screen_post_adapter();

mid_bar();