//
//  CustomTabBarViewController.m
//  Stock
//
//  Created by jackrex on 23/5/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"
#import "AdMoGoInterstitial.h"
#import "AdMoGoInterstitialDelegate.h"
#import "AdMoGoInterstitialManager.h"
@interface CustomTabBarViewController ()<AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate,AdMoGoInterstitialDelegate>
{
    AdMoGoView *adView;
    AdMoGoInterstitial *interstitialIns;
    BOOL canshow;
}
@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAds];
}

-(void)loadAds{
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        adView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone
                                             adType:AdViewTypeNormalBanner adMoGoViewDelegate:self];
    }else{
        adView = [[AdMoGoView alloc] initWithAppKey:MoGo_ID_IPhone
                                             adType:AdViewTypeNormalBanner adMoGoViewDelegate:self];
    }
    adView.adWebBrowswerDelegate = self;
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        
        adView.frame = CGRectMake(SCREENWIDTH/2 -160, SCREENHEIGHT - 49 - 50, self.view.frame.size.width, 50);
    }else{
        adView.frame = CGRectMake(0, SCREENHEIGHT - 49 - 50, self.view.frame.size.width, 50);
    }
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"areAdsRemoved"]){
        return;
    }
    if (APPDELEGATE.noads ) {
        return;
    }
    interstitialIns = [[AdMoGoInterstitialManager shareInstance] adMogoInterstitialByAppKey: MoGo_ID_IPhone isManualRefresh:YES];
    interstitialIns.delegate = self;
    canshow = YES;
    [self addNotification];
    adView.delegate = self;
    [self.view addSubview:adView];

}

/**
 * 广告开始请求回调
 */
- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告开始请求回调");
}
/**
 * 广告接收成功回调
 */
- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告接收成功回调");
    
}
/**
 * 广告接收失败回调
 */
- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error{
    NSLog(@"广告接收失败回调");
}
/**
 * 点击广告回调
 */
- (void)adMoGoClickAd:(AdMoGoView *)adMoGoView{
    NSLog(@"点击广告回调");
    
}
/**
 *You can get notified when the user delete the ad
 广告关闭回调
 */
- (void)adMoGoDeleteAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告关闭回调");
    adView.hidden = YES;
    
}

#pragma mark -
#pragma mark AdMoGoWebBrowserControllerUserDelegate delegate

/*
 浏览器将要展示
 */
- (void)webBrowserWillAppear{
    NSLog(@"浏览器将要展示");
}

/*
 浏览器已经展示
 */
- (void)webBrowserDidAppear{
    NSLog(@"浏览器已经展示");
}

/*
 浏览器将要关闭
 */
- (void)webBrowserWillClosed{
    NSLog(@"浏览器将要关闭");
}

/*
 浏览器已经关闭
 */
- (void)webBrowserDidClosed{
    NSLog(@"浏览器已经关闭");
}
/**
 *直接下载类广告 是否弹出Alert确认
 */
-(BOOL)shouldAlertQAView:(UIAlertView *)alertView{
    return NO;
}

- (void)webBrowserShare:(NSString *)url{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark AdMoGoDelegate delegate
/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingModalView{
    return self;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationPortrait|UIInterfaceOrientationLandscapeRight;
}

-(BOOL)shouldAutorotate{
    
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
/*
 全屏广告消失
 */
- (void)adsMoGoInterstitialAdDidDismiss{
    
    NSLog(@"dismiss interstitial");
    
    
}

- (UIViewController *)viewControllerForPresentingInterstitialModalView{
    return self;
}

- (BOOL)adsMogoInterstitialAdDidExpireAd{
    return YES;
}


-(void)showInterstitial{
    
    NSLog(@"show interstitial");
    
    if (APPDELEGATE.isadposter) {
        
        [[AdMoGoInterstitialManager shareInstance] interstitialShow:YES];
        
    }
    
    
}


-(void)adsMoGoInterstitialAdWillPresent{
    
    NSLog(@"will present");
    
}


- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusDidChange:) name:@"AdMoGoInterstitialStatusChangeNotification"
                                               object:nil];
    
}

- (void)removeNotification{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (void)statusDidChange:(NSNotification *)notification{
    
    NSLog(@"state change");
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *appKey = [userInfo objectForKey:@"appKey"];
    
    
    NSString *text = [self titleByStatusCode:[[userInfo objectForKey:@"status"] intValue]];
    
    NSLog(text);
    
}

#pragma mark -
#pragma mark AdMoGoInterstitialDelegate method

- (void)adMoGoInterstitialInitFinish{
    NSLog(@" inter init finished");
}

- (void)adMoGoInterstitialInMaualfreshAllAdsFail{
    //    [self freshadBtnAction:nil];
    NSLog(@" inter load failed");
}

- (NSString *)titleByStatusCode:(int)scode{
    NSString *title = @"未知";
    switch (scode) {
        case 0:
            title = @"轮换中";
            break;
        case 1:
            title = @"等展示";
            if(canshow){
            canshow = false;
             [interstitialIns interstitialShow:YES];
            }
            break;
        case 2:
            title = @"展示中";
            break;
        case 3:
            title = @"等重启";
            break;
        case 4:
            title = @"已过期";
            break;
        case 5:
            title = @"已销毁";
            break;
        default:
            break;
    }
    
    return title;
    
}

/** 
 *退出展示时机   *如果您之前进入了展示时机,并且isWait参数设置为YES,那么在需要取消等 待广告展示的 
 *时候调用方法-  (void)interstitialCancel;来通知SDK 
 */
- (void)cancelShow{
    [[AdMoGoInterstitialManager shareInstance] interstitialCancel];
}
#pragma mark - MobiSageAdViewDelegate 委托
#pragma mark
- (UIViewController *)viewControllerToPresent
{
    return self;
}

-(void)viewDidDisappear:(BOOL)animated{
    AdMoGoInterstitial *interstitial = [[AdMoGoInterstitialManager shareInstance] adMogoInterstitialByAppKey:MoGo_ID_IPhone];
    interstitial.delegate = nil;
    [[AdMoGoInterstitialManager shareInstance] removeInterstitialInstanceByAppKey:MoGo_ID_IPhone];
}

- (void)viewDidUnload{
    [self removeNotification];
}
@end
