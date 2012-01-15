//
//  ViewController.h
//  Boule2
//
//  Created by Aurelien Gasser on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "Ring.h"


@interface GameController : UIViewController <UIAccelerometerDelegate>{
    IBOutlet UIImageView *boule;
    IBOutlet UILabel *yayLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *gameOverLabel;
    IBOutlet UILabel *lifesLabel;
    IBOutlet UIButton *BRestart;

    NSMutableArray *rings;
    UIImageView *drawImage;
    NSTimer *timer;
    int life;
    int yayLabelTimeleft;
    BOOL timerIsEnabled;
    
    int timerCount;

}

-(void) startTimer;
-(void) pauseTimer;
-(void) initTimer;
-(void) createRandomRing;
-(void) draw;
-(void) live;
-(void) gameOver;
-(BOOL) isBouleDead;
-(IBAction)BARestart:(id)sender;
-(void) updateLifeLabel;
-(void) updateScoreLabel:(int)score;
-(void) initGame;

@property (nonatomic, strong, retain) IBOutlet UIImageView *boule;

@end

