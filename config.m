//
//  config.m
//  Boule2
//
//  Created by Pouya Mohtacham on 20/06/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import "config.h"

@implementation config

+(UIFont*) getFontNotification{
    return [UIFont fontWithName:@"Trebuchet MS" size:24.0];
}

+(UIFont*) getFontScoreLabel{    
    return [UIFont fontWithName:@"Trebuchet MS" size:18.0];
}

+(UIFont*) getFontWithSize:(double)fontSize{    
    return [UIFont fontWithName:@"Trebuchet MS" size:fontSize];
}


@end
