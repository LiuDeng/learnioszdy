//
//  RecoAppsTableViewController.m
//  zdy
//
//  Created by jackrex on 24/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "RecoAppsTableViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <SDWebImageManager.h>
#import <SDWebImageCompat.h>
#import <SDImageCache.h>
#import <SDWebImageDownloader.h>
#import <RETableViewManager.h>

@interface RecoAppsTableViewController ()<RETableViewManagerDelegate>
{
    
        RETableViewSection *recommendSection;
}
@property (strong, readwrite, nonatomic) RETableViewManager *manager;

@end

@implementation RecoAppsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create manager
    //
    
    self.title = @"推荐APP";
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    self.manager.delegate = self;
    [self recommendSection];
    
}

-(void)recommendSection{
    
    
    recommendSection = [RETableViewSection sectionWithHeaderTitle:@"精品推荐"];
    [self.manager addSection:recommendSection];
    AVQuery *query = [AVQuery queryWithClassName:@"RecApps"];
    
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
            
            RETableViewItem *recomendItem = [[RETableViewItem alloc] initWithTitle:introduce accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
                
                [FUtils jumpAppStore:appstoreurl];
            }];
            
            //[FUtils getImageFromUrl:picurl OriginImage:recomendItem.image];
            // recomendItem.image = [UIImage imageNamed:@"activity_instagram_color-iOS7"];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            __block NSString *cacheKey = [NSString stringWithFormat:@"%@_cover",picUrl];
            UIImage *memoryImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:cacheKey];
            if (memoryImage){
                UIImage *scaleImage = [FUtils imageByScalingAndCroppingForSize:CGSizeMake(30, 30) sourceImage:memoryImage];
                recomendItem.image = scaleImage;
            }else{
                UIImage *diskImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheKey];
                if (diskImage){
                    UIImage *scaleImage = [FUtils imageByScalingAndCroppingForSize:CGSizeMake(30, 30) sourceImage:diskImage];
                    recomendItem.image = scaleImage;
                    
                }else{
                    
                    
                    [manager downloadWithURL:[NSURL URLWithString:picUrl]
                                     options:0
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize){
                                        
                                    }
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                                       if (image){
                                           
                                           [[SDImageCache sharedImageCache] storeImage:image forKey:cacheKey];
                                           UIImage *scaleImage = [FUtils imageByScalingAndCroppingForSize:CGSizeMake(30, 30) sourceImage:image];
                                           recomendItem.image =  scaleImage;
                                       }
                                   }];
                    
                    
                }
            }
            
            
            
            
            [recommendSection addItem:recomendItem];
        }
        
    }
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
