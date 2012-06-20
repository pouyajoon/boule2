//
//  Notification.m
//  Boule2
//
//  Created by Pouya Mohtacham on 17/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "Notification.h"
#import "GameController.h"

@implementation Notification

-(id) initWithMessage:(NSString *)message withFrame:(CGRect)frame withGameController:(GameController *)gc{
    life = 200;
    lifeMax = 200;
    state = n_moving;
    BNotification = [UIButton buttonWithType:UIButtonTypeCustom];
    [BNotification setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [BNotification setTitle:message forState:UIControlStateNormal];
    BNotification.titleLabel.font = [config getFontNotification];
    BNotification.frame = frame;
    [BNotification addTarget:self 
               action:@selector(hasBeenClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [BNotification sizeToFit];
    gameController = gc;
    [gameController.view addSubview:BNotification];
    return self;
}



-(IBAction)hasBeenClicked:(id)sender{
    state = n_falling;

    int score = gameController.currentLevel.levelNumber * 10;
    //BNotification.frame.size.height
    CGPoint position = CGPointMake(BNotification.center.x, BNotification.center.y - 20);
    [gameController addScore:score withColor:[UIColor purpleColor] withPosition:position];

}


-(void) moving{
    BNotification.frame = CGRectMake(BNotification.frame.origin.x + 2.5, BNotification.frame.origin.y, BNotification.frame.size.width, BNotification.frame.size.height);
}

-(void)falling{
//    CGRect frame = BNotification.frame;    
//    BNotification.frame = CGRectMake(frame.origin.x + 1, frame.origin.y + 1, frame.size.width - 2, frame.size.height -2);
    
    
    CGFloat fontSize = BNotification.titleLabel.font.pointSize - 0.5;
    BNotification.titleLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:fontSize];

}

-(void)tick{
    switch (state) {
        case n_moving:
            [self moving];
            break;
        case n_falling:
            life -= 1;
            if (life < 0) {
                state = n_dead;
                break;
            }
            [self falling];
            break;
            
        default:
            break;
    }
}


@end
