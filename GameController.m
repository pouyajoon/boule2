//
//  ViewController.m
//  Boule2
//
//  Created by Aurelien Gasser on 1/7/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "GameController.h"
#import "NavigationController.h"
#import "AccelerometerManager.h"
#import "Timer.h"


@implementation GameController

@synthesize hero;
@synthesize notificationDirection;
@synthesize BNotification;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"VIEW_NAME_GAME", nil);

        rings = [[NSMutableArray alloc] init];
        drawImage = [[UIImageView alloc] initWithImage:nil];
        
        LevelOptions *levelOptions = [LevelOptions alloc];
        levelOptions.timeBetweenRing = 90;
        levelOptions.timeBetweenRingRandomDistribution = 0;
        levelOptions.ringLife = 300;
        levelOptions.ringSizeFromBoule = 90;
        levelOptions.ringSizeFromBouleRandomDistribution = 0;
        currentLevel = [[Level alloc] initWithOptions: levelOptions];
        [self initGame];

        hero = [Hero alloc];
        [hero init:self];
        scoreManager = [[ScoreManager alloc] init];
        accelerometerManager = [[AccelerometerManager alloc] init:self];
        [AccelerometerManager setAccelerometer:self];
        ringsCatched = 0;

        [drawImage setFrame:self.view.frame];
        [drawImage addSubview:hero.image];
        
        //labelLevel = [[UILabel alloc] autorelease];
        //labelLevelValue = [[UILabel alloc] autorelease];
        
        [self.view addSubview:drawImage];

        timer = [Timer alloc];
        [timer init:self];        
        [timer initTimer];
        
         [self showAlertWithTitle:@"Nice!" message:@""];
    }
    return self;
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    [accelerometerManager accelerometer:accelerometer didAccelerate:acceleration];
}

-(void)tick{    
    int ringTimer = [currentLevel getRingTimer];
    if (gameState == playing){
        if (([timer timerCount] % ringTimer) == 0)
        {
            [self createRandomRing];
        }
    }    
    [self reduceScoreLabelTime];
    [self live];
    [self draw];
    [self updateLabels];
    [self decreaseNotificationTimer];
}

-(CGPoint) getLifePosition:(int)position{
    return CGPointMake(GAME_LIFE_MARGIN + position * GAME_LIFE_MARGIN + position * GAME_LIFE_SIZE, GAME_LIFE_MARGIN);
}

- (void) draw
{    
    //drawImage.frame = self.view.frame;
    
    // Drawing code
    UIGraphicsBeginImageContext(drawImage.frame.size);
    [drawImage.image drawInRect:drawImage.frame];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, drawImage.frame);
    
    
    for (int i = 0; i < drawLifes; i++) {        
        CGColorRef color = [UIColor greenColor].CGColor;
        CGPoint position = [self getLifePosition:i];
        CGContextSetFillColorWithColor(context, color);
        CGContextAddEllipseInRect(context, CGRectMake(position.x, position.y, GAME_LIFE_SIZE, GAME_LIFE_SIZE));
        CGContextFillPath(context);
    }
    
    for (int i = 0; i < rings.count; i++) {
        Ring *ring = [rings objectAtIndex:i];
        [ring draw:context];
    }
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void) setRingsToAlphaHidding{
    for (int i = 0; i < rings.count; i++) {
        Ring *ring = [rings objectAtIndex:i];
        if (ring.ringState == living){
            ring.ringState = alphaHidding;
        }
        
    }
}


-(void)resetLevel{
    [currentLevel reset];
    [self drawLevel];
    ringsCatched = 0;
}

- (void) gameOver
{
    //[rings removeAllObjects];
    [self setRingsToAlphaHidding];
    gameState = waitingToRestart;
    [gameOverLabel setHidden:NO];
    [BRestart setHidden:NO];
    hero.bouleMove = 20;
    [self updateHighScore];
    [self resetLevel];
    NSLog(@"game over");  
    //[self pauseTimer];

}

