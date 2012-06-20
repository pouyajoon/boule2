//
//  ScoreLabel.m
//  Boule2
//
//  Created by Pouya Mohtacham on 20/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "ScoreLabel.h"

@implementation ScoreLabel
@synthesize label;


-(id)initWithScore:(int)score withColor:(UIColor*)color withCenter:(CGPoint)center{
    state = sl_falling;
    label = [[UILabel alloc] init];
    label.center = center;
    label.font = [config getFontWithSize:36];
    [label setTextColor:color];
    [label setText:[NSString stringWithFormat:@"+%d", score]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label sizeToFit];
    return self;
}


-(void)tick{
    CGFloat fontSize = label.font.pointSize - 0.5;
    if (fontSize < 0){
        state = sl_dead;
        return;
    }
    label.font = [config getFontWithSize:fontSize];
}

-(BOOL) isDead{
    return state == sl_dead;
}

@end
