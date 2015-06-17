//
//  AppDelegate.m
//  zdy
//
//  Created by jackrex on 21/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "ZAppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import <MobClick.h>
#import <Appirater.h>
#import <UMFeedback.h>

@interface ZAppDelegate ()

@end

@implementation ZAppDelegate
@synthesize isadposter;
@synthesize noads;
@synthesize israte;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self initAppearence];
    [self initAVOS:launchOptions];
    [self initUmeng];
    
    
    return YES;
}


-(void)initAVOS:(NSDictionary *)launchOptions{
    
    //如果使用美国站点，请加上这行代码 [AVOSCloud useAVCloudUS];
    [AVOSCloud setApplicationId:@"d6x9bufsokutgsfhizy33qo2fzedmzaoanozw1vscjyzg2ar"
                      clientKey:@"npeodupjvfu7eefj5doo3wyv543lgbqgmvk87ykxkofb3w4z"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    
}

-(void)initUmeng{
    

    //Umeng
    [MobClick startWithAppkey:UM_Key];
    [MobClick checkUpdate];
    [UMFeedback setAppkey:UM_Key];
    //[UMFeedback setLogEnabled:YES];

    [Appirater setAppId:APPID];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:2];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:1];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
    
    AVQuery *query = [AVQuery queryWithClassName:@"adcontrol"];
    AVObject *gameScore = [query getObjectWithId:@"5580bf56e4b0a83febeaadd0"];
    NSString *para = [gameScore valueForKey:@"adcontrol"];
    if (para) {
        NSData *data = [para dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([[json objectForKey:@"adposter"] isEqualToString:@"yes"]) {
            isadposter = YES;
        }
        if ([[json objectForKey:@"rate"] isEqualToString:@"yes"]) {
            israte = YES;
        }
        if ([[json objectForKey:@"noads"] isEqualToString:@"yes"]) {
            noads = YES;
        }
    }
    
    
    
}


-(void)initAppearence{
    
    [[UINavigationBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:246.0/255.0 green:121.0/255.0 blue:147.0/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:246.0/255.0 green:121.0/255.0 blue:147.0/255.0 alpha:1.0]];

    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.27 green:0.71 blue:0.36 alpha:1]];
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (IOS8_OR_LATER) {
        
        [[UITabBar appearance] setTranslucent:NO];

    }
    
    
    
    
    
    
}


- (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.dracarys.zdy" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"zdy" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"zdy.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
