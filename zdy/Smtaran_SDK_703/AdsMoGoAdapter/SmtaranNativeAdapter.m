//
//  SmtaranNativeAdapter.m
//  test
//
//  Created by Castiel Chen on 15/1/21.
//  Copyright (c) 2015年 Castiel Chen. All rights reserved.
//

#import "SmtaranNativeAdapter.h"
#import "AdsMogoNativeAdInfo.h"


@interface SmtaranNativeAdapter (){
    int requestCount;
    NSMutableArray * adArray;
    BOOL isTimerOut;
    AdsMogoNativeAdInfo* clickInfo;
}
@end



@implementation SmtaranNativeAdapter

+ (AdMoGoNativeAdNetworkType)networkType{
    return AdMoGoNativeAdNetworkTypeSmtaran;
}

+ (void)load {
    [[AdMoGoNativeRegistry sharedRegistry] registerClass:self];
}


- (void)loadAd:(int)adcount{
    isTimerOut =NO;
    adArray =[[NSMutableArray alloc]init];
    
    [[SmtaranSDKManager getInstance] setPublisherID:[self.appKeys objectForKey:@"PublisherID"] auditFlag:MS_Test_Audit_Flag];
    
    nativeGroup=[[SmtaranAdFactory alloc]init];
    nativeGroup.delegate=self;
//    nativeGroup.options=@{@"disableToLoad":@(YES)};//
    nativeGroup.capacity=adcount;//请求广告数量
    requestCount = adcount;
    [nativeGroup requestWithWidth:320.0f slotToken:[self.appKeys objectForKey:@"slotToken"] completion:nil];

}
//展示广告
-(void)attachAdView:(UIView*)view nativeData:(AdsMogoNativeAdInfo*)info{
    [super attachAdView:view nativeData:info];
    [view addSubview:[info valueForKey:AdsMoGoNativeMoGoPdata]];
    [view bringSubviewToFront:[info valueForKey:AdsMoGoNativeMoGoPdata]];
}
//点击广告
-(void)clickAd:(AdsMogoNativeAdInfo*)info{
    [super clickAd:info];
}
//请求广告超时
- (void)loadAdTimeOut:(NSTimer*)theTimer{
    isTimerOut =YES;
    [super loadAdTimeOut:theTimer];
    if (adArray&&adArray.count>1) {
        [self adMogoNativeSuccessAd:adArray];
    }else{
        [self adMogoNativeFailAd:-1];
    }
}



/**
 *  adFactory请求成功
 *  @param adNative
 */
-(void)smtaranAdFactorySuccessToRequest:(SmtaranAdFactory*) adFactory{
    NSArray *array = adFactory.adViews;
    for(id smtarannative in array){
        if ([smtarannative isKindOfClass:[SmtaranNative class]]) {
            SmtaranNative * adNative = (SmtaranNative *)smtarannative;
            AdsMogoNativeAdInfo *adsMogoNativeInfo =[[AdsMogoNativeAdInfo alloc]init];
            [adsMogoNativeInfo setValue:[adNative.content objectForKey:@"title"] forKey:AdsMoGoNativeMoGoTitle];
            [adsMogoNativeInfo setValue:[adNative.content objectForKey:@"logo"] forKey:AdsMoGoNativeMoGoIconUrl];
            [adsMogoNativeInfo setValue:[adNative.content objectForKey:@"desc"] forKey:AdsMoGoNativeMoGoDesc];
            [adsMogoNativeInfo setValue:[adNative.content objectForKey:@"image"] forKey:AdsMoGoNativeMoGoImageUrl];
            [adsMogoNativeInfo setValue:adNative forKey:AdsMoGoNativeMoGoPdata];
            [adsMogoNativeInfo setValue:[self getMogoJsonByDic:adsMogoNativeInfo] forKey:AdsMoGoNativeMoGoJsonStr];
            [adArray addObject:adsMogoNativeInfo];
            [adsMogoNativeInfo release];
            if (requestCount==[adArray count]) {
                [self adMogoNativeSuccessAd:adArray];
                break;
            }

        }
    }
    
}

/**
 *  adFactory请求失败
 *  @param adFactory
 */
-(void)smtaranAdFactoryFaildToRequest:(SmtaranAdFactory*) adFactory withError:(NSError*) error{
    [self adMogoNativeFailAd:-1];
}


#pragma mark -
#pragma mark - SmtaranNativeDelegate
-(void)smtaranNativeClick:(SmtaranNative *)adNative
{
    if (clickInfo) {
        [clickInfo release],clickInfo =nil;
    }
    clickInfo =[[AdsMogoNativeAdInfo alloc]init];
    [clickInfo setValue:[adNative.content objectForKey:@"title"] forKey:AdsMoGoNativeMoGoTitle];
    [clickInfo setValue:[adNative.content objectForKey:@"logo"] forKey:AdsMoGoNativeMoGoIconUrl];
    [clickInfo setValue:[adNative.content objectForKey:@"desc"] forKey:AdsMoGoNativeMoGoDesc];
    [clickInfo setValue:[adNative.content objectForKey:@"image"] forKey:AdsMoGoNativeMoGoImageUrl];
    [clickInfo setValue:adNative forKey:AdsMoGoNativeMoGoPdata];
    [clickInfo setValue:[self getMogoJsonByDic:clickInfo] forKey:AdsMoGoNativeMoGoJsonStr];
    [self clickAd:clickInfo];
}
-(void)smtaranNativeAppeared:(SmtaranNative *)adNative
{
    NSLog(@" --------smtaranNativeAppeared:(%@)",adNative.content[@"id"]);
    
    
}


-(void)dealloc{
    if (nativeGroup) {
        [nativeGroup release],nativeGroup=nil;
    }
    
    if(clickInfo){
        [clickInfo release],clickInfo=nil;
    }
    [super dealloc];
}


@end
