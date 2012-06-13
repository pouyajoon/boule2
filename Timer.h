//
//  Timer.h
//  Boule2
//
//  Created by Pouya Mohtacham on 13/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#ifndef TIMER_H
#define TIMER_H


#import <UIKit/UIKit.h>
#import "config.h"
#import "GameController.h"

@interface Timer : NSObject{
    NSTimer *timer;
    int timerCount;
    BOOL timerIsEnabled;
    GameController* gameController;
}

-(id)init:(GameController *)gc;

- (void) resetTimer;
- (void) initTimer;
- (void) pauseTimer;
- (BOOL) startTimer;

@property (nonatomic) int timerCount;

@end

#endif