//
//  Ring.h
//  Boule2
//
//  Created by Aurelien Gasser on 1/8/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    living,
    notCatched,
    goingToLifeScore,
    onLifeScore,
    redGrowing,
    reduceRedToHide,
    reduceRingToHide,
    growToDie,
    falling,
    alphaHidding,
    dead
}EringState;

@interface Ring : NSObject {
    CGRect frame;
    int lifeMax;
    int lifeCur;
    CGPoint destination;
    float movingIterations;
    int strokeThickness;
    EringState ringState;
    float alpha;
    int redZoneSize;
}


-(Ring*)initWithFrame:(CGRect)_frame life:(int)_life;
-(void)draw:(CGContextRef)context;
-(void)live;
-(BOOL)isAroundRect:(CGRect)boule;
-(BOOL)isDead;
-(UIColor*)getColor;

-(void)setDestination:(CGPoint) targetDestination;

@property (nonatomic) CGRect frame;
@property (nonatomic) int lifeMax;
@property (nonatomic) int lifeCur;
@property (nonatomic) EringState ringState;

@end
