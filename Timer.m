//
//  Timer.m
//  Boule2
//
//  Created by Pouya Mohtacham on 13/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "Timer.h"

@implementation Timer

@synthesize timerCount;


-(id)init:(GameController *)gc{
    gameController = gc;
    return self;
}

- (void) initTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_RING target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
    [self startTimer];
    [timer fire];
}

- (void) increaseTimerCount
{
    if (timerIsEnabled == NO) 
    {
        return;
    }
    [gameController tick];
    timerCount++;
}


-(void) resetTimer{
    timerCount = 0;
}

- (void) pauseTimer{
    timerIsEnabled = NO;
}

- (BOOL) startTimer{
    //if ([hero isDead]) return NO;
    timerIsEnabled = YES;
    return YES;
}


@end
