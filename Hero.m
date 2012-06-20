//
//  Hero.m
//  Boule2
//
//  Created by Pouya Mohtacham on 05/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "Hero.h"
#import "GameController.h"

@implementation Hero

@synthesize life;
@synthesize image;
@synthesize bouleMove;

-(id)init:(GameController *) gc{
    image = [UIImageView alloc];
    [image initWithFrame:CGRectMake(200, 200, BOULE_SIZE, BOULE_SIZE)];
    UIImage* bouleImage = [UIImage imageNamed:@"Boule.png"];
    [image setImage:bouleImage];
    [bouleImage autorelease];
    life = START_LIFE;
    gameController = gc;
    bouleMove = 100;
    return self;
}

-(void)dealloc{
    [super dealloc];
}

-(void) looseLife{
    life--;             
}

-(BOOL) isDead {
    return life <= 0;
}

- (void)moveWithX:(int)x withY:(int)y {
    [image setFrame:CGRectMake(x, y, image.frame.size.width, image.frame.size.height)];
}

- (CGRect)getFrame{
    return image.frame;
}

-(void)checkBoulePositionIsCorrectAndMoveWithX:(float)x withY:(int)y{
    if (x < 0) { 
        x = 0;
    }
    if (y < GAME_VIEW_BORDER) { 
        y = GAME_VIEW_BORDER;
    }
    if (x + image.frame.size.width > gameController.view.frame.size.width)
    {
        x =  gameController.view.frame.size.width - image.frame.size.width;
    }
    if (y + image.frame.size.height > gameController.view.frame.size.height - GAME_VIEW_BORDER)
    {
        y =  gameController.view.frame.size.height - image.frame.size.height  - GAME_VIEW_BORDER;
    }
    [self moveWithX:x withY:y];    
    
}


@end
