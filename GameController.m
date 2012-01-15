//
//  ViewController.m
//  Boule2
//
//  Created by Aurelien Gasser on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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

        [self initGame];
        [drawImage setFrame:self.view.frame];
        [self.view addSubview:drawImage];
        [self initTimer];
    }
    return self;
}


- (void) draw
{    
    //drawImage.frame = self.view.frame;
    
    // Drawing code
    UIGraphicsBeginImageContext(drawImage.frame.size);
    [drawImage.image drawInRect:drawImage.frame];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, drawImage.frame);
    
    CGContextSetLineWidth(context, BOULE_THICKNESS);
    
    for (int i = 0; i < rings.count; i++) {
        [[rings objectAtIndex:i] draw:context];
    } 
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void) gameOver
{
    [rings removeAllObjects];
    [self updateLifeLabel];
    [gameOverLabel setHidden:NO];
    [BRestart setHidden:NO];
    NSLog(@"game over");  
    [self pauseTimer];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    int score = [scoreLabel.text intValue];
    NSInteger hScore = [prefs integerForKey:KEEP_HIGHSCORE_KEY];
    if (score > hScore){
        [prefs setInteger:score forKey:KEEP_HIGHSCORE_KEY];
    }
}


-(void) bouleLooseLife{
    life--;             
    [self updateLifeLabel];
    if ([self isBouleDead])
    {
        [self gameOver];                
    } 
}

- (void) live
{
    for (int i = 0; i < rings.count; i++) {
        if ([[rings objectAtIndex:i] isAroundRect:self.boule.frame])
        {
            Ring* ring = [rings objectAtIndex:i];
            yayLabelTimeleft = 60;
            [yayLabel setFrame:CGRectMake(ring.frame.origin.x, ring.frame.origin.y, yayLabel.frame.size.width, yayLabel.frame.size.height)];
            int score = [scoreLabel.text intValue];
            int score_incr = (10 + ring.lifeCur * 5 - (ring.frame.size.height - boule.frame.size.height - BOULE_THICKNESS / 2)) / 10;
            score += score_incr;
            [yayLabel setText:[NSString stringWithFormat:@"+%d", score_incr]]; 
            [yayLabel setTextColor:[ring getColor]];
            [self updateScoreLabel:score];
            [yayLabel setHidden:NO];   
            [rings removeObjectAtIndex:i];
        } 
        else 
        {
            [[rings objectAtIndex:i] live];
        }
    }    
    for (int i = 0; i < rings.count; i++) {
        if ([[rings objectAtIndex:i] isDead]){
            [rings removeObjectAtIndex:i];
            [self bouleLooseLife];              
        }
    }    
}


-(void) updateScoreLabel:(int)score{
    [scoreLabel setText:[NSString stringWithFormat:@"%d", score]];
}


-(void) updateLifeLabel{
    [lifesLabel setText:[NSString stringWithFormat:@"%d", life]];
}

-(void) initGame{
    [self updateScoreLabel:0];
    [gameOverLabel setHidden:YES];
    [BRestart setHidden:YES];
    life = START_LIFE;
    [self updateLifeLabel];
    timerCount = TIMER_SET_RING / 2;
    [self startTimer];
}

-(IBAction)BARestart:(id)sender{
    [self initGame];
}

- (void) createRandomRing{
    
    int bw = self.boule.frame.size.width;
    int bh = self.boule.frame.size.height;
    
    long r = random();
    int w =  bw + BOULE_THICKNESS / 2 + r % 50 + RING_MIN_DISTANCE;
    int h =  bh + BOULE_THICKNESS / 2 + r % 50 + RING_MIN_DISTANCE;
    
    int _life = 100 + random() % 400;
    
    CGSize imageSize = drawImage.frame.size;
    
    float x = fmod(random(), imageSize.width - w);
    float y = fmod(random(), imageSize.height - h);
    Ring *ring = [[Ring alloc] initWithFrame:CGRectMake(x, y, w, h) life:_life];
    [rings addObject:ring];
    
}




- (void)moveBoule:(int)x withY:(int)y {
    [boule setFrame:CGRectMake(x, y, boule.frame.size.width, boule.frame.size.height)];
    
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    const float move = 100;
    const float kFilteringFactor = 0.5;
    static float accelX = 0;
    static float accelY = 0;
    static float accelZ = 0;
    accelX = (acceleration.x * kFilteringFactor) + (accelX * (1.0 - kFilteringFactor));
    accelY = (acceleration.y * kFilteringFactor) + (accelY * (1.0 - kFilteringFactor));
    accelZ = (acceleration.z * kFilteringFactor) + (accelZ * (1.0 - kFilteringFactor));
    float x = accelX * move + boule.frame.origin.x ;
    float y = -accelY * move + boule.frame.origin.y;
    
    if (x < 0) { 
        x = 0;
    }
    if (y < 0) { 
        y = 0;
    }
    if (x + boule.frame.size.width > self.view.frame.size.width)
    {
        x =  self.view.frame.size.width - boule.frame.size.width;
    }
    if (y + boule.frame.size.height > self.view.frame.size.height)
    {
        y =  self.view.frame.size.height - boule.frame.size.height;
    }
    [self moveBoule:x withY:y];    
}

-(void)initView{
    [BRestart setTitle:NSLocalizedString(@"VIEW_GAME_B_RESTART", nil) forState:0 ];
    [scoreLabelText setText:NSLocalizedString(@"VIEW_GAME_L_SCORE", nil)];
    [gameOverLabel setText:NSLocalizedString(@"VIEW_GAME_L_GAMEOVER", nil)];
    [lifesLabelText setText:NSLocalizedString(@"VIEW_GAME_L_LIFES", nil)];
}





- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [yayLabel setHidden:YES];
    //[self moveBoule:20 withY:20];
}


#pragma mark - View lifecycle
- (void)viewDidLoad {    
      
    NSLog(@"View Loaded");
    
    [self initView];

    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0/30.0];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    [super viewDidLoad];

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
    NSLog(@"timer %d", timerCount);
    
    if (timerCount % TIMER_SET_RING == 0)
    {
        [self createRandomRing];
    }    
    if (yayLabelTimeleft > 0)
    {
        --yayLabelTimeleft;
    }
    if (yayLabelTimeleft == 0) {
        [yayLabel setHidden:YES];
    }
    [self live];
    [self draw];
    timerCount++;
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