-(void) decreaseNotificationTimer{
    if (BNotification.isHidden){
        return;
    }
    notificationTimer -= 1;
    if (notificationTimer < 0){
        BNotification.hidden = YES;
    }
    BNotification.frame = CGRectMake(BNotification.frame.origin.x + 2.5, BNotification.frame.origin.y, BNotification.frame.size.width, BNotification.frame.size.height);
}

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
    notificationTimer = 240;
    [BNotification setTitle:title forState:UIControlStateNormal];
    BNotification.hidden = NO;
    
    int r = rand();
    
    int y = GAME_VIEW_BORDER + fmod(r, (self.view.frame.size.height - GAME_VIEW_BORDER));
    int x = -BNotification.frame.size.width;
    
//    if (notificationDirection.x > 0){
//        x = self.view.frame.size.width;
//    }
    BNotification.frame = CGRectMake(x, y, BNotification.frame.size.width, BNotification.frame.size.height);
    
//    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
//    [l setText:@"yeahhh"]; 
//    UIColor c = 
//    [l setTextColor:[UIColor blackColor]];  
//    [self.view addSubview:l];
    
//	UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: title message: message 
//                                                   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] autorelease];
//	[alert show];
	
}


- (void) scoreReported: (NSError*) error;
{
	if(error == NULL)
	{
		//[gameCenterManager reloadHighScoresForCategory: GAMECENTER_LB_CATEGORY];
		//[self showAlertWithTitle: @"Score Reported!"
        //                 message: [NSString stringWithFormat: @"", [error localizedDescription]]];
	}
	else
	{
		[self showAlertWithTitle: @"Score Report Failed!"
						 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
	}
}

-(void)updateHighScore{

    gameCenterManager = [GameCenterManager getGameCenterManager:self];
    int64_t score = [scoreLabel.text intValue];        
    if (gameCenterManager != nil){
        [gameCenterManager reportScore:score forCategory:GAMECENTER_LB_CATEGORY];
    }

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger hScore = [prefs integerForKey:KEEP_HIGHSCORE_KEY];
    if (score > hScore){
        [prefs setInteger:score forKey:KEEP_HIGHSCORE_KEY];
    }
}




-(IBAction)BAHome:(id)sender{
    [((NavigationController *)self.navigationController) popViewControllerAnimated:YES];
}


-(void) updateIncScoreLabel:(int)score_incr withRing:(Ring*)ring{
    [incScoreLabel setText:[NSString stringWithFormat:@"+%d", score_incr]]; 
    [incScoreLabel setTextColor:[ring getColor]];
    incScoreLabel.center = CGPointMake(hero.image.frame.origin.x, hero.image.frame.origin.y);    
}


-(void) updateIncScore:(Ring*)ring{
    
    // define inc score    
    
    int score_incr = floor(([currentLevel getDifficultyPercentage] + 1) * BOULE_SIZE + rand() % 25);
    float ringLifeRatio = (ring.lifeCur / (float)ring.lifeMax);
    score_incr = score_incr * ringLifeRatio;
    score_incr /= 10;
    [self updateIncScoreLabel:score_incr withRing:ring];
    
    // set score timer & show it
    incScoreTimeleft = 60;    
    [incScoreLabel setHidden:NO];
        
    scoreManager.score += score_incr;    
}


-(void) updateLabels{
    [labelRingsValue setText:[NSString stringWithFormat:@"%d", ringsCatched]];   
    [scoreLabel setText:[NSString stringWithFormat:@"%d", scoreManager.score]];

}


-(void) checkAndLevelUpIfRequired{
    if (ringsCatched % 10 == 0){
        [self increaseLevel];
    }
}

-(void) bouleIsInsideRing:(Ring*)ring{
    [self increaseRingsCatchedNumber];
    [self updateIncScore:ring];
    [self checkAndLevelUpIfRequired];
}

-(void)drawLevel{
    [labelLevelValue setText:[currentLevel getLevelNumber]];
    [labelDifficultyValue setText:[NSString stringWithFormat:@"%d%@", [currentLevel getDifficultyPercentage], @"%"]];
}

-(void)increaseLevel{
    [currentLevel updateLevel];
    [self drawLevel];
    [self showAlertWithTitle:@"Level Up!" message:@""];
}

-(void) increaseRingsCatchedNumber{
    ringsCatched += 1;  
}


- (void) live
{
    int levelD = [currentLevel getDifficultyPercentage];
    if (levelD >= 100){
        [self gameOver];
        return;
    }
    
    // for each ring
    for (int i = 0; i < rings.count; i++) {
        Ring* ring = [rings objectAtIndex:i];
        
        CGPoint destination = [self getLifePosition:hero.life - 1];
        switch (ring.ringState) {
            case onLifeScore:
                drawLifes -= 1;
                break;
            case notCatched:
                [ring setDestination:destination];
                [self bouleLooseLife];
               

//                [self bouleIsInsideRing:ring];                
//                ring.ringState = growToDie;
                break;
                
            case living:
                if ([ring isAroundRect:hero.image.frame]){
                    [self bouleIsInsideRing:ring];
                    
                    ring.ringState = growToDie;
                    break;
                }
                break;
            default:
                break;
        }
        [ring live];        
    }
}


- (void) processGameCenterAuth: (NSError*) error
{
	if(error == NULL)
	{
		//[gameCenterManager reloadHighScoresForCategory: GAMECENTER_LB_CATEGORY];
	}
	else
	{
		UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: @"Game Center Account Required" 
                                                        message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]
                                                       delegate: self cancelButtonTitle: @"Try Again..." otherButtonTitles: NULL] autorelease];
		[alert show];
	}
	
}

