//
//  SeriesVideoTableViewController.m
//  zdy
//
//  Created by jackrex on 22/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "SeriesVideoTableViewController.h"
#import "SeriDetailTableViewController.h"
#import <UMFeedback.h>

@interface SeriesVideoTableViewController ()
{
    NSMutableArray *titles;
    NSMutableArray *pics;
    
    NSMutableArray *allids;
    NSMutableArray *allm3u8Addr;
    
}
@end

@implementation SeriesVideoTableViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    
    titles = [[NSMutableArray alloc] init];
    pics = [[NSMutableArray alloc] init];
    allids = [[NSMutableArray alloc] init];
    allm3u8Addr = [[NSMutableArray alloc] init];
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"jianfeicaoheji" ofType:@"plist"];
    NSDictionary *dictroot = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *zhuanji = [dictroot objectForKey:@"zhuanji"];
    for (NSDictionary *item in zhuanji) {
        
        [titles addObject:[item objectForKey:@"title"]];
        [pics addObject:[item objectForKey:@"img"]];
        
        
        NSMutableArray *ids = [[NSMutableArray alloc] init];
        NSMutableArray *m3u8Addr = [[NSMutableArray alloc] init];
        
        NSArray *movies = [item objectForKey:@"movies"];
        for (NSDictionary *movie in movies) {
            
            NSString *_id = [movie objectForKey:@"id"];
            NSString *m3u8addr = [movie objectForKey:@"m3u8Addr"];
            
            [ids addObject:_id];
            [m3u8Addr addObject:m3u8addr];

        }
        
        [allids addObject:ids];
        [allm3u8Addr addObject:m3u8Addr];
 
    }
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)feedback:(id)sender {
    
    self.navigationController.navigationBar.translucent = YES;
    [UMFeedback feedbackViewController].hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:[UMFeedback feedbackViewController] animated:YES];
    
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
    return titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seriescell" forIndexPath:indexPath];

    UIImageView *imageview = (UIImageView *)[cell viewWithTag:1];
    UILabel *lable = (UILabel *)[cell viewWithTag:2];
    lable.text = [titles objectAtIndex:indexPath.row];
    [FUtils setImage:[pics objectAtIndex:indexPath.row] withImageView:imageview withHeight:250 withWidth:200];
    

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 340;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SeriDetailTableViewController *seriVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SeriDetailTableViewController"];
    seriVC.title = [titles objectAtIndex:indexPath.row];
    seriVC.m3u8s = [allm3u8Addr objectAtIndex:indexPath.row];
    seriVC.ids = [allids objectAtIndex:indexPath.row];
    seriVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:seriVC animated:YES];
    
    
    
    
}





@end
