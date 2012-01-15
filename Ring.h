//
//  Ring.h
//  Boule2
//
//  Created by Aurelien Gasser on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ring : NSObject {
    CGRect frame;
    int lifeMax;
    int lifeCur;
    BOOL isDying;
    int dyingTime;
}

-(Ring*)initWithFrame:(CGRect)_frame life:(int)_life;
-(void)draw:(CGContextRef)context;
-(void)live;
-(BOOL)isAroundRect:(CGRect)boule;
-(void)die;
-(BOOL)isDead;
-(UIColor*)getColor;

@property (nonatomic) CGRect frame;
@property (nonatomic) int lifeMax;
@property (nonatomic) int lifeCur;
@property (nonatomic) BOOL isDying;

@end
