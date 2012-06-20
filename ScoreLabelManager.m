//
//  ScoreLabelManager.m
//  Boule2
//
//  Created by Pouya Mohtacham on 20/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "ScoreLabelManager.h"
#import "GameController.h"

@implementation ScoreLabelManager


-(id)initWithGameController:(GameController*)gc{
    scoreLabels = [[NSMutableArray alloc] init];
    gameController = gc;
    return self;
}

-(void)addScoreLabel:(int)score withColor:(UIColor*)color withCenter:(CGPoint)center{
    ScoreLabel * sl = [[ScoreLabel alloc]initWithScore:score withColor:color withCenter:center];
    [scoreLabels addObject:sl];
    [gameController.view addSubview:sl.label];    
}

-(void)tick{
    for (int i = 0; i < scoreLabels.count; i++) {
        ScoreLabel *sl = [scoreLabels objectAtIndex:i];
        [sl tick];        
    }
    for (int i = 0; i < scoreLabels.count;++i){
        ScoreLabel* sl = [scoreLabels objectAtIndex:i];
        if ([sl isDead]){
            [scoreLabels removeObjectAtIndex:i];
        }
    }    
}

-(void)transformLabels:(int)angle{
    for (int i = 0; i < scoreLabels.count; i++) {
        ScoreLabel *sl = [scoreLabels objectAtIndex:i];
        sl.label.transform = CGAffineTransformMakeRotation(angle);     
    }
}

-(void)dealloc{
    [scoreLabels release];
    [super dealloc];
}

@end
