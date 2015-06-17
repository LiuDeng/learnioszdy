//
//  RecoTableViewController.m
//  slimming
//
//  Created by jackrex on 23/4/15.
//  Copyright (c) 2015 Sola. All rights reserved.
//

#import "RecoTableViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <SDWebImageManager.h>
#import <SDWebImageCompat.h>
#import <SDImageCache.h>
#import <SDWebImageDownloader.h>
#import "FUtils.h"
#import "RecoData.h"
#import "UIImageView+Circle.h"
#import <SVProgressHUD.h>

@interface RecoTableViewController ()
{
    NSMutableArray *dataArrays;
}
@end

@implementation RecoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置navigationItem
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    dataArrays = [[NSMutableArray alloc] init];
    [self recommendSection];
    UIImageView *tableBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgbg.png"]];
    [self.tableView setBackgroundView:tableBg];
}

-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

-(void)recommendSection{
    [SVProgressHUD showWithStatus:@"加载中...."];
    AVQuery *query = [AVQuery queryWithClassName:@"Stock_RecApps"];
    if (query) {
        NSArray *recApps =[query findObjects];
        if (!recApps) {
            return;
        }
        for (int i = 0; i < recApps.count; i++) {
            AVObject *obj = [recApps objectAtIndex:i];
            NSString *picUrl = [obj valueForKey:@"picurl"];
            NSString *appstoreurl = [obj valueForKey:@"appstoreurl"];
            NSString *introduce = [obj valueForKey:@"introduce"];
            RecoData *recodata = [RecoData new];
            recodata.picurl = picUrl;
            recodata.appurl = appstoreurl;
            recodata.des = introduce;
            [dataArrays addObject:recodata];
            if (i == recApps.count -1 && recApps.count != 0) {
                [SVProgressHUD dismiss];
                [self.tableView reloadData];
            }
        }
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    UIImageView *avatar = (UIImageView *)[cell viewWithTag:1];
    UILabel *desLabel = (UILabel *)[cell viewWithTag:2];
    if (dataArrays.count > 0) {
        RecoData *recodata = [dataArrays objectAtIndex:indexPath.row];
        desLabel.text = recodata.des;
        [FUtils setImage:recodata.picurl withImageView:avatar withHeight:120 withWidth:120];
        [avatar doCircleImage];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (dataArrays.count > 0) {
        RecoData *recodata = [dataArrays objectAtIndex:indexPath.row];
        [FUtils jumpAppStore:recodata.appurl];
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArrays.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"精品推荐";
}

//实现section圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            CGFloat cornerRadius = 5.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 10, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            //圆角区域的颜色
            layer.fillColor = [UIColor colorWithWhite:3.f alpha:0.8f].CGColor;
            
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}
@end
