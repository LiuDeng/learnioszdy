//
//  BooksDetailViewController.m
//  Stock
//
//  Created by JackRex on 5/23/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "BooksDetailViewController.h"
#import <CoreData/CoreData.h>
#import "SVProgressHUD.h"
#import "AdMoGoInterstitial.h"
#import "AdMoGoInterstitialDelegate.h"
#import "AdMoGoInterstitialManager.h"
@interface BooksDetailViewController ()<AdMoGoDelegate,AdMoGoWebBrowserControllerUserDelegate,AdMoGoInterstitialDelegate>{
    NSString *loadString;
    AdMoGoInterstitial *interstitialIns;
    BOOL canshow;
}
@property (weak, nonatomic) IBOutlet UIWebView *booksDetailWebView;
@property (retain, nonatomic) NSString *htmlStr;
@end

@implementation BooksDetailViewController
@synthesize content;
- (void)viewDidLoad {
    [super viewDidLoad];
    loadString = @"";
    self.htmlStr = [[NSString alloc] initWithFormat:@"</div><br />%@<br />",content];
    NSArray *arrays = [self.htmlStr componentsSeparatedByString:@"\n"];
    for (NSString *str in arrays) {
        NSString *htmlStr = [[@"<p>" stringByAppendingString:str] stringByAppendingString:@"</p>"];
        loadString = [loadString stringByAppendingString:htmlStr];
    }
    [self.booksDetailWebView loadHTMLString:loadString baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]]];
    UIScrollView *tempView=(UIScrollView *)[self.booksDetailWebView.subviews objectAtIndex:0];
    [tempView setShowsVerticalScrollIndicator:NO];

    [self loadAds];
}

-(void)loadAds{
    interstitialIns = [[AdMoGoInterstitialManager shareInstance] adMogoInterstitialByAppKey: MoGo_ID_IPhone isManualRefresh:NO];
    interstitialIns.delegate = self;
    canshow = YES;
    [self addNotification];
}

-(BOOL)hasSaved:(NSString *)name{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    // 1. 实例化一个查询(Fetch)请求
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"List"];
    
    
    
    // 3. 条件查询，通过谓词来实现的
    
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@",name];
    // 2. 让_context执行查询数据
    
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:nil];
    if (array.count) {
        
        return YES;
    }
    
    return NO;
    
    
}




- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
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
