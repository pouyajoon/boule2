//
//  Level.m
//  Boule2
//
//  Created by Pouya Mohtacham on 14/04/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "Level.h"
#import "GameController.h"

@implementation Level

@synthesize levelNumber;

-(Level*)initWithOptions:(LevelOptions*)_options{
    
    options = _options;
    levelNumber = 0;
    initRingSizeFromBoule = options.ringSizeFromBoule;
    initTimeBetweenRing = options.timeBetweenRing;
    initRingLife = options.ringLife;
    return self;
}

-(int) getDifficultyPercentage{
    float ringSizeFromBouleD = (options.ringSizeFromBoule / (float)initRingSizeFromBoule) * 100;
    float timeBetweenRingD = (options.timeBetweenRing / (float)initTimeBetweenRing) * 100;
    float ringLifeD = (options.ringLife / (float)initRingLife) * 100;
    float res = (ringLifeD + ringSizeFromBouleD + timeBetweenRingD) / 3;
    //NSLog(@" %d(%f),%d(%f),%d(%f)", options.ringSizeFromBoule, ringSizeFromBouleD,options.ringLife, ringLifeD, options.timeBetweenRing, timeBetweenRingD);
    return 100 - floor(res);
}

-(void)reset{
    options.ringLife = initRingLife;
    options.timeBetweenRing = initTimeBetweenRing;
    options.ringSizeFromBoule = initRingSizeFromBoule;
    levelNumber = 0;
}

-(NSString*) getLevelNumber{
 return [NSString stringWithFormat:@"%d", levelNumber];
}

-(void) updateLevel{
    
    int decreaseRingSize = options.ringSizeFromBoule * 0.05;
    int decreaseTime = options.timeBetweenRing * 0.02;
    
    if (decreaseRingSize < 1) decreaseRingSize = 1;
    if (decreaseTime < 1) decreaseTime = 1;
    
    options.ringSizeFromBoule -= decreaseRingSize;
    options.ringSizeFromBouleRandomDistribution -= decreaseRingSize / 2;
    options.timeBetweenRing -= decreaseTime;
    options.timeBetweenRingRandomDistribution -= decreaseTime / 2;
    
    options.ringLife -= options.ringLife * 0.02;
    if (options.ringSizeFromBoule < 0){
        options.ringSizeFromBoule = 0;
    }
    if (options.ringSizeFromBouleRandomDistribution < 0){
        options.ringSizeFromBouleRandomDistribution = 0;
    }
    if (options.timeBetweenRing < 0){
        options.timeBetweenRing = 0;
    }

    if (options.timeBetweenRingRandomDistribution < 0){
        options.timeBetweenRingRandomDistribution = 0;
    }
    levelNumber += 1;
}

-(Ring*)getRingWithMinimumSize:(Hero *)hero withGameController:(GameController *)gc {
    CGFloat bw = hero.image.frame.size.width;
    CGFloat bh = hero.image.frame.size.height;

    int w =  bw + RING_STROKE_THICKNESS / 2 + options.ringSizeFromBoule;
    int h =  bh + RING_STROKE_THICKNESS / 2 + options.ringSizeFromBoule;
    if (options.ringSizeFromBouleRandomDistribution > 0){
        long r = random();
        w += r % options.ringSizeFromBouleRandomDistribution;
        h += r % options.ringSizeFromBouleRandomDistribution;
    }
    
    int _life = options.ringLife;
    if (options.timeBetweenRingRandomDistribution > 0){
        _life += random() % options.timeBetweenRingRandomDistribution;
    }
    
    int margin = GAME_VIEW_BORDER + RING_STROKE_THICKNESS;
    float x = fmod(random(), gc.view.frame.size.width - w - margin * 2) + margin;
    float y = fmod(random(), gc.view.frame.size.height - h - margin * 2) + margin;
    
    Ring *r = [[Ring alloc] initWithFrame:CGRectMake(x, y, w, h) life:_life];
//    [r autorelease];
    if ([r isAroundRect:hero.image.frame]){
        return [self getRingWithMinimumSize:hero withGameController:gc];
    }
//    if ([r collideAnotherRing:gc.rings]){
        //NSLog(@"ring collide");
        //return [self getRingWithMinimumSize:hero withGameController:gc];    
//    }
    return r;
}



-(int)getRingTimer{
    int r = options.timeBetweenRing;
    if (options.timeBetweenRingRandomDistribution > 0){
        r += rand() % options.timeBetweenRingRandomDistribution + 1;
    }
    return r + 1;
}
@end
