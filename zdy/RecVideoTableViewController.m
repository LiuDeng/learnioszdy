//
//  RecVideoTableViewController.m
//  zdy
//
//  Created by jackrex on 22/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "RecVideoTableViewController.h"
#import "VideoData.h"
#import <AFNetworking.h>   
#import "FMDatabase.h"
#import "RecoTableViewController.h"
#import "RecoAppsTableViewController.h"
#import "BooksCollectionViewController.h"
#import <MobClick.h>



@interface RecVideoTableViewController ()<UITableViewDelegate>
{
    
    NSMutableArray *videoDatas;
    
    UIAlertView *alertDialog;
    UIAlertView *showUpdateDialog;
    
    NSString *upTitle;
    NSString *upT;
    NSString *upUrl;
    NSString *shouldUp;

    IBOutlet UIBarButtonItem *leftItem;
    IBOutlet UIBarButtonItem *rightItem;
}
@end

@implementation RecVideoTableViewController



- (IBAction)leftClick:(id)sender {
    RecoTableViewController *RecoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecoTableViewController"];
    [self.navigationController pushViewController:RecoVC animated:YES];
    
}

- (IBAction)rightClick:(id)sender {
    BooksCollectionViewController *BooksVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BooksCollectionViewController"];
    [self.navigationController pushViewController:BooksVC animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"怀孕知识";
    
    if (APPDELEGATE.isAll) {
        
    }else{
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }

    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item = [tabBar.items objectAtIndex:0];
    
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
    
    NSString *dbpath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbpath];
    
    if(!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"cartegory.db"];
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
  

}

-(NSString *) getDBPath
{
    
    NSString *tmpDir = NSTemporaryDirectory();
    return [tmpDir stringByAppendingPathComponent:@"cartegory.db"];
    
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
    
    NSString *imageName = [currentVideo.urlimage stringByReplacingOccurrencesOfString:@"image/" withString:@""];
        
    picImageView.image = [UIImage imageNamed:imageName];
    
    //NSLog(@"picImageView:%@",currentVideo.urlimage);
        
    
    
    zhouLabel.text = [@"第" stringByAppendingString:currentVideo.zhou];
    zhouLabel.text = [zhouLabel.text stringByAppendingString:@"周"];
    titleLabel.text = currentVideo.title;
    contentLabel.text = currentVideo.content;

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     VideoData *currentVideo = [videoDatas objectAtIndex:indexPath.row];
    
   
    if (APPDELEGATE.israte && ![[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"] && indexPath.row > 6) {
        
        [alertDialog show];
        return;
        
    }
    
    
    
    RecoAppsTableViewController *videoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecoAppsTableViewController"];
    //NSLog(@"zhou: %@",currentVideo.zhou);
    videoVC.zhou = currentVideo.zhou;
    videoVC.category = currentVideo.category;
    videoVC.dbFile = @"cartegory.db";
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
