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
#import "AdMoGoInterstitial.h"
#import "AdMoGoInterstitialDelegate.h"
#import "AdMoGoInterstitialManager.h"
#import <MobClick.h>
#define HOST @"http://api.flvxz.com/site/youku/vid/"


@interface VideoDetailViewController ()<AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate,AdMoGoInterstitialDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIWebView *weburlWebview;
    AdMoGoInterstitial *interstitialIns;
    BOOL canshow;

}

@end

@implementation VideoDetailViewController
@synthesize _id;
@synthesize dbFile;

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
    
    //titleLabel.textColor = [UIColor colorWithRed:246.0/255.0 green:121.0/255.0 blue:147.0/255.0 alpha:1.0];
    
    NSLog(@"titleLabel.text:%@",titleLabel.text);
    
    //不明白baseURL传入的这个参数，html的资源在upload里
    
    NSString *htmlStr = [[rs stringForColumn:@"content"] stringByReplacingOccurrencesOfString:@"upload/" withString:@""];

    
    [weburlWebview loadHTMLString:htmlStr baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]]];
        
    
    [self loadAds];
   
    
    [db close];
    
    
    
   
    
}

#pragma mark - MobiSageAdViewDelegate 委托
#pragma mark
- (UIViewController *)viewControllerToPresent
{
    return self;
}

-(void)loadAds{
    interstitialIns = [[AdMoGoInterstitialManager shareInstance] adMogoInterstitialByAppKey: MoGo_ID_IPhone isManualRefresh:YES];
    interstitialIns.delegate = self;
    canshow = YES;
    [self addNotification];
}




-(NSString *) getDBPath:(NSString *)dbfile
{
    
    NSString *tmpDir = NSTemporaryDirectory();
    return [tmpDir stringByAppendingPathComponent:dbfile];
    
}






-(void)moviePlayerPreloadFinish:(NSNotification*)notification{
    //添加你的处理代码
    
    
    
    
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
                
                if (!APPDELEGATE.noads) {
                    
                    
                    if (APPDELEGATE.isadposter) {
                        [interstitialIns interstitialShow:YES];
                        
                    }
                }
                
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

-(void)viewDidDisappear:(BOOL)animated{
    AdMoGoInterstitial *interstitial = [[AdMoGoInterstitialManager shareInstance] adMogoInterstitialByAppKey:MoGo_ID_IPhone];
    interstitial.delegate = nil;
    [[AdMoGoInterstitialManager shareInstance] removeInterstitialInstanceByAppKey:MoGo_ID_IPhone];
}

- (void)viewDidUnload{
    [self removeNotification];
}


@end
