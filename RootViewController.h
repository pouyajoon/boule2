//
//  RootView.h
//  Boule2
//
//  Created by Aurelien Gasser on 1/14/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GameController.h"
#import "GameCenterManager.h"
#import "NavigationController.h"

@interface RootViewController : UIViewController <UIAccelerometerDelegate, GameCenterManagerDelegate, GKLeaderboardViewControllerDelegate>{
    IBOutlet UIButton *BPlay;    
    IBOutlet UIButton *BExit;    
    IBOutlet UIButton *BBestScore;
    
    GameCenterManager* gameCenterManager;
}

-(IBAction)play: (id)sender;
-(IBAction)BAexit: (id)sender;
-(IBAction)BABestScore: (id)sender;
-(void)initView;

@end


