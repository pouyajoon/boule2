//
//  NavigationController.h
//  Boule2
//
//  Created by Aurelien Gasser on 1/14/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"

@interface NavigationController : UINavigationController <UINavigationBarDelegate> {
    GameController *gameController;
}


-(void) setHome;
-(void) setGame;


@property (nonatomic, retain) GameController *gameController;

@end
