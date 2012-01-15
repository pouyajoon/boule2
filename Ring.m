//
//  Ring.m
//  Boule2
//
//  Created by Aurelien Gasser on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ring.h"
#import "config.h"

@implementation Ring

@synthesize frame;
@synthesize lifeMax;
@synthesize lifeCur;
@synthesize isDying;

-(Ring*)initWithFrame:(CGRect)_frame life:(int)_life
{
    self.lifeMax = _life;
    self.lifeCur = _life;
    self.frame = _frame;
    dyingTime = RING_DIE_TIME;
    isDying = NO;
    return self;
}

-(BOOL)isAroundRect:(CGRect)boule
{
    float rayonBoule = 0.5 * boule.size.width;
    float rayonAnneau = 0.5 * frame.size.width;
    CGPoint centreBoule = CGPointMake(boule.origin.x + rayonBoule, boule.origin.y + rayonBoule);
    CGPoint centreAnneau = CGPointMake(frame.origin.x + rayonAnneau, frame.origin.y + rayonAnneau);
    float dx = centreBoule.x - centreAnneau.x;
    float dy = centreBoule.y - centreAnneau.y;
    float d = sqrt(dx * dx + dy * dy);
    BOOL res = d + rayonBoule < rayonAnneau - 0.5 * BOULE_THICKNESS;
    if (res){
        return res;
    }
    return res;
    
}


-(void)die
{
    dyingTime = RING_DIE_TIME;
    isDying = YES;
}

-(BOOL)isDead
{
    if (isDying && dyingTime <= 0){
        return YES;
    }
    return NO;
}

-(UIColor*)getColor
{
    float green = 1.0 * lifeCur / lifeMax;
    float red = 1.0 - green;
    float blue = 0;
    float alpha = 1.0;
    
    if (isDying)
    {
        alpha = dyingTime * 1.0 / RING_DIE_TIME;
        
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(void)draw:(CGContextRef)context;
{
    CGContextSetStrokeColorWithColor(context, [self getColor].CGColor);
    CGContextAddEllipseInRect(context, frame);
    CGContextStrokePath(context);
}

-(void)live
{
    if (lifeCur > 0) {
        --lifeCur;
    }
    if (isDying == NO && lifeCur == 0){
        [self die];
    }   
    if (isDying){
        --dyingTime;
    }

}

-(void) dealloc
{
}

@end
