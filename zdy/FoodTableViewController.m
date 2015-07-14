//
//  RecVideoTableViewController.m
//  zdy
//
//  Created by jackrex on 22/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "FoodTableViewController.h"
#import "VideoData.h"
#import <AFNetworking.h>
#import "FMDatabase.h"
#import "RecoAppsTableViewController.h"
#import <MobClick.h>
#import "AdMoGoInterstitial.h"
#import "AdMoGoInterstitialDelegate.h"
#import "AdMoGoInterstitialManager.h"


@interface FoodTableViewController ()<UITableViewDelegate,AdMoGoInterstitialDelegate>
{
    
    NSMutableArray *videoDatas;
    
    UIAlertView *alertDialog;
    UIAlertView *showUpdateDialog;
    
    NSString *upTitle;
    NSString *upT;
    NSString *upUrl;
    NSString *shouldUp;
    AdMoGoInterstitial *interstitialIns;
    BOOL canshow;
}
@end


@implementation FoodTableViewController

@synthesize dbFile;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"营养食谱";
    self.dbFile = @"cartegory2.db";
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item = [tabBar.items objectAtIndex:2];
    
    UIImage *imageNormal = [UIImage imageNamed:@"btn2"];
    UIImage *imageSelected = [UIImage imageNamed:@"btn_chose2"];
    
    item.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBar.tintColor = [UIColor colorWithRed:246.0/255.0 green:121.0/255.0 blue:147.0/255.0 alpha:1.0];
    
#pragma mark - navigationBar_UI
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    
#pragma mark - tableVIewData_get
    
    videoDatas = [[NSMutableArray alloc] init];
    
    
    
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
    
    NSString *queryStr =    [[NSString alloc] initWithFormat:@"select * FROM zhoutable where category = \"%@\"",self.title];
    
    FMResultSet *rs = [db executeQuery:queryStr];
    
    //NSLog(@"Select * FROM zhoutable Where category = \"%@\"",self.title);
    
    
    while ([rs next]) {
        
        
        VideoData *videoData = [VideoData new];
        
        videoData._id = [rs stringForColumn:@"id"];
        videoData.zhou = [rs stringForColumn:@"zhou"];
        videoData.category = [rs stringForColumn:@"category"];
        videoData.title = [rs stringForColumn:@"title"];
        videoData.content = [rs stringForColumn:@"content"];
        videoData.urlimage = [rs stringForColumn:@"urlimage"];
        
        [videoDatas addObject:videoData];
        
        
    }
    
    [db close];
    
  
    
    [MobClick updateOnlineConfig];
    upTitle = [MobClick getConfigParams:@"uptitle"];
    upUrl = [MobClick getConfigParams:@"upurl"];
    shouldUp = [MobClick getConfigParams:@"shouldup"];
    upT = [MobClick getConfigParams:@"upT"];
    
    NSString *clearUp = [MobClick getConfigParams:@"clearup"];
    if ([clearUp isEqualToString:@"yes"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"up"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    if ([shouldUp isEqualToString:@"yes"]&&![[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"]) {
        
        showUpdateDialog = [[UIAlertView alloc]initWithTitle:upT message:upTitle delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        
        [showUpdateDialog show];
        
    }else{
        showUpdateDialog = [[UIAlertView alloc]initWithTitle:@"精品推荐" message:@"最火最热的健身app 健身宝典，无广告更多精品内容，赶快去下载吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    }
    
    showUpdateDialog.delegate = self;
    
    
    
    [MobClick updateOnlineConfig];
    
    alertDialog   = [[UIAlertView alloc]initWithTitle:@"五星好评去广告开启更多功能" message:@"姐妹们给五星好评支持下我们，我们将为您去除广告（五星评价有效，重启后生效)，解锁更多功能，谢谢各位" delegate:self cancelButtonTitle:@"残忍拒绝" otherButtonTitles:@"欣然前往",nil];
    alertDialog.delegate = self;
    
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"areAdsRemoved"]){
        return;
    }
    if (APPDELEGATE.noads ) {
        return;
    }
    interstitialIns = [[AdMoGoInterstitialManager shareInstance] adMogoInterstitialByAppKey: MoGo_ID_IPhone isManualRefresh:NO];
    interstitialIns.delegate = self;
    canshow = YES;
    [self addNotification];

    
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

-(NSString *) getDBPath:(NSString *)dbfile
{
    
    NSString *tmpDir = NSTemporaryDirectory();
    return [tmpDir stringByAppendingPathComponent:dbfile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return videoDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reccell" forIndexPath:indexPath];
    
    VideoData *currentVideo = [videoDatas objectAtIndex:indexPath.row];
    UILabel *zhouLabel = (UILabel *)[cell viewWithTag:4];
    UIImageView *picImageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:3];
    
    NSString *imageName = [currentVideo.urlimage stringByReplacingOccurrencesOfString:@"engine/plug-in/zhouCaiDan/" withString:@""];
    
    picImageView.image = [UIImage imageNamed:imageName];
    
    //NSLog(@"picImageView:%@",currentVideo.urlimage);
    
    
    
    zhouLabel.text = [@"第" stringByAppendingString:currentVideo.zhou];
    zhouLabel.text = [zhouLabel.text stringByAppendingString:@"周"];
    titleLabel.text = currentVideo.title;
    contentLabel.text = currentVideo.content;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"success");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoData *currentVideo = [videoDatas objectAtIndex:indexPath.row];
    
    
    if (APPDELEGATE.israte && ![[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"] && indexPath.row > 6) {
        
        [alertDialog show];
        return;
        
    }
    
    
    
    RecoAppsTableViewController *videoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecoAppsTableViewController"];
    NSLog(@"zhou: %@",currentVideo.zhou);
    videoVC.zhou = currentVideo.zhou;
    videoVC.category = currentVideo.category;
    videoVC.dbFile = self.dbFile;
    [self.navigationController pushViewController:videoVC animated:YES];
    
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    
    if (alertView == showUpdateDialog) {
        
        
        switch (buttonIndex) {
            case 0:
                
                break;
                
            case 1:
                if (upUrl) {
                    
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:upUrl]];
                }else{
                    
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/jian-shen-bao-dian-nan-shi/id896046745?l=zh&ls=1&mt=8"]];
                }
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"up"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                break;
                
            default:
                break;
        }
        
        
        return;
        
    }
    
    
    
    if (APPDELEGATE.israte) {
        
        switch (buttonIndex) {
            case 1:
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:Appstore]];
                
                [self doremove];
                
                break;
        }
        
        
        
        
        return;
    }
    
    
    
    
}


-(void)doremove{
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 124;
    
}



@end
