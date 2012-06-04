//
//  LevelOptions.h
//  Boule2
//
//  Created by Pouya Mohtacham on 04/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelOptions : NSObject{

    int ringSizeFromBoule;
    int ringSizeFromBouleRandomDistribution;
    int timeBetweenRing;
    int timeBetweenRingRandomDistribution;
    int ringLife;

    
}

@property (nonatomic) int ringSizeFromBoule;
@property (nonatomic) int ringSizeFromBouleRandomDistribution;
@property (nonatomic) int timeBetweenRing;
@property (nonatomic) int timeBetweenRingRandomDistribution;
@property (nonatomic) int ringLife;

@end
