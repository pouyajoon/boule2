//
//  Notification.h
//  Boule2
//
//  Created by Pouya Mohtacham on 17/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameController;

typedef enum
{
    n_moving,
    n_falling,
    n_dead
}ENotificationState;


@interface Notification : NSObject{
    int life;
    int lifeMax;
    ENotificationState state;
    UIButton *BNotification;
    GameController *gameController;
}


-(id) initWithMessage:(NSString *)message withFrame:(CGRect)frame withGameController:(GameController *)gc;
-(IBAction)hasBeenClicked:(id)sender;
-(void)tick;

@end
