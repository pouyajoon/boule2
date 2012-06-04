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
#import "LevelOptions.h" 

@interface Level : NSObject{
    
    LevelOptions *options;
//    int ringSizeFromBoule;
//    int ringSizeFromBouleRandomDistribution;
//    int timeBetweenRing;
//    int timeBetweenRingRandomDistribution;
//    int ringLife;
    int levelNumber;
    int initRingSizeFromBoule;
    int initTimeBetweenRing;
    int initRingLife;
}

-(NSString*) getLevelNumber;
-(Level*)initWithOptions:(LevelOptions*)_options;
-(Ring*)getRingWithMinimumSize:(UIImageView *)boule canvasSize:(CGSize)canvasSize;
-(int)getRingTimer;
-(void) updateLevel;
-(int) getDifficultyPercentage;
-(void)reset;
@end
