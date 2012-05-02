//
//  RootView.h
//  Boule2
//
//  Created by Aurelien Gasser on 1/14/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"
#import "NavigationController.h"

@interface RootViewController : UIViewController <UIAccelerometerDelegate>{
    IBOutlet UIButton *BPlay;    
    IBOutlet UIButton *BExit;    
    IBOutlet UIButton *BBestScore;
    IBOutlet UILabel *highScoreLabelText;
    IBOutlet UILabel *highScoreLabel;    
}

-(IBAction)play: (id)sender;
-(IBAction)BAexit: (id)sender;
-(void)initView;
-(void)setHighScore;

@end


