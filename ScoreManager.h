//
//  ScoreManager.h
//  Boule2
//
//  Created by Pouya Mohtacham on 05/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreManager : NSObject{
    int score;
}

-(id)init;

@property (nonatomic) int score;
@end
