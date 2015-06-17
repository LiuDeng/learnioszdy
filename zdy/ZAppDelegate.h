//
//  AppDelegate.h
//  zdy
//
//  Created by jackrex on 21/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@property (nonatomic) BOOL noads;
@property (nonatomic) BOOL isadposter;
@property (nonatomic) BOOL israte;
@property (nonatomic) BOOL isAll;

@end

