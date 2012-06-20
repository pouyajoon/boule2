//
//  ScoreLabelManager.h
//  Boule2
//
//  Created by Pouya Mohtacham on 20/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreLabel.h"

@class GameController;

@interface ScoreLabelManager : NSObject{
    NSMutableArray *scoreLabels;
    GameController *gameController;
}

-(id)initWithGameController:(GameController*)gc;
-(void)addScoreLabel:(int)score withColor:(UIColor*)color withCenter:(CGPoint)center;
-(void)tick;
-(void)transformLabels:(int)angle;

@end
