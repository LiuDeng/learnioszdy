//
//  BooksCollectionViewController.m
//  zdy
//
//  Created by jackrex on 17/6/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import "BooksCollectionViewController.h"
#import "BooksEntity.h"
#import "BooksListTableViewController.h"
@interface BooksCollectionViewController ()
{
    NSMutableArray *arraysData;
}
@end

@implementation BooksCollectionViewController

static NSString * const reuseIdentifier = @"bookcell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"书籍列表";
    arraysData = [[NSMutableArray alloc] init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"imageName" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary *dict in array) {
        BooksEntity *entity = [BooksEntity new];
        entity.bookName = [dict objectForKey:@"bookName"];
        entity.bookImage = [dict objectForKey:@"bookImage"];
        entity.key = [dict objectForKey:@"key"];
        [arraysData addObject:entity];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arraysData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    BooksEntity *entity = [arraysData objectAtIndex:indexPath.row];
    imageView.image = [UIImage imageNamed:entity.bookImage];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BooksListTableViewController *booksListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BooksListTableViewController"];
     BooksEntity *entity = [arraysData objectAtIndex:indexPath.row];
    booksListVC.title = entity.bookName;
    booksListVC.key = entity.key;
    [self.navigationController pushViewController:booksListVC animated:YES];

}


@end
