//
//  BallTargeting.c
//  Shoot Ball into Ring
//
//  Created by Randall Maas on 1/21/14.
//
//

/** This is the only file that you are allowed to modify*/

#include <stdio.h>
#include <math.h>

/// This is the position of the artillery, where you will shoot from.
/// You can not modify it.
extern const double ballShooter_x0;
/// This is the height of the hoop that you are to shoot into
/// You can not modify it.
extern const double hoop_y;
/// This is the speed that the ball shooter shoots the ball
/// You can not modify it.
extern const double ballShooter_speed;
/// This is the gravity acceleration.
/// You can not modify it.
extern const double gravity;


/** This is the procedure that you customize to shoot the ball.
    Your objective is to compute angle to shoot the ball.
    @return The angle to shoot with. 0..90
 */
double targetBallShooter()
{
    // choose the ball shooter angle
    // This is a dumb choice
    return 45.0;
}