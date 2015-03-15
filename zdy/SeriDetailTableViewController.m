//
//  SeriDetailTableViewController.m
//  zdy
//
//  Created by jackrex on 22/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "SeriDetailTableViewController.h"
#define HOST @"http://m.youku.com/wireless_api3/videos/"
#import <AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "VideoDetailViewController.h"


@interface SeriDetailTableViewController ()
{
    NSMutableArray *images;
    NSMutableArray *titles;
    NSMutableArray *playids;
}
@end

@implementation SeriDetailTableViewController
@synthesize ids;
@synthesize m3u8s;


- (void)viewDidLoad {
    [super viewDidLoad];
    images = [[NSMutableArray alloc] init];
    titles = [[NSMutableArray alloc] init];
    playids = [[NSMutableArray alloc] init];
    
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    [SVProgressHUD showWithStatus:@""];
    for (NSString *_id in ids) {
        
        [self httpgetvideo:_id];
        
    }

}


-(void)httpgetvideo:(NSString *)_id{
    
    NSString *requestUrl = [HOST stringByAppendingString:_id];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *results = [responseObject objectForKey:@"results"];
        NSString *img = [results objectForKey:@"img"];
        NSString *title = [results objectForKey:@"title"];
        NSString *videoid = [results objectForKey:@"videoid"];
        
        [images addObject:img];
        [titles addObject:title];
        [playids addObject:videoid];
        
        if (images.count == ids.count) {
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"加载失败，请检查网络重新尝试."];
    }];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return playids.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seridetailcell" forIndexPath:indexPath];
    
    UIImageView *cellimageview = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    
    [FUtils setImage:[images objectAtIndex:indexPath.row] withImageView:cellimageview withHeight:96 withWidth:128];
    label.text = [titles objectAtIndex:indexPath.row];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoDetailViewController *videoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoDetailViewController"];
    //videoVC._id = [playids objectAtIndex:indexPath.row];
    videoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoVC animated:YES];
    
    
    

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 75;
    
}


@end
