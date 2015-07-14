//
//  FDefine.h
//  forhealth
//
//  Created by jackrex on 2/12/14.
//  Copyright (c) 2014 JackRex. All rights reserved.
//

#ifndef forhealth_FDefine_h
#define forhealth_FDefine_h
#import "ZAppDelegate.h"
#import "FUtils.h"
#import <SVProgressHUD.h>


#define MoGo_ID_IPhone @"fc8a655884fd4d829585fe3f6fe37b8f"

#define UM_Key @"550d405f56240bc46f000262"

//app about
#define APPNAME @"孕期宝贝"
#define APPID @"978970956"

#define ADKEYWORD @"孕期，孕妇，孕妇餐，宝宝，食谱"

//appstore
#define APPAUTHOR @"LiZhang"

#define Appstore @"https://itunes.apple.com/us/app/yun-qi-bao-bei-yun-fu-zhu/id978970956?l=zh&ls=1&mt=8"


#define CURRENT_EXE @"current_exe" //存取当前进度
//userdefaults key
#define REMINDTIME @"remindtime"
#define SHOULDREMIND @"shouldremind"
#define REMINDTEXT @"remindtext"


//iOS Common Helper
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define ScreenSize ([[UIApplication sharedApplication] keyWindow].frame.size)
#define APPDELEGATE ((ZAppDelegate *)[UIApplication sharedApplication].delegate)
#define MANAGEDCONTEXT ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext

#define NAVGATIONBARCOLOR           [UIColor colorWithRed:65/255. green:65/255. blue:70/255. alpha:1.0]
#define CCBLACKCOLOR [UIColor colorWithRed:63/255.0 green:66/255.0 blue:69/255.0 alpha:1]
#define CCGRAYCOLOR  [UIColor colorWithRed:103/255.0 green:109/255.0 blue:114/255.0 alpha:1]
#define TOPCOLOR      @"2580c2"
#define UI_SCREEN_HEIGHT            [[UIScreen mainScreen] bounds].size.height
#define USERDEFAULTS [NSUserDefaults standardUserDefaults]
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define UIIMAGE(imageName) [UIImage imageNamed:imageName]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define TABLEVIEWFRAME (IOS7_OR_LATER?CGRectMake(0, 20+44, SCREENWIDTH, SCREENHEIGHT-20-44-49):CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-44-20-49))

//



#endif
