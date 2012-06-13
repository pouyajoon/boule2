//
//  AccelerometerManager.m
//  Boule2
//
//  Created by Pouya Mohtacham on 05/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "AccelerometerManager.h"
#import "GameController.h"

@implementation AccelerometerManager

@synthesize accelerometerCount; 

+(void) setAccelerometer:(UIViewController<UIAccelerometerDelegate> *)view{
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0/36.0];
    [[UIAccelerometer sharedAccelerometer] setDelegate:view];
}

-(id)init:(GameController *)gc{
    accelerometerCount = 0;
    gameController = gc;
    return self;
    
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    const float kFilteringFactor = 0.5;
    static float accelX = 0;
    static float accelY = 0;
    //static float accelZ = 0;
    
    accelX = (acceleration.x * kFilteringFactor) + (accelX * (1.0 - kFilteringFactor));
    accelY = (acceleration.y * kFilteringFactor) + (accelY * (1.0 - kFilteringFactor));
    //accelZ = (acceleration.z * kFilteringFactor) + (accelZ * (1.0 - kFilteringFactor));
    
    [self accelerometerTickWithX:accelX withAccelY:accelY withAcceleration:acceleration];
    
    accelerometerCount += 1;
}


-(void) accelerometerTickWithX:(float)accelX withAccelY:(float)accelY withAcceleration:(UIAcceleration*)acceleration{
    
    if (!gameController.BNotification.isHidden){
        gameController.notificationDirection = CGPointMake(accelX * 20, accelY * 20);
    }
    
    float x = accelX * gameController.hero.bouleMove + gameController.hero.image.frame.origin.x ;
    float y = -accelY * gameController.hero.bouleMove + gameController.hero.image.frame.origin.y;
    [gameController.hero checkBoulePositionIsCorrectAndMoveWithX:x withY:y];
    
    float angle = [GameController getAngleFromAcceleration:acceleration];
    
    if (accelerometerCount % 2 == 0){
        [gameController updateDynamicControlsAngle:angle];
    }
    if (accelerometerCount % 3 == 0){
        [gameController updateStaticControlsAngle:angle];        
    }
}



@end
