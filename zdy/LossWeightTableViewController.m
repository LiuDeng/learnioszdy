//
//  LossWeightTableViewController.m
//  zdy
//
//  Created by jackrex on 22/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "LossWeightTableViewController.h"
#import "WebViewDetailViewController.h"

@interface LossWeightTableViewController ()
{
    
    NSMutableArray *images;
    NSMutableArray *titles;
    NSMutableArray *descs;

}
@end

@implementation LossWeightTableViewController

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

    images = [[NSMutableArray alloc] init];
    titles = [[NSMutableArray alloc] init];
    descs = [[NSMutableArray alloc] init];
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"jianfei" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary *dict in array) {

        [images addObject:[dict objectForKey:@"img"]];
        [titles addObject:[dict objectForKey:@"title"]];
        [descs addObject:[dict objectForKey:@"desc"]];
        
        
    }
    
    
    
    
    
    
    
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
    return titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jianfeicell" forIndexPath:indexPath];
    
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    
    imageview.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    label.text = [titles objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WebViewDetailViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewDetailViewController"];
    webVC.content = [descs objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:webVC animated:YES];

}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90;

}









@end
