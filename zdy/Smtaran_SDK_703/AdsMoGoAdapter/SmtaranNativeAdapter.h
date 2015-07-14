//
//  SmtaranNativeAdapter.h
//  test
//
//  Created by Castiel Chen on 15/1/21.
//  Copyright (c) 2015年 Castiel Chen. All rights reserved.
//

#import "AdMoGoNativeAdNetworkAdapter.h"
#import "SmtaranAdFactory.h"
#import "SmtaranNative.h"
#import "SmtaranSDKManager.h"
@interface SmtaranNativeAdapter : AdMoGoNativeAdNetworkAdapter<SmtaranAdFactoryDelegate>
{
    SmtaranAdFactory * nativeGroup;
}
@end
