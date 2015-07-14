//
//  AdMoGoAdapterSmtaranFullAd.h
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "SmtaranSDKManager.h"
#import "SmtaranInterstitialAd.h"


@interface AdMoGoAdapterSmtaranFullAd : AdMoGoAdNetworkInterstitialAdapter<SmtaranInterstitialAdDelegate>
{
    NSTimer *timer;
    BOOL isStop;
    BOOL isError;
    BOOL isReady;
    BOOL isPresent;
    SmtaranInterstitialAd *adPoster;
}
+ (AdMoGoAdNetworkType)networkType;

//+ (NSDictionary *)networkType;

- (void)loadAdTimeOut:(NSTimer*)theTimer;

@end
