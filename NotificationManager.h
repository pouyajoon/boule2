//
//  NotificationManager.h
//  Boule2
//
//  Created by Pouya Mohtacham on 17/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notification.h"
#import "config.h"

@class GameController;

@interface NotificationManager : NSObject{
    NSMutableArray *notifications;
    GameController *gameController;
}

-(id)initWithGameController:(GameController*)gc;
-(void)tick;
-(void) addNotification:(NSString*)message;

@end
