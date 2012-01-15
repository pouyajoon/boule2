//
//  NavigationController.m
//  Boule2
//
//  Created by Aurelien Gasser on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NavigationController.h"
#import "RootViewController.h"



@implementation NavigationController


@synthesize gameController;

-(void) viewDidLoad
{
    // change the back button and add an event handler
 
    self.gameController = nil;
}

-(void)setHome{
    RootViewController *myRootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:[NSBundle mainBundle]];
    [self pushViewController:myRootViewController animated:NO];
    [myRootViewController release];
}

-(void)setGame{
    if (self.gameController == nil){
        GameController *myViewController = [[GameController alloc] initWithNibName:@"GameController" bundle:[NSBundle mainBundle]];
        [self pushViewController:myViewController animated:YES];
        [myViewController release];  
    } else {
        [self pushViewController:self.gameController animated:YES];
        [self.gameController release];
    }
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"push : %d", [self.viewControllers count]);
    if ([self.viewControllers count] > 0){
        if ([self.topViewController isMemberOfClass:[RootViewController class]]) {
            if (self.gameController != nil){
                [self.gameController startTimer];
                [super pushViewController:self.gameController animated:animated];
                self.gameController = nil;
                return;
            }
        }
    }
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    NSLog(@"pop : %d", [self.viewControllers count]);
    if ([self.viewControllers count] > 0){
        if ([self.topViewController isMemberOfClass:[GameController class]]) {
            self.gameController = (GameController*)[self visibleViewController];
            [self.gameController pauseTimer];
            if ([self.gameController isBouleDead])
            {
                self.gameController = nil;
            }
        }
    }
    return [super popViewControllerAnimated:animated];
}
@end
