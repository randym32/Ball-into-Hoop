//
//  AppController.m
//  Ball Shooter
//
//

#import "AppController.h"
#import <OpenGL/CGLMacro.h>

/// This is the players targeting system
extern double targetBallShooter(void);


static int Hits = 0;
static int Misses=0;

/// These are the variables that define the game
/// This is the position of the ball shooter, where the player will shoot from.
static double _ballShooter_x0=0.5;
/// This is the starting position of the hoop that the player will to shoot into.
static double _hoop_y=0.0;
/// This is the velocity of the ball that the player will to shoot.
static double _ballShooter_speed=1.5;
/// This is the gravity acceleration.
static const double _gravity = -9.8;


/// These are the variables that the player can see
/// This is the position of the ball shooter, where the player will shoot from.
double ballShooter_x0;
/// This is the starting position of the hoop that the player will to shoot into.
double hoop_y;
/// This is the velocity of the ball that the player will shoot.
double ballShooter_speed;
/// This is the gravity acceleration.
double gravity = -9.8;


/** This is used to copy the game play variables to something that the player can see.
    This is copied to prevent the player from cheating and changing the position of the ring or shooter.
 */
static void copyPlayerStateVariables()
{
    ballShooter_x0    = _ballShooter_x0;
    hoop_y            = _hoop_y;
    ballShooter_speed = _ballShooter_speed;
    gravity           = _gravity;
}

static double rand1(void)
{
    long r = random() & 0xffff;
    return ((double)r/((double)0x10000));
}

@implementation AppController
/** Close the application when the window is closed
 */
- (void) windowWillClose:(NSNotification*)notification
{
    [[NSApplication sharedApplication] terminate: self];
}


/** Play one round of the game
 */
- (void) playRound: (id) ignore
{
    [visView stopRendering];

    // Set up the ring
    _hoop_y = 0.2+0.8*rand1();
    // Set up the ball shooter
    _ballShooter_x0 = rand1()/2.0;

    _ballShooter_speed=8.0;//+2.0*rand1();
    
    // Set up the variables
    copyPlayerStateVariables();
    // Call the player's targeting prcedure
    double angle=targetBallShooter();
    // Duplicate the variables to prevent player cheating
    copyPlayerStateVariables();
    
    // Limit the angle
    if (angle < 0.0) angle = 0.0;
    if (angle > 90.0) angle = 90.0;
    // Convert to radian
    angle *= 2*M_PI/360.0;
    
    // Calculate the flight
    double vx = _ballShooter_speed * cos(angle);
    // compute how far it will fly
    double distance = 1.0-_ballShooter_x0;
    // compute how long the ball will fly
    double duration = distance/vx;

    // Compute the height at that time
    double vy = _ballShooter_speed * sin(angle);
    double height = vy*duration+_gravity*duration*duration/2.0;

    // compute how much we are off
    double gap = height- _hoop_y;
    gap *= gap;
    // We allow some more generousity here
    int hit = gap < 0.0005 ? 1 : 0;
    if (hit)
    {
        Hits++;
    }
    else
    {
        Misses++;
    }

    [visView setValue: [NSNumber numberWithInt: hit]
          forInputKey: @"Hit"];
    [visView setValue: [NSNumber numberWithInt: Hits]
          forInputKey: @"Hits"];
    [visView setValue: [NSNumber numberWithInt: Misses]
          forInputKey: @"Misses"];
    [visView setValue: [NSNumber numberWithDouble: _ballShooter_x0]
          forInputKey: @"ballShooter_x"];
    [visView setValue: [NSNumber numberWithDouble: _hoop_y]
          forInputKey: @"hoop_y"];
    [visView setValue: [NSNumber numberWithDouble: vx]
          forInputKey: @"ball_v_x"];
    [visView setValue: [NSNumber numberWithDouble: vy]
          forInputKey: @"ball_v_y"];
    [visView setValue: [NSNumber numberWithDouble: duration]
          forInputKey: @"Duration"];
	[visView startRendering];
}
    
- (void) applicationWillFinishLaunching:(NSNotification*)notification
{
    // Load the graphics part of the system
    [visView loadCompositionFromFile:
         [[NSBundle mainBundle] pathForResource:@"Ball into Hoop"
                                         ofType:@"qtz"]];
    [visView setMaxRenderingFrameRate:0.0];
        
    // Create a timer to make automatic attempts to play the game
    timer = [NSTimer timerWithTimeInterval: 6.0
                                     target: self
                                   selector: @selector(playRound:)
                                   userInfo: nil
                                    repeats: true];
    [[NSRunLoop currentRunLoop] addTimer:timer
                                 forMode:NSDefaultRunLoopMode];
    
    // hide the cursor
    //CGDisplayHideCursor (kCGDirectMainDisplay);
    [self playRound:self];
}
    

@end
