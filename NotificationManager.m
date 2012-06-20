//
//  NotificationManager.m
//  Boule2
//
//  Created by Pouya Mohtacham on 17/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "NotificationManager.h"
#import "GameController.h"

@implementation NotificationManager


-(id)initWithGameController:(GameController*)gc{
    notifications = [[NSMutableArray alloc] init];
    gameController = gc;
    return self;
}

-(void) addNotification:(NSString*)title{
    int r = rand();    
    int y = GAME_VIEW_BORDER + fmod(r, (gameController.view.frame.size.height - GAME_VIEW_BORDER - 60));
    int x = -200;
    
    CGRect messageFrame = CGRectMake(x, y, 200, 60);
    Notification *n =[[Notification alloc] initWithMessage:title withFrame:messageFrame withGameController:gameController];
    [notifications addObject:n];
}

-(void)tick{
    for (int i = 0; i < notifications.count; i++) {
        Notification *n = [notifications objectAtIndex:i];
        [n tick];        
    }
}


@end
