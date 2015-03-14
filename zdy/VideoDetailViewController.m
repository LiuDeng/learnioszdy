//
//  VideoDetailViewController.m
//  zdy
//
//  Created by jackrex on 24/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "VideoDetailViewController.h"
#import <AFNetworking/AFNetworking.h>
@import GoogleMobileAds;
#import <MobClick.h>
#define HOST @"http://api.flvxz.com/site/youku/vid/"


@interface VideoDetailViewController ()<GADBannerViewDelegate,GADInterstitialDelegate>
{
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UIImageView *videobg;
    
    NSString *videourl;
    GADInterstitial *interstitial_;


}

@property  GADBannerView *banner;

@end

@implementation VideoDetailViewController
@synthesize _id;
@synthesize moviePlayer;
@synthesize titlename;
@synthesize banner;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleLabel.text = titlename;
    self.title = @"视频详情";
    
    
    
    
    if (!UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom) {
        
        banner = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
        
        
    }else{
        
        banner = [[GADBannerView alloc]initWithAdSize:kGADAdSizeLeaderboard];
        
        
    }
   
    banner.adUnitID = GOOGLEADSBANNERKEY;
    
    
    banner.rootViewController = self;
    
    [self httpgetvideo:_id];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"areAdsRemoved"]){
        return;
    }
    
    
    if (APPDELEGATE.noads ) {
        return;
    }
  
    [self.view addSubview:banner];
    [banner setDelegate:self];
    GADRequest *request = [GADRequest request];
    [banner loadRequest:request];
    
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = GOOGLEADSADPOSTERKEY;
    [interstitial_ loadRequest:[GADRequest request]];
    interstitial_.delegate = self;



    
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

- (IBAction)playvideo:(id)sender {
    
    
    [self videoPlayerPlay:videourl];
    
    
}


-(void)httpgetvideo:(NSString *)_idlocal{
    
    //SVProgressHU网络请求
    [SVProgressHUD showWithStatus:@""];
    
    NSString *requestUrl = [[HOST stringByAppendingString:_idlocal] stringByAppendingString:@"/jsonp/purejson/token/fd85daf8d89781733cf3f36a82b76fd1"];
    
    NSLog(@"requestUrl:%@",requestUrl);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [SVProgressHUD dismiss];
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            NSArray *resp = responseObject;
            
            NSDictionary *forpicdic = [resp objectAtIndex:0];
            if ([forpicdic objectForKey:@"img"]) {
                
                NSString *imageurl = [forpicdic objectForKey:@"img"];
                
                [FUtils setImage:imageurl withImageView:videobg withHeight:336 withWidth:448];
                
                
            }
            
            NSDictionary *results = [resp objectAtIndex:resp.count-1];
            NSArray *files = [results objectForKey:@"files"];
            NSDictionary *video = [files objectAtIndex:0];
            NSString *furl = [video objectForKey:@"furl"];
            videourl = furl;
            
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"加载失败,请检查网络重新尝试"];
    }];
    
    
    
}


- (void)videoPlayerPlay:(NSString *)playurl {
    moviePlayer = [[DirectionMPMoviePlayer alloc] initWithContentURL: [NSURL URLWithString:playurl]];
    moviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    moviePlayer.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;//全屏播放（全屏播放不可缺）
    CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI / 2);
    moviePlayer.view.transform = landscapeTransform;
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [ notificationCenter addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:[moviePlayer moviePlayer] ];
    [notificationCenter addObserver:self selector:@selector(playbackStateChanged) name:MPMoviePlayerPlaybackStateDidChangeNotification object:[moviePlayer moviePlayer]];
    [self presentModalViewController:moviePlayer animated:YES];
    [[moviePlayer moviePlayer] play];
}



- (void) playbackStateChanged {
    
    if ( [moviePlayer moviePlayer].playbackState == MPMoviePlaybackStatePaused) {
        
        
    };
    
    
    if ( [moviePlayer moviePlayer].playbackState == MPMoviePlaybackStatePlaying) {
        
    }
    ;
    
    
}



-(void)movieFinishedCallback:(NSNotification*)notification{
    //添加你的处理代码
    
    if ([moviePlayer moviePlayer]) {
        [ [moviePlayer moviePlayer] pause];
        moviePlayer = nil;
    }
    
    
    
}






-(void)moviePlayerPreloadFinish:(NSNotification*)notification{
    //添加你的处理代码
    
    
    
    
}




@end
