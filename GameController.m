//
//  ViewController.m
//  Boule2
//
//  Created by Aurelien Gasser on 1/7/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "GameController.h"
#import "Ring.h"
#import "NavigationController.h"

@implementation GameController

@synthesize boule;


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
        boule = [UIImageView alloc];
        [boule initWithFrame:CGRectMake(0, 0, BOULE_SIZE, BOULE_SIZE)];
           // [bould set
        UIImage* bouleImage = [UIImage imageNamed:@"Boule.png"];
        [boule setImage:bouleImage];
        ringsCatched = 0;

        [drawImage setFrame:self.view.frame];
        [drawImage addSubview:boule];
        
        //labelLevel = [[UILabel alloc] autorelease];
        //labelLevelValue = [[UILabel alloc] autorelease];
        
        
        [self.view addSubview:drawImage];
        
        [self initTimer];
    }
    return self;
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
    [self updateCatchedRingsLabel];
    
}

- (void) gameOver
{
    //[rings removeAllObjects];
    [self setRingsToAlphaHidding];
    gameState = waitingToRestart;
    [gameOverLabel setHidden:NO];
    [BRestart setHidden:NO];
    bouleMove = 20;
    [self updateHighScore];
    [self resetLevel];
    NSLog(@"game over");  
    //[self pauseTimer];

}

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
    [BNotification setTitle:title forState:UIControlStateNormal];
    BNotification.hidden = NO;
    
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

-(void) bouleLooseLife{
    life--;             
    if ([self isBouleDead])
    {
        [self gameOver];                
    } 
}

-(void) bouleIsInsideRing:(Ring*)ring{
    
    [self increaseRingsCatchedNumber];

    // set score
    incScoreTimeleft = 60;
    
    //CGRect frame = incScoreLabel.frame;
    //frame.origin = CGPointMake(boule.frame.origin.x, boule.frame.origin.y);
    //incScoreLabel.frame = frame;

    int score = [scoreLabel.text intValue];
    // define score
    
    float rCur = ring.lifeCur;
    float rMax = ring.lifeMax;
    
    float ratioLife = rCur / rMax;
    int diffSize = 150 - (ring.frame.size.width - BOULE_SIZE);
    
    int score_incr = floor(ratioLife * diffSize);
    
    score += floor(score_incr);
    [incScoreLabel setText:[NSString stringWithFormat:@"+%d", score_incr]]; 
    [incScoreLabel setTextColor:[ring getColor]];
    incScoreLabel.center = CGPointMake(boule.frame.origin.x, boule.frame.origin.y);

    
    [self updateScoreLabel:score];
    
    
    [incScoreLabel setHidden:NO];  
    if (ringsCatched % 10 == 0){
        [self increaseLevel];
    }
    
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
    [self updateCatchedRingsLabel];
}

