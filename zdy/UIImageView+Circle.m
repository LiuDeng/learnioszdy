//
//  UIImageView+Circle.m
//  Keep
//
//  Created by jackrex on 18/12/14.
//  Copyright (c) 2014 JackRex. All rights reserved.
//

#import "UIImageView+Circle.h"

@implementation UIImageView (Circle)
-(void)doCircleImage{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}
-(void)doCircleImageWithWhiteBordor{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}
@end
