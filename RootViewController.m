//
//  RootView.m
//  Boule2
//
//  Created by Aurelien Gasser on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"VIEW_NAME_ROOT", nil);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)loadView{
    NSLog(@"Loaded");
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)play: (id)sender{
    // Override point for customization after application launch.
    [((NavigationController *)self.navigationController) setGame];
}
-(IBAction)BAexit: (id)sender{
    exit(1);
}

-(void) loadLabels{
    NavigationController *nv = (NavigationController *)self.navigationController;
    if (nv.gameController == nil){
       BPlay.titleLabel.text = @"Play";
    }
    else {
       BPlay.titleLabel.text = @"Resume";        
    }
}


@end
