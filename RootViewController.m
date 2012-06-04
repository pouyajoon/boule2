//
//  RootView.m
//  Boule2
//
//  Created by Aurelien Gasser on 1/14/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
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


-(int)getHighScoreLocal{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs integerForKey:KEEP_HIGHSCORE_KEY];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    float angle = [GameController getAngleFromAcceleration:acceleration];
    
    BPlay.transform = CGAffineTransformMakeRotation(angle);
    BExit.transform = CGAffineTransformMakeRotation(angle);
    BBestScore.transform = CGAffineTransformMakeRotation(angle);
}

#pragma mark GameCenter View Controllers
- (void) showLeaderboard;
{
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL) 
	{
		leaderboardController.category = GAMECENTER_LB_CATEGORY;
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self; 
		[self presentModalViewController: leaderboardController animated: YES];
	}
}
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController

{
    [self dismissModalViewControllerAnimated:YES];    
}

-(IBAction)BABestScore: (id)sender{
    [self showLeaderboard];
    //   [((NavigationController *)self.navigationController) setHighScore];
}

#pragma mark - View lifecycle


-(void) setAccelerometer{
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0/12.0];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

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


- (void) processGameCenterAuth: (NSError*) error
{
	if(error == NULL)
	{
		[gameCenterManager reloadHighScoresForCategory: GAMECENTER_LB_CATEGORY];
	}
	else
	{
		UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: @"Game Center Account Required" 
                                                        message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]
                                                       delegate: self cancelButtonTitle: @"Try Again..." otherButtonTitles: NULL] autorelease];
		[alert show];
	}
	
}



- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
{
    int64_t personalBest= leaderBoard.localPlayerScore.value;
    [self updateHighScoreText : personalBest];

}


-(void) updateHighScoreText:(int64_t) highscore{
//    int highscore = [self getHighScore];
    BBestScore.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    BBestScore.titleLabel.textAlignment = UITextAlignmentCenter;
    NSString *hs = [NSString stringWithFormat:@"%@\n%d",NSLocalizedString(@"VIEW_ROOT_L_HIGHSCORE", nil), highscore];
    [BBestScore setTitle:hs forState:UIControlStateNormal];

}


-(void) initView{
    [self setAccelerometer];

    NavigationController *nv = (NavigationController *)self.navigationController;
    if (nv.gameController == nil){
        [BPlay setTitle:NSLocalizedString(@"VIEW_ROOT_B_PLAY", nil) forState:0 ];
    }
    else {
        [BPlay setTitle:NSLocalizedString(@"VIEW_ROOT_B_RESUME", nil) forState:0 ]; 
    }
    
    [self updateHighScoreText : [self getHighScoreLocal]];
    [BExit setTitle:NSLocalizedString(@"VIEW_ROOT_B_EXIT", nil) forState:0 ]; 
    
    
    gameCenterManager = [GameCenterManager getGameCenterManager:self];
    if (gameCenterManager != nil){
        [gameCenterManager reloadHighScoresForCategory:GAMECENTER_LB_CATEGORY];
    }
    
}



@end