-(void)updateCatchedRingsLabel{
    [labelRingsValue setText:[NSString stringWithFormat:@"%d", ringsCatched]];   
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
        
        CGPoint destination = [self getLifePosition:life - 1];
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
                if ([ring isAroundRect:self.boule.frame]){
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


-(void) updateScoreLabel:(int)score{
    [scoreLabel setText:[NSString stringWithFormat:@"%d", score]];
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
    [self updateScoreLabel:0];
    [gameOverLabel setHidden:YES];
    [BRestart setHidden:YES];
    life = START_LIFE;
    timerCount = 0;
    bouleMove = 100;
    [self startTimer];
    [self updateHighScore];
}

-(IBAction)BARestart:(id)sender{
    [self initGame];
}

-(IBAction)BANotification:(id)sender{
    BNotification.hidden = YES;
}

- (void) createRandomRing{   

    Ring *ring = [currentLevel getRingWithMinimumSize:boule canvasSize:drawImage.frame.size];    
    [rings addObject:ring];
}

- (void)moveBoule:(int)x withY:(int)y {
    [boule setFrame:CGRectMake(x, y, boule.frame.size.width, boule.frame.size.height)];
}

+(float) getAngleFromAcceleration:(UIAcceleration *)acceleration{
    float accelXangle = roundf(acceleration.x * 1000) / 1000;
    float accelYangle = roundf(acceleration.y * 1000) / 1000;

    float xx = -accelXangle;
    float yy = accelYangle;
    float angle = atan2(yy, xx) + M_PI / 2;
    return angle;
}

-(void) setAccelerometer{
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0/36.0];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    accelerometeCount = 0;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    const float kFilteringFactor = 0.5;
    static float accelX = 0;
    static float accelY = 0;
    static float accelZ = 0;
    
    accelX = (acceleration.x * kFilteringFactor) + (accelX * (1.0 - kFilteringFactor));
    accelY = (acceleration.y * kFilteringFactor) + (accelY * (1.0 - kFilteringFactor));
    accelZ = (acceleration.z * kFilteringFactor) + (accelZ * (1.0 - kFilteringFactor));
    float x = accelX * bouleMove + boule.frame.origin.x ;
    float y = -accelY * bouleMove + boule.frame.origin.y;
    [self checkBoulePositionIsCorrectAndMoveWithX:x withY:y];

    float angle = [GameController getAngleFromAcceleration:acceleration];

    if (accelerometeCount % 2 == 0){
        incScoreLabel.transform = CGAffineTransformMakeRotation(angle);    
    }
    if (accelerometeCount % 3 == 0){
        
        BRestart.transform = CGAffineTransformMakeRotation(angle);
        gameOverLabel.transform = CGAffineTransformMakeRotation(angle);
        BNotification.transform = CGAffineTransformMakeRotation(angle);
//        labelLevelValue.transform = CGAffineTransformMakeRotation(angle);
//        labelRingsValue.transform = CGAffineTransformMakeRotation(angle);

    }
    
    accelerometeCount += 1;
}

-(void)checkBoulePositionIsCorrectAndMoveWithX:(float)x withY:(int)y{
    if (x < 0) { 
        x = 0;
    }
    if (y < 26) { 
        y = 26;
    }
    if (x + boule.frame.size.width > self.view.frame.size.width)
    {
        x =  self.view.frame.size.width - boule.frame.size.width;
    }
    if (y + boule.frame.size.height > self.view.frame.size.height - 26)
    {
        y =  self.view.frame.size.height - boule.frame.size.height  - 26;
    }
    [self moveBoule:x withY:y];    

}


-(void)initView{
    [self setAccelerometer];
    [BRestart setTitle:NSLocalizedString(@"VIEW_GAME_B_RESTART", nil) forState:0 ];
    [gameOverLabel setText:NSLocalizedString(@"VIEW_GAME_L_GAMEOVER", nil)];
    [labelLevel setText:NSLocalizedString(@"VIEW_GAME_L_LEVEL", nil)];
    [labelLevelValue setText:@"0"];
    [labelRings setText:NSLocalizedString(@"VIEW_GAME_L_RINGS", nil)];
    [labelRingsValue setText:@"0"];
    [labelDifficulty setText:NSLocalizedString(@"VIEW_GAME_L_DIFFICULTY", nil)];
    [labelDifficultyValue setText:@"0%"];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [incScoreLabel setHidden:YES];
    //[self moveBoule:20 withY:20];
}


-(void) resumeGame{
    [self setAccelerometer];
    [self startTimer];
}



#pragma mark - View lifecycle
- (void)viewDidLoad {    
    NSLog(@"View Loaded");
    [super viewDidLoad];
    [self initView];
}

-(BOOL) isBouleDead {
    return life <= 0;
}

- (void) pauseTimer{
    timerIsEnabled = NO;
}

- (void) startTimer{
    if (life <= 0) return;
    timerIsEnabled = YES;
}

- (void) initTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_RING target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
    [self startTimer];
    [timer fire];
}

- (void) increaseTimerCount
{
    if (timerIsEnabled == NO) 
    {
        return;
    }

    int ringTimer = [currentLevel getRingTimer];
    if (gameState == playing){
        if ((timerCount % ringTimer) == 0)
        {
//            NSLog(@"timer for ring :%d", timerCount);
            [self createRandomRing];
        }
    }
    
    [self reduceScoreLabelTime];
    [self live];
    [self draw];
    timerCount++;
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
    [boule release];
    [rings release];
    [drawImage release];
    //[timer invalidate];
    //[timer release];
    [super dealloc];

}

@end
