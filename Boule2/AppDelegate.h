//
//  AppDelegate.h
//  Boule2
//
//  Created by Aurelien Gasser on 1/7/12.
//  Copyright (c) 2012 origamix.fr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"
#import "RootViewController.h"
#import "NavigationController.h"
#import "GameCenterManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
//    UIWindow *window;
//    ViewController *viewController;
    NavigationController *navigationController;
}


@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//@property (nonatomic, retain) ViewController  *viewController;
@property (nonatomic, retain) IBOutlet NavigationController *navigationController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
