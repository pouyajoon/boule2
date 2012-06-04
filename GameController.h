//
//  ViewController.h
//  Boule2
//
//  Created by Aurelien Gasser on 1/7/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "config.h"
#import "Ring.h"
#import "Level.h"
#import "GameCenterManager.h"


typedef enum{
    playing,
    waitingToRestart
}EgameState;

@interface GameController : UIViewController <UIAccelerometerDelegate, GameCenterManagerDelegate>{
    IBOutlet UIImageView *boule;
    IBOutlet UILabel *incScoreLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *gameOverLabel;
    IBOutlet UIButton *BRestart;
    IBOutlet UIButton *BHome;
    
    IBOutlet UILabel *labelLevel;
    IBOutlet UILabel *labelLevelValue;
    IBOutlet UILabel *labelRings;
    IBOutlet UILabel *labelRingsValue;
    IBOutlet UILabel *labelDifficulty;
    IBOutlet UILabel *labelDifficultyValue;
    IBOutlet UIButton *BNotification;

    
    int accelerometeCount;
    int bouleMove;
    
    GameCenterManager *gameCenterManager;
    
    int ringsCatched;
    NSMutableArray *rings;
    NSMutableArray *deadRings;
    UIImageView *drawImage;
    NSTimer *timer;
    int life;
    int incScoreTimeleft;
    BOOL timerIsEnabled;
    Level *currentLevel;
    int timerCount;
    EgameState gameState;
    int drawLifes;
    int difficultyPourcentage;

}

-(void) resumeGame;
+(float) getAngleFromAcceleration:(UIAcceleration *)acceleration;
-(void) startTimer;
-(void) pauseTimer;
-(void) initTimer;
-(void) createRandomRing;
-(void) draw;
-(void) live;
-(void) gameOver;
-(BOOL) isBouleDead;
-(IBAction)BARestart:(id)sender;
-(IBAction)BAHome:(id)sender;
-(IBAction)BANotification:(id)sender;

-(void) updateScoreLabel:(int)score;
-(void) initGame;

@property (nonatomic, strong, retain) IBOutlet UIImageView *boule;

@end

