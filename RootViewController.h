//
//  RootView.h
//  Boule2
//
//  Created by Aurelien Gasser on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"
#import "NavigationController.h"

@interface RootViewController : UIViewController{

    IBOutlet UIButton *BPlay;    
}

-(IBAction)play: (id)sender;
-(IBAction)BAexit: (id)sender;
-(void)loadLabels;

@end


