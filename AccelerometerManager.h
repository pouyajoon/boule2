//
//  AccelerometerManager.h
//  Boule2
//
//  Created by Pouya Mohtacham on 05/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameController;

@interface AccelerometerManager : NSObject <UIAccelerometerDelegate>{
    int accelerometerCount;
    GameController *gameController;
}

+(void) setAccelerometer:(UIViewController<UIAccelerometerDelegate> *)view;
-(id)init:(GameController *)gc;
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;

@property  (nonatomic) int accelerometerCount;

@end
