//
//  ViewController.h
//  Boule2
//
//  Created by Aurelien Gasser on 1/7/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#ifndef GAMECONTROLLER_H
#define GAMECONTROLLER_H

#import <UIKit/UIKit.h>
#import "config.h"
#import "Ring.h"
#import "Level.h"
#import "GameCenterManager.h"
#import "ScoreManager.h"
#import "Hero.h"
#import "AccelerometerManager.h"
@class Timer;

typedef enum{
    playing,
    waitingToRestart
}EgameState;

@interface GameController : UIViewController <GameCenterManagerDelegate, UIAccelerometerDelegate>{
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
    int notificationTimer;
    CGPoint notificationDirection;
    
    Hero *hero;
    ScoreManager *scoreManager;
    AccelerometerManager *accelerometerManager;
    
    Timer *timer;
    
    GameCenterManager *gameCenterManager;
    
    int ringsCatched;
    NSMutableArray *rings;
    NSMutableArray *deadRings;
    UIImageView *drawImage;
    int incScoreTimeleft;
    Level *currentLevel;
    EgameState gameState;
    int drawLifes;
    int difficultyPourcentage;
    

}

-(void)tick;

//-(void) accelerometerTick:(int)accelerometerCount withAccelX:(float)accelX withAccelY:(float)accelY withAcceleration:(UIAcceleration*)acceleration;
-(void) resumeGame;
+(float) getAngleFromAcceleration:(UIAcceleration *)acceleration;
-(void) createRandomRing;
-(void) draw;
-(void) live;
-(void) gameOver;
-(IBAction)BARestart:(id)sender;
-(IBAction)BAHome:(id)sender;
-(IBAction)BANotification:(id)sender;



-(void) updateDynamicControlsAngle:(int)angle;
-(void) updateStaticControlsAngle:(int)angle;
-(void) initGame;

@property (nonatomic, strong, retain) Hero* hero; 
@property (nonatomic) CGPoint notificationDirection;
@property (nonatomic, retain) IBOutlet UIButton *BNotification;


@end

#endif
