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



#define GOOGLEADSBANNERKEY @"ca-app-pub-5837066748747035/4941943304"
#define GOOGLEADSADPOSTERKEY @"ca-app-pub-5837066748747035/6418676509"

#define UM_Key @"54e73ad1fd98c550290004bd"

//app about
#define APPNAME @"热辣健身Pro"
#define APPID @"970315954"



//appstore
#define APPAUTHOR @"LiZhang"

#define Appstore @"https://itunes.apple.com/us/app/zheng-duo-yan-zhuan-ye-jian/id970315954?l=zh&ls=1&mt=8"
#define VIP @"https://itunes.apple.com/us/app/zheng-duo-yan-zhuan-ye-jian/id970315954?l=zh&ls=1&mt=8"



#define CURRENT_EXE @"current_exe" //存取当前进度
//userdefaults key
#define REMINDTIME @"remindtime"
#define SHOULDREMIND @"shouldremind"
#define REMINDTEXT @"remindtext"
#define COLORINDEX @"colorindex"
#define MUSICINDEX @"musicindex"





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
