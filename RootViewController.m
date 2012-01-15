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

-(void)setHighScore{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger hScore = [prefs integerForKey:KEEP_HIGHSCORE_KEY];
    [highScoreLabel setText:[NSString stringWithFormat:@"%d", hScore]];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
    

    [self initView];
    [super viewDidLoad];
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

-(void) initView{
    NavigationController *nv = (NavigationController *)self.navigationController;
    if (nv.gameController == nil){
        [BPlay setTitle:NSLocalizedString(@"VIEW_ROOT_B_PLAY", nil) forState:0 ];
    }
    else {
        [BPlay setTitle:NSLocalizedString(@"VIEW_ROOT_B_RESUME", nil) forState:0 ]; 
    }
    [highScoreLabelText setText:NSLocalizedString(@"VIEW_ROOT_L_HIGHSCORE", nil)];
    [BExit setTitle:NSLocalizedString(@"VIEW_ROOT_B_EXIT", nil) forState:0 ]; 
    [self setHighScore];
}


@end