-(void) initGame{
    gameState = playing;
    drawLifes = START_LIFE;
    [rings removeAllObjects];
    [gameOverLabel setHidden:YES];
    [BRestart setHidden:YES];
    hero.life = START_LIFE;
    [timer resetTimer];
    hero.bouleMove = 100;
    [timer startTimer];
    [self updateHighScore];
}

-(IBAction)BARestart:(id)sender{
    [self initGame];
}

-(IBAction)BANotification:(id)sender{
    BNotification.hidden = YES;
}

- (void) createRandomRing{   

    Ring *ring = [currentLevel getRingWithMinimumSize:hero canvasSize:drawImage.frame.size];    
    [rings addObject:ring];
}



+(float) getAngleFromAcceleration:(UIAcceleration *)acceleration{
    float accelXangle = roundf(acceleration.x * 1000) / 1000;
    float accelYangle = roundf(acceleration.y * 1000) / 1000;
    
    float xx = -accelXangle;
    float yy = accelYangle;
    float angle = atan2(yy, xx) + M_PI / 2;
    return angle;
}


-(void) updateDynamicControlsAngle:(int)angle{
    incScoreLabel.transform = CGAffineTransformMakeRotation(angle);    
}


-(void) updateStaticControlsAngle:(int)angle{
    BRestart.transform = CGAffineTransformMakeRotation(angle);
    gameOverLabel.transform = CGAffineTransformMakeRotation(angle);
    //BNotification.transform = CGAffineTransformMakeRotation(angle);

}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc that aren't in use.
}



-(void) resumeGame{
    //[accelerometerManager setAccelerometer:self];
    [timer startTimer];
}


-(void) bouleLooseLife{
    [hero looseLife];
    if ([hero isDead]){
        [self gameOver];                
    }
}


-(void) reduceScoreLabelTime{
    if (incScoreTimeleft > 0)
    {
        --incScoreTimeleft;
    }
    if (incScoreTimeleft == 0) {
        [incScoreLabel setHidden:YES];
    }
}

#pragma mark - View lifecycle



-(void)initView{
//    [accelerometerManager setAccelerometer:self];
    [BRestart setTitle:NSLocalizedString(@"VIEW_GAME_B_RESTART", nil) forState:0 ];
    [gameOverLabel setText:NSLocalizedString(@"VIEW_GAME_L_GAMEOVER", nil)];
    [labelLevel setText:NSLocalizedString(@"VIEW_GAME_L_LEVEL", nil)];
    [labelLevelValue setText:@"0"];
    [labelRings setText:NSLocalizedString(@"VIEW_GAME_L_RINGS", nil)];
    [labelRingsValue setText:@"0"];
    [labelDifficulty setText:NSLocalizedString(@"VIEW_GAME_L_DIFFICULTY", nil)];
    [labelDifficultyValue setText:@"0%"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [incScoreLabel setHidden:YES];
    //[self moveBoule:20 withY:20];
}

- (void)viewDidLoad {    
    NSLog(@"View Loaded");
    [super viewDidLoad];
    [self initView];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc{
    NSLog(@"destroy game");
    [hero release];
    [rings release];
    [drawImage release];
    [super dealloc];
}

@end
