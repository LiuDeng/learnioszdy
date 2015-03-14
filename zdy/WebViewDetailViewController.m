//
//  WebViewDetailViewController.m
//  zdy
//
//  Created by jackrex on 22/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "WebViewDetailViewController.h"
@import GoogleMobileAds;
#import <MobClick.h>

@interface WebViewDetailViewController ()<GADInterstitialDelegate>
{
    
    
    IBOutlet UIWebView *uiwebview;
    GADInterstitial *interstitial_;

}
@end



@implementation WebViewDetailViewController
@synthesize content;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详情页面";
    
    NSString *truecon = @"";
    NSArray *array = [content componentsSeparatedByString:@"\n"];
    for (int i = 0; i <array.count; i++) {
        NSString *temstr = [array objectAtIndex:i] ;
        truecon = [truecon stringByAppendingString:[@"<p>" stringByAppendingString:[ temstr stringByAppendingString:@"</p>"]]];
    }
    
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = GOOGLEADSADPOSTERKEY;
    [interstitial_ loadRequest:[GADRequest request]];
    interstitial_.delegate = self;
    [uiwebview loadHTMLString:truecon baseURL:nil];
    
}

-(void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    

    
    if (APPDELEGATE.isadposter && ![[NSUserDefaults standardUserDefaults] valueForKey:@"areAdsRemoved"]) {
        
        [interstitial_ presentFromRootViewController:self];
        
        return;
        
    }

    
}

- (UIViewController *)viewControllerToPresent
{
    return self;
}



@end
