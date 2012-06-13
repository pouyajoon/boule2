//
//  Ring.m
//  Boule2
//
//  Created by Pouya Mohtacham on 1/8/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "Ring.h"
#import "config.h"

@implementation Ring

@synthesize frame;
@synthesize lifeMax;
@synthesize lifeCur;
@synthesize ringState;

-(Ring*)initWithFrame:(CGRect)_frame life:(int)_life
{
    self.lifeMax = _life;
    self.lifeCur = _life;
    self.frame = _frame;
    destination = CGPointMake(0, 0);
    strokeThickness = RING_STROKE_THICKNESS;
    ringState = living;
    alpha = 1;
    redZoneSize = 0;
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
    BOOL res = d + rayonBoule < rayonAnneau - 0.5 * RING_STROKE_THICKNESS;
    if (res){
        return res;
    }
    return res;
}

-(void)setDestination:(CGPoint) targetDestination{
    destination = targetDestination;
    ringState = goingToLifeScore;
}


-(BOOL)isDead
{
    if (ringState == dead){
        return YES;
    }
    return NO;
}

-(UIColor*)getColor
{
    float green = 1.0 * lifeCur / lifeMax;
    float red = 1.0 - green;
    float blue = 0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(void)draw:(CGContextRef)context
{
    switch (ringState) {
        case dead:
            break;
        case redGrowing:
            CGContextSetLineWidth(context, 1);
            
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            CGContextAddEllipseInRect(context, frame);
            CGContextFillPath(context);    
            
            int greenZoneSize = GAME_LIFE_SIZE - redZoneSize / 2;
            CGRect greenRect = CGRectMake(frame.origin.x + greenZoneSize, frame.origin.y + greenZoneSize, frame.size.width - 2 * greenZoneSize, frame.size.height - 2 * greenZoneSize);
            CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            CGContextAddEllipseInRect(context, greenRect);
            CGContextFillPath(context);            
        case reduceRedToHide:
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            CGContextAddEllipseInRect(context, frame);
            CGContextFillPath(context);
            break;
        default:
            CGContextSetLineWidth(context, strokeThickness);  
            CGContextSetStrokeColorWithColor(context, [self getColor].CGColor);
            CGContextAddEllipseInRect(context, frame);
            CGContextStrokePath(context);
            break;
    }
    
    if (ringState == redGrowing){
        CGContextSetLineWidth(context, 1);
        
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        CGContextAddEllipseInRect(context, frame);
        CGContextFillPath(context);    
        
        int greenZoneSize = GAME_LIFE_SIZE - redZoneSize / 2;
        CGRect greenRect = CGRectMake(frame.origin.x + greenZoneSize, frame.origin.y + greenZoneSize, frame.size.width - 2 * greenZoneSize, frame.size.height - 2 * greenZoneSize);
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextAddEllipseInRect(context, greenRect);
        CGContextFillPath(context);
    }
}



-(CGPoint)getDistance:(CGPoint) sourcePoint targetPoint:(CGPoint)targetPoint{
    return CGPointMake(ABS(sourcePoint.x - targetPoint.x), ABS(sourcePoint.y - targetPoint.y));
}


-(BOOL)move{

    BOOL moved = NO;
        
    CGPoint dist = [self getDistance:frame.origin targetPoint:destination];
    
    if (dist.x <= GAME_RING_MOVE){
        frame.origin.x = destination.x;
    } else {
        float x = destination.x - self.frame.origin.x;

        if (x > 0){
            frame.origin.x += GAME_RING_MOVE;
        } else {
            frame.origin.x -= GAME_RING_MOVE;
        }
        moved = YES;
    }
    
    if (dist.y <= GAME_RING_MOVE){
        frame.origin.y = destination.y;
    } else {
        float y = destination.y - self.frame.origin.y;
        if (y > 0){
            frame.origin.y += GAME_RING_MOVE;
        } else {
            frame.origin.y -= GAME_RING_MOVE;
        }        
        moved = YES;
    }
    return moved;
}

-(BOOL)reduce{
    BOOL reduced = NO;
    
    if (ABS(frame.size.width - GAME_LIFE_SIZE) <= GAME_RING_REDUCE){
        frame.size.width = GAME_LIFE_SIZE;
    } else {
        if (frame.size.width > GAME_LIFE_SIZE){
            frame.size.width -= GAME_RING_REDUCE;
            reduced = YES;
        }    
    }
    if (ABS(frame.size.height - GAME_LIFE_SIZE) <= GAME_RING_REDUCE){
        frame.size.height = GAME_LIFE_SIZE;
    } else {
        
        if (frame.size.height > GAME_LIFE_SIZE){
            frame.size.height -= GAME_RING_REDUCE;
            reduced = YES;
        }
    }
    return reduced;
    
}

-(BOOL)reduceStrokeThickness{
    BOOL reduced = NO;
    if (strokeThickness > 1){
        strokeThickness--;
        reduced = YES;
    }
    return reduced;
}


-(void) reduceAlphaToDeath{
    alpha -= 0.1;
    if (alpha < 0){
        alpha = 0;
        ringState = dead;
    }
}


-(void)live {
    BOOL moved = NO;
    
    switch (ringState) {
        case alphaHidding:
            [self reduceAlphaToDeath];
            break;            
        case living :
            if (lifeCur > 0) {
                --lifeCur;
            } else {
                ringState = notCatched;
            }
            break;
        case goingToLifeScore :
            
            moved = [self move];
            BOOL reduced = [self reduce];
            BOOL strokeReduced = [self reduceStrokeThickness];
            if (!moved && !reduced && !strokeReduced){
                ringState = onLifeScore;
            }
            break;
        case onLifeScore :
            ringState = redGrowing;            
        case redGrowing:
            if (redZoneSize > GAME_LIFE_SIZE){
                ringState = reduceRedToHide;
            }
            redZoneSize += 1;
            break;
        case growToDie:
            if (frame.size.width >= BOULE_MAX_SIZE && frame.size.height >= BOULE_MAX_SIZE){
                ringState = dead;
                break;
            }            
            [self growRingSizeUsingFactor:15];
            break;
        case reduceRingToHide :
        case reduceRedToHide :
            if (frame.size.width <= 0 && frame.size.height <= 0){
                ringState = dead;
                break;
            }            
            [self reduceRingSizeUsingFactor:1];
            break;
        default:
            break;

    }
}

-(void) growRingSizeUsingFactor:(int)factor{
    frame.origin.x -= factor;
    frame.origin.y -= factor;
    frame.size.width += 2 * factor;
    frame.size.height += 2 * factor;
}

-(void) reduceRingSizeUsingFactor:(int)factor{
    frame.origin.x += factor;
    frame.origin.y += factor;
    frame.size.width -= 2 * factor;
    frame.size.height -= 2 * factor;
}

-(void) dealloc
{
    [super dealloc];
}

@end
