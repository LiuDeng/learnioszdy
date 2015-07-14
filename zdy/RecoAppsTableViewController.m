//
//  RecoAppsTableViewController.m
//  zdy
//
//  Created by jackrex on 24/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "RecoAppsTableViewController.h"
#import <SDWebImageManager.h>
#import "KnowData.h"
#import <AFNetworking.h>
#import "FMDatabase.h"
#import <MobClick.h>
#import <RETableViewManager.h>
#import "VideoDetailViewController.h"
#import "AdMoGoInterstitial.h"
#import "AdMoGoInterstitialDelegate.h"
#import "AdMoGoInterstitialManager.h"
@interface RecoAppsTableViewController ()<UITableViewDelegate, AdMoGoInterstitialDelegate>
{
    NSMutableArray *knowDatas;
    
    
    UIAlertView *showUpdateDialog;
    UIAlertView *alertDialog;
    
    NSString *upTitle;
    NSString *upT;
    NSString *upUrl;
    NSString *shouldUp;
    AdMoGoInterstitial *interstitialIns;
    BOOL canshow;
}



@end



@implementation RecoAppsTableViewController

@synthesize zhou;
@synthesize category;
@synthesize dbFile;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Create manager
    NSLog(@"success");
    self.title = self.category;
    
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
    
    knowDatas = [[NSMutableArray alloc] init];
    
    
    
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
    
    //NSString *query = [[@"select * from " stringByAppendingString:@"datatable" ] stringByAppendingString:@" WHERE zhou = '%@' AND category = '%@'"];
    
    //NSLog(@"query:%@",query);
    
    FMResultSet *rs = [db executeQuery:[@"select * from " stringByAppendingString:@"datatable" ]];
    
    
    while ([rs next]) {
        
        
        
        
        KnowData *knowData = [KnowData new];
        
        
        knowData.zhou = [rs stringForColumn:@"zhou"];
        knowData.category = [rs stringForColumn:@"category"];
        
        
        
        if ([self.zhou isEqualToString:knowData.zhou ]&& [self.category isEqualToString:knowData.category]) {
            
            knowData._id = [rs stringForColumn:@"id"];
            knowData.title=[rs stringForColumn:@"title"];
            knowData.connect = [rs stringForColumn:@"connect"];
            knowData.imageurl = [rs stringForColumn:@"imageurl"];
            knowData.weburl = [rs stringForColumn:@"weburl"];
            
            [knowDatas addObject:knowData];
        }
        
        
        
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

-(NSString *) getDBPath:(NSString *)dbfile
{
    
    NSString *tmpDir = NSTemporaryDirectory();
    return [tmpDir stringByAppendingPathComponent:dbfile];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return knowDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"knowcell" forIndexPath:indexPath];
    
    KnowData *currentKnow = [knowDatas objectAtIndex:indexPath.row];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *connectLabel = (UILabel *)[cell viewWithTag:2];
    

    titleLabel.text = currentKnow.title;
    connectLabel.text = currentKnow.connect;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    KnowData *currentKnow = [knowDatas objectAtIndex:indexPath.row];
    
    
    if (APPDELEGATE.israte && ![[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"] && indexPath.row > 6) {
        
        [alertDialog show];
        return;
        
    }
    
    
    
    VideoDetailViewController *videoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoDetailViewController"];
    videoVC._id = currentKnow.weburl;
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
