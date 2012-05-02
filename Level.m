//
//  Level.m
//  Boule2
//
//  Created by Pouya Mohtacham on 14/04/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "Level.h"


@implementation Level

-(Level*)initWithOptions:(int)_ringSizeFromBoule ringSizeFromBouleRandomDistribution:(int)_ringSizeFromBouleRandomDistribution timeBetweenRing:(int)_timeBetweenRing timeBetweenRingRandomDistribution:(int)_timeBetweenRingRandomDistribution{
    ringSizeFromBoule = _ringSizeFromBoule;
    ringSizeFromBouleRandomDistribution = _ringSizeFromBouleRandomDistribution;
    timeBetweenRing = _timeBetweenRing;
    timeBetweenRingRandomDistribution = _timeBetweenRingRandomDistribution;
    
    return self;
}

-(void) updateLevel{
    ringSizeFromBoule -= 2;
    ringSizeFromBouleRandomDistribution -= 1;
    timeBetweenRing -= 2;
    timeBetweenRingRandomDistribution -= 1;
    if (ringSizeFromBoule < 0){
        ringSizeFromBoule = 0;
    }
    if (ringSizeFromBouleRandomDistribution < 0){
        ringSizeFromBouleRandomDistribution = 0;
    }
    if (timeBetweenRing < 0){
        timeBetweenRing = 0;
    }

    if (timeBetweenRingRandomDistribution < 0){
        timeBetweenRingRandomDistribution = 0;
    }
}

-(Ring*)getRingWithMinimumSize:(CGSize)minimumSize canvasSize:(CGSize)canvasSize {
    int bw = minimumSize.width;
    int bh = minimumSize.height;

    int w =  bw + RING_STROKE_THICKNESS / 2 + ringSizeFromBoule;
    int h =  bh + RING_STROKE_THICKNESS / 2 + ringSizeFromBoule;
    if (ringSizeFromBouleRandomDistribution > 0){
        long r = random();
        w += r % ringSizeFromBouleRandomDistribution;
        h += r % ringSizeFromBouleRandomDistribution;
    }
    
    int _life = timeBetweenRing;
    if (timeBetweenRingRandomDistribution > 0){
        _life += random() % timeBetweenRingRandomDistribution;
    }
        
    float x = fmod(random(), canvasSize.width - w);
    float y = fmod(random(), canvasSize.height - h);
    return [[Ring alloc] initWithFrame:CGRectMake(x, y, w, h) life:_life];
}

-(int)getRingTimer{
    int r = timeBetweenRing;
    if (timeBetweenRingRandomDistribution > 0){
        r += rand() % timeBetweenRingRandomDistribution + 1;
    }
    return r;
}
@end
