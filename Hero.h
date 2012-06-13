//
//  Hero.h
//  Boule2
//
//  Created by Pouya Mohtacham on 05/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"

@class GameController;

@interface Hero : NSObject{

    IBOutlet UIImageView *image;
    GameController* gameController;
    int life;
    int bouleMove;
}

- (id) init:(GameController *) gc;
- (void) looseLife;
- (BOOL) isDead;
- (void) moveWithX:(int)x withY:(int)y;
- (CGRect) getFrame;
- (void) checkBoulePositionIsCorrectAndMoveWithX:(float)x withY:(int)y;

@property (nonatomic) int life;
@property (nonatomic) int bouleMove;
@property (nonatomic, retain) IBOutlet UIImageView *image;


@end
