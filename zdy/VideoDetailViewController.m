//
//  VideoDetailViewController.m
//  zdy
//
//  Created by jackrex on 24/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "FMDatabase.h"
#import <AFNetworking/AFNetworking.h>
@import GoogleMobileAds;
#import <MobClick.h>
#define HOST @"http://api.flvxz.com/site/youku/vid/"


@interface VideoDetailViewController ()<GADBannerViewDelegate,GADInterstitialDelegate>
{
    
    
    __weak IBOutlet UILabel *titleLabel;
    
    
    __weak IBOutlet UIWebView *weburlWebview;
    
    
    GADInterstitial *interstitial_;


}

@property  GADBannerView *banner;


@end

@implementation VideoDetailViewController
@synthesize _id;
@synthesize dbFile;


@synthesize banner;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"success");
    self.title = @"详情内容";
    
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *dbpath = [self getDBPath:self.dbFile];
    BOOL success = [fileManager fileExistsAtPath:dbpath];
    
    if(!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.dbFile];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbpath error:&error];
        
        
        
        
        
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        // error
        return;
    }
    
    NSString *queryStr =    [[NSString alloc] initWithFormat:@"select * FROM article where id = \"%@\"",_id];
    
    FMResultSet *rs = [db executeQuery:queryStr];
    
    //NSLog(@"Select content FROM article Where title = '%@'",titleName);
        
    [rs next];
    
    titleLabel.text = [rs stringForColumn:@"title"];
    
    NSLog(@"titleLabel.text:%@",titleLabel.text);
    
    //不明白baseURL传入的这个参数，html的资源在upload里
    
    NSString *htmlStr = [[rs stringForColumn:@"content"] stringByReplacingOccurrencesOfString:@"upload/" withString:@""];

    
    [weburlWebview loadHTMLString:htmlStr baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]]];
        
    
        
   
    
    [db close];
    
    
    
    
//    if (!UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom) {
//        
//        banner = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
//        
//        
//    }else{
//        
//        banner = [[GADBannerView alloc]initWithAdSize:kGADAdSizeLeaderboard];
//        
//        
//    }
//   
//    banner.adUnitID = GOOGLEADSBANNERKEY;
//    
//    
//    banner.rootViewController = self;
//    
//    
//    if([[NSUserDefaults standardUserDefaults] valueForKey:@"areAdsRemoved"]){
//        return;
//    }
//    
//    
//    if (APPDELEGATE.noads ) {
//        return;
//    }
//  
//    [self.view addSubview:banner];
//    [banner setDelegate:self];
//    GADRequest *request = [GADRequest request];
//    [banner loadRequest:request];
//    
//    interstitial_ = [[GADInterstitial alloc] init];
//    interstitial_.adUnitID = GOOGLEADSADPOSTERKEY;
//    [interstitial_ loadRequest:[GADRequest request]];
//    interstitial_.delegate = self;



    
}

#pragma mark - MobiSageAdViewDelegate 委托
#pragma mark
- (UIViewController *)viewControllerToPresent
{
    return self;
}



- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [UIView beginAnimations:@"BannerSlide" context:nil];
    
    
    
    
    
    bannerView.frame = CGRectMake((SCREENWIDTH - bannerView.frame.size.width)/2,
                                  0,
                                  bannerView.frame.size.width,
                                  bannerView.frame.size.height);
    

    [UIView commitAnimations];
}


-(void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    
    
   
    
    if (APPDELEGATE.isadposter && ![[NSUserDefaults standardUserDefaults] valueForKey:@"areAdsRemoved"]) {
        
        [interstitial_ presentFromRootViewController:self];
        
        return;
        
    }
    
    
    
    
    
}


-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{
    
    
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
    
}





-(NSString *) getDBPath:(NSString *)dbfile
{
    
    NSString *tmpDir = NSTemporaryDirectory();
    return [tmpDir stringByAppendingPathComponent:dbfile];
    
}






-(void)moviePlayerPreloadFinish:(NSNotification*)notification{
    //添加你的处理代码
    
    
    
    
}




@end
