/* Quadratic Bezier Cone 
    Based on the quadriatic Bezier demo by Eric Buijs (http://homehack.nl/, https://www.youtube.com/channel/UCPwwPIXHMZYcVyJ2SuRJjuA)
    bezier demo: https://www.youtube.com/watch?v=jVPJetq0BZg
    demo soruce: https://www.youtube.com/redirect?redir_token=2Konxx7P-TQe_dO3BwFQCmHoktl8MTUzOTEzMTkzMkAxNTM5MDQ1NTMy&q=https%3A%2F%2Fdrive.google.com%2Fopen%3Fid%3D0Bwg0RBbuN0fMQktLd1pYYkkwWlk&v=jVPJetq0BZg&event=video_description
*/
module bezier_cone(
    radius          = 30,    //the radius determines the distance of the bottompoint
    //three points (p0,p1,p2) needed to create the quadratic bezier curve
    //four points (p0,p1,p2,p3) needed to create the cubic bezier curve
    p0              = [30,0],
    p1              = [120,90],
    p2              = [20,120],
    w               = 1,    //w determines the width of the line (thickness of the surface)
    deltat          = 0.05, //deltat determines the stepsize of the 'running variable' t. The smaller the step the smoother the curve
    fill_degrees    = 360,  //180 = half of a cone
    round_edges     = "false",
    control_points  = "false"
){
    function bezier(p0,p1,p2) = [for (t=[0:deltat:1]) pow(1-t,2)*p0+2*(1-t)*t*p1+pow(t,2)*p2];
        
    module line(p1,p2,w,round_edges="false") {
        hull() {
            if (round_edges=="true"){
                translate(p1) circle(r=w,$fn=20);
                translate(p2) circle(r=w,$fn=20);
            }
            else{
                translate(p1) square(w,$fn=20);
                translate(p2) square(w,$fn=20);
            }
        }
    }

    /*using the, slightly modified, poyline module from JustinSDK (thanks Justin Lin). See his documentation here: https://openhome.cc/eGossip/OpenSCAD/Polyline.html. It's good reading. */
    module polyline(points, index, w,round_edges="true") {
        if(index < len(points)) {
            line(points[index - 1], points[index],w, round_edges=round_edges);
            polyline(points, index + 1, w, round_edges=round_edges);
        }
    }

    module display_control_points() {
        translate(p0) color("red") circle(3);
        translate(p1) color("red") circle(3);
        translate(p2) color("red") circle(3);
        color("red") polyline([p0,p1,p2],1,1);
    }

    rotate_extrude(angle=fill_degrees)
    polyline(bezier(p0,p1,p2),1,w,round_edges=round_edges);

    if (control_points=="true"){
        display_control_points();
    }
}

// examples:
//-------------------------------------
// color("yellow") bezier_cone(
//     p0=[10,30],
//     p1=[10,15],
//     p2=[5,1],
//     w=1,
//     fill_degrees=150,
//     control_points="true"
// );

// translate([200,0,0])
// bezier_cone($fn=100);