//
//  Level.h
//  Boule2
//
//  Created by Pouya Mohtacham on 14/04/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "Ring.h"

@interface Level : NSObject{
    int ringSizeFromBoule;
    int ringSizeFromBouleRandomDistribution;
    int timeBetweenRing;
    int timeBetweenRingRandomDistribution;
}
-(Level*)initWithOptions:(int)_ringSizeFromBoule ringSizeFromBouleRandomDistribution:(int)_ringSizeFromBouleRandomDistribution timeBetweenRing:(int)_timeBetweenRing timeBetweenRingRandomDistribution:(int)_timeBetweenRingRandomDistribution;
-(Ring*)getRingWithMinimumSize:(CGSize)minimumSize canvasSize:(CGSize)canvasSize;
-(int)getRingTimer;
-(void) updateLevel;
@end
