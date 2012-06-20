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
#import "Notification.h"


@implementation GameController

@synthesize hero;
@synthesize notificationDirection;
@synthesize BNotification;
@synthesize rings;
@synthesize currentLevel;

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
        notificationManager = [[NotificationManager alloc]initWithGameController:self];
        scoreLabelManager = [[ScoreLabelManager alloc] initWithGameController:self];
        ringsCatched = 0;

        [drawImage setFrame:self.view.frame];
        [drawImage addSubview:hero.image];
        
        [self.view addSubview:drawImage];

        timer = [Timer alloc];
        [timer init:self];        
        [timer initTimer];
        
        nextRing = 30;
        
        [notificationManager addNotification:@"Nice!"];
        [scoreLabelManager addScoreLabel:69 withColor:[UIColor blueColor] withCenter:CGPointMake(69, 69)];
        
    }
    return self;
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    [accelerometerManager accelerometer:accelerometer didAccelerate:acceleration];
}

-(void)tick{    
    if (gameState == playing){
        nextRing -= 1;
        if (nextRing < 0)
        {
            [self createRandomRing];
        }
    }    
    [self live];
    [self draw];
    [self updateLabels];
    [self decreaseNotificationTimer];
    [notificationManager tick];
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
        [notificationManager addNotification:@"Score Report Failed!"];
//		[self showAlertWithTitle: @"Score Report Failed!"
//						 message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
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


-(void) addScore:(int)score_incr withColor:(UIColor*)color withPosition:(CGPoint)position{
    [scoreLabelManager addScoreLabel:score_incr withColor:color withCenter:position];
    scoreManager.score += score_incr;    
}




-(void) updateIncScore:(Ring*)ring{
    
    // define inc score    
    
    int score_incr = floor(([currentLevel getDifficultyPercentage] + 1) * BOULE_SIZE + rand() % 25);
    float ringLifeRatio = (ring.lifeCur / (float)ring.lifeMax);
    score_incr = score_incr * ringLifeRatio;
    score_incr /= 10;
//    CGPoint position = CGPointMake(hero.image.frame.origin.x, hero.image.frame.origin.y);
    [self addScore:score_incr withColor:[ring getColor] withPosition:[ring getMiddle]];
    
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
    [notificationManager addNotification:[NSString stringWithFormat:@"Level %d", currentLevel.levelNumber]];
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
                    if (rings.count <= 2){
                        [self createRandomRing];
                    }
                    
                    break;
                }
                break;
            default:
                break;
        }
        [ring live];        
        for (int i = 0; i < rings.count;++i){
            Ring* r = [rings objectAtIndex:i];
            if (r.ringState == dead){
                [rings removeObjectAtIndex:i];
            }
        }
        
    }
    [scoreLabelManager tick];
}


- (void) processGameCenterAuth: (NSError*) error
{
	if(error == NULL)
	{
		//[gameCenterManager reloadHighScoresForCategory: GAMECENTER_LB_CATEGORY];
	}
	else
	{
//		UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: @"Game Center Account Required" 
//                                                        message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]
//                                                       delegate: self cancelButtonTitle: @"Try Again..." otherButtonTitles: NULL] autorelease];
//		[alert show];
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
    [timer startTimer];
    hero.bouleMove = 100;
    [self updateHighScore];
    scoreManager.score = 0;
    [self resetLevel];
}

-(IBAction)BARestart:(id)sender{
    [self initGame];
}

-(IBAction)BANotification:(id)sender{
    BNotification.hidden = YES;
}

- (void) createRandomRing{   

    Ring *ring = [currentLevel getRingWithMinimumSize:hero withGameController:self];    
    nextRing = [currentLevel getRingTimer];
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
    [scoreLabelManager transformLabels:angle];
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
    [AccelerometerManager setAccelerometer:self];
    [timer startTimer];
}


-(void) bouleLooseLife{
    [hero looseLife];
    [notificationManager addNotification:[NSString stringWithFormat:@"%d lives", [hero life]]];
    if ([hero isDead]){
        [self gameOver];                
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
