//
//  CommenQuestionTableViewController.m
//  zdy
//
//  Created by jackrex on 22/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "CommenQuestionTableViewController.h"
#import "WebViewDetailViewController.h"

@interface CommenQuestionTableViewController ()
{
    NSMutableArray *currentQuestion;
    NSMutableArray *currentDetails;
}
@end

@implementation CommenQuestionTableViewController

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
    
    currentDetails = [[NSMutableArray alloc] init];
    currentQuestion = [[NSMutableArray alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QuestionPlist" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary *dict in array) {
        
        
        [currentQuestion addObject:[dict objectForKey:@"title"]];
        [currentDetails addObject:[dict objectForKey:@"desc"]];
        
        
        
    }

    
    
    
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
    return currentQuestion.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questioncell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    titleLabel.text = [currentQuestion objectAtIndex:indexPath.row];
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 96;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WebViewDetailViewController *webviewDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewDetailViewController"];
    webviewDetailVC.content = [currentDetails objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:webviewDetailVC animated:YES];
    
    
    

}



@end
