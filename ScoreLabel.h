//
//  ScoreLabel.h
//  Boule2
//
//  Created by Pouya Mohtacham on 20/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "config.h"

typedef enum
{
    sl_falling,
    sl_dead
}EScoreLabelState;


@interface ScoreLabel : NSObject{
    UILabel *label;
    int life;
    EScoreLabelState state;
}

-(id) initWithScore:(int)score withColor:(UIColor*)color withCenter:(CGPoint)center;
-(void) tick;
-(BOOL) isDead;

@property (retain, nonatomic) UILabel *label;

@end
