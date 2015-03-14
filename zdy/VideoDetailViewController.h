//
//  VideoDetailViewController.h
//  zdy
//
//  Created by jackrex on 24/2/15.
//  Copyright (c) 2015 Dracarys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectionMPMoviePlayer.h"  //播放

@interface VideoDetailViewController : UIViewController
@property (nonatomic, strong)DirectionMPMoviePlayer *moviePlayer;

@property(nonatomic ,strong) NSString *_id;
@property(nonatomic ,strong) NSString *titlename;


@end
