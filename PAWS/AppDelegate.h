//
//  AppDelegate.h
//  PAWS
//
//  Created by Zinan Xing on 9/21/54 BE.
//  Copyright Pulse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GameManager.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> 
{
	UIWindow			*window;
	RootViewController	*viewController;
    
    GameManager *gameManager;
    
    NSUndoManager *undoManager;
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) GameManager *gameManager;
@property (nonatomic, retain) NSUndoManager *undoManager;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
- (void)saveContext;

@end
