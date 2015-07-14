//  File: AdMoGoAdapterSmtaran.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//  Copyright 2011 AdsMogo.com. All rights reserved.


#import "AdMoGoAdapterSmtaran.h"
//#import "AdMoGoView.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKBannerNetworkRegistry.h"



@implementation AdMoGoAdapterSmtaran

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeSmtaran;
}

+(void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    isStopTimer = NO;
    isSuccess = NO;
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
	[adMoGoCore adapter:self didGetAd:@"Smtaran"];

    AdViewType type =[configData.ad_type intValue];
    NSString *publishID = [[self.ration objectForKey:@"key"] objectForKey:@"PublisherID"];
    [[SmtaranSDKManager getInstance] setPublisherID:publishID
     auditFlag:nil];
 
    NSString *slotToken = [[self.ration objectForKey:@"key"] objectForKey:@"slotToken"];
//    NSLog(@"pulishID %@,slotToken %@",publishID,slotToken);
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            adView = [[SmtaranBannerAd alloc]initBannerAdSize:SmtaranBannerAdSizeNormal delegate:self slotToken:slotToken];
            
            [adView setBannerAdAnimeType:SmtaranBannerAdAnimationTypeNone];
            [adView setBannerAdRefreshTime:SmtaranBannerAdRefreshTimeNone];
            break;
        case AdViewTypeLargeBanner:
            
            adView = [[SmtaranBannerAd alloc]initBannerAdSize:SmtaranBannerAdSizeLarge delegate:self slotToken:slotToken];
            
            [adView setBannerAdAnimeType:SmtaranBannerAdAnimationTypeNone];
            [adView setBannerAdRefreshTime:SmtaranBannerAdRefreshTimeNone];
                       break;
        default:
            MGLog(MGD, @"smtaran 对这种广告形式不支持");
            break;
    }
    
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
          timer = [[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    self.adNetworkView = adView;
    [adView release];
}

- (void)stopBeingDelegate {
    
    adView.delegate = nil;
    
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    [self stopTimer];
}

- (void)stopTimer {
    if (!isStopTimer) {
        isStopTimer = YES;
    }else{
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)dealloc {
    isStop = YES;
    adView.delegate = nil;
	[super dealloc];
}

- (BOOL)isSDKSupportClickDelegate{
    return YES;
}

#pragma mark -
#pragma mark SmtaranBannerAdDelegate method

- (UIViewController *)viewControllerToPresent{
    return [self.adMoGoDelegate viewControllerForPresentingModalView];
}


//横幅广告被点击时,触发此回调方法,用于统计广告点击数
- (void)smtaranBannerAdClick:(SmtaranBannerAd*)adBanner
{
    MGLog(MGD, @"艾德思奇横幅广告被点击");
    [adMoGoCore sdkplatformSendCLK:self];
}

//横幅广告成功展示时,触发此回调方法,用于统计广告展示数
- (void)smtaranBannerAdSuccessToShowAd:(SmtaranBannerAd *)adBanner
{
    MGLog(MGD, @"艾德思奇横幅广告展示成功");
    if (isSuccess) {
        return;
    }
    isSuccess = YES;
    if (isStop) {
        return;
    }
    [self stopTimer];
//    self.adNetworkView.backgroundColor =[UIColor redColor];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.adNetworkView];
 
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];

}

//横幅广告展示失败时,触发此回调方法
- (void)smtaranBannerAdFaildToShowAd:(SmtaranBannerAd *)adBanner withError:(NSError *)error
{
    MGLog(MGE, @"艾德思奇横幅广告展示失败 %@",error);
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:error];
}

//横幅广告点击后,打开 LandingSite 时,触发此回调方法,请勿释放横幅广告
- (void)smtaranBannerAdPopADWindow:(SmtaranBannerAd*)adBanner
{
    MGLog(MGD, @"艾德思奇横幅广告打开LandingSite");
    if (isStop) {
        return;
    }
    [adMoGoCore stopTimer];
    [self helperNotifyDelegateOfFullScreenModal];
 
}

//关闭 LandingSite 回到应用界面时,触发此回调方法
- (void)smtaranBannerAdHideADWindow:(SmtaranBannerAd*)adBanner
{
    MGLog(MGD, @"艾德思奇横幅广告关闭LandingSite");
    if (isStop) {
        return;
    }
    [adMoGoCore fireTimer];
    [self helperNotifyDelegateOfFullScreenModalDismissal];

}



@end
