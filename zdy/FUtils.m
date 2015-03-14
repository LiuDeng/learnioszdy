//
//  FUtils.m
//  FitnessSeries
//
//  Created by jackrex on 1/12/14.
//  Copyright (c) 2014 Dracarys. All rights reserved.
//

#import "FUtils.h"
#import <QuartzCore/QuartzCore.h>
#import <SVProgressHUD.h>



static inline double radians (double degrees) {return degrees * M_PI/180;}
@implementation FUtils
+ (BOOL)regexTest:(NSString *)str pattern:(NSString *)pattern{
    NSRegularExpression *expression = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberOfMatch = [expression numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    return numberOfMatch > 0;
}


+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

+ (NSString *)getDateString:(NSDate *)date dateFormat:(NSString *)dateformat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateformat];
    return [formatter stringFromDate:date];
}


+ (NSString *)getDateString:(NSDate *)date{
    return [self getDateString:date dateFormat:@"yyyy年MM月dd日"];
}

+ (NSDate *)getDateFromString:(NSString *)dateString{
    return [self getDateFromString:dateString dateFormat:@"yyyy年MM月dd日"];
}

+ (NSDate *)getDateFromString:(NSString *)dateString dateFormat:(NSString *)dateformat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateformat];
    return [formatter dateFromString:dateString];
}


+ (void)setCustomNavigationBar:(UINavigationBar *)navigationBar withColor:(UIColor *)color{
    UIImage *title_bg = [self createImageWithColor:color];
    [navigationBar setBackgroundImage:title_bg forBarMetrics:UIBarMetricsDefault];
}

+ (void)setCustomNavigationBar:(UINavigationBar *)navigationBar{
    [FUtils setCustomNavigationBar:navigationBar withColor:[FUtils colorFromHexRGB:@"2F85C4"]];
}

+ (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13,15,18 ,14, 17 开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(14[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}



void KPostNotice(NSString *eventName,id data){
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:data];
}

void KObserver(NSString *eventName,id target,SEL method){
    [[NSNotificationCenter defaultCenter] addObserver:target selector:method name:eventName object:nil];
}

void KCancle(NSString *eventName,id target){
    [[NSNotificationCenter defaultCenter] removeObserver:target name:eventName object:nil];
}


+ (UIImage*)captureView:(UIView *)view {
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]){
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]){
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            CGContextRestoreGState(context);
        }
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageOrientation imageOrientation;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        imageOrientation = UIImageOrientationRight;
    }else if (orientation == UIInterfaceOrientationLandscapeRight) {
        imageOrientation = UIImageOrientationLeft;
    } else{
        return image;
    }
    return [self new:[[UIImage alloc] initWithCGImage:image.CGImage
                                                scale: 1.0
                                          orientation: imageOrientation]];
}

+ (UIImage*)new:(UIImage*)src{
    UIGraphicsBeginImageContext(src.size);
    [src drawAtPoint:CGPointMake(0, 0)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize sourceImage:(UIImage*)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
        
    }
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        UIGraphicsEndImageContext();
    return newImage;
}

UIImage* resizeImageWithImage(NSString* imageName, UIEdgeInsets capInsets, UIImageResizingMode resizingMode){
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (systemVersion >= 6.0) {
        return [image resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
        return [image resizableImageWithCapInsets:capInsets];;
    }
    
    if (systemVersion >= 5.0) {
        return [image resizableImageWithCapInsets:capInsets];;
    }
    return  [image stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
}


//对图片尺寸进行压缩--
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (UIImage*)circleImage:(UIImage*) image withParam:(CGFloat) inset {
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextSetAllowsAntialiasing(context, YES);//去锯齿
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIColor *) colorFromHexRGB:(NSString *)ColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != ColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:ColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

void CCAlert(NSString *title, NSString *msg, NSString *buttonText){
    
    UIAlertView *av=[[UIAlertView alloc] initWithTitle:title
                                               message:msg
                                              delegate:nil
                                     cancelButtonTitle:buttonText
                                     otherButtonTitles:nil];
    [av show];
    
}


void CCPostNotice(NSString *eventName,id data){
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:data];
}

void CCObserver(NSString *eventName,id target,SEL method){
    [[NSNotificationCenter defaultCenter] addObserver:target selector:method name:eventName object:nil];
}

void CCCancle(NSString *eventName,id target){
    [[NSNotificationCenter defaultCenter] removeObserver:target name:eventName object:nil];
}



//点击放大图片
static CGRect oldframe;
+(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}


/* 避免输入框键盘遮挡 */
+ (void)moveView:(UITextField *)textField leaveView:(BOOL)leave view:(UIView*)superView
{
    
    UIView *accessoryView = textField.inputAccessoryView;
    UIView *inputview     = textField.inputView;
    
    int textFieldY = 0;
    int accessoryY = 0;
    if (accessoryView && inputview)
    {//480-20-44
        CGRect accessoryRect = accessoryView.frame;
        CGRect inputViewRect = inputview.frame;
        accessoryY = SCREENHEIGHT-20-44 - (accessoryRect.size.height + inputViewRect.size.height);
    }
    else if (accessoryView)
    {
        CGRect accessoryRect = accessoryView.frame;
        accessoryY = SCREENHEIGHT-20-44 - (accessoryRect.size.height + 216);
    }
    else if (inputview)
    {
        CGRect inputViewRect = inputview.frame;
        accessoryY = SCREENHEIGHT-20-44 -inputViewRect.size.height;
    }
    else
    {
        accessoryY = 220; //480 - 216;
    }
    
    
    CGRect textFieldRect = textField.frame;
    textFieldY = textFieldRect.origin.y + textFieldRect.size.height+40; //+20
    
    int offsetY = textFieldY - accessoryY;
    if (!leave && offsetY > 0)
    {
        int y_offset = -5;
        
        y_offset += -offsetY;
        
        CGRect viewFrame = superView.frame;
        
        viewFrame.origin.y += y_offset;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        [superView setFrame:viewFrame];
        [UIView commitAnimations];
    }
    else
    {
        CGRect viewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);  //-20
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25];
        [superView setFrame:viewFrame];
        [UIView commitAnimations];
    }
}

+(NSString*)handlePostTimeString:(NSString*)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *addTimeDate = [formatter dateFromString:time];
    return [self handlePostTime:addTimeDate];
}

+(NSString*)handlePostTime:(NSDate*)addTimeDate{
    NSDate *date = [NSDate date];
    int interval = [addTimeDate timeIntervalSince1970];
    int intervalNow = [date timeIntervalSince1970];
    
    int diff = intervalNow - interval;
    if (diff < 60) {
        return @"刚刚";
    }else if (diff >= 60 && diff < 60*60){
        return [NSString stringWithFormat:@"%d分钟前",diff/60];
    }else if (diff >= 60*60 && diff < 24*60*60){
        return  [NSString stringWithFormat:@"%d小时前",diff/3600];
    }else if (diff >= 24*60*60 && diff < 24*60*60*30){
        return  [NSString stringWithFormat:@"%d天前",diff/(3600*24)];
    }
    return nil;
}



+ (CGSize)labelSizeToFit:(NSString*)textName font:(UIFont*)font width:(CGFloat)width height:(CGFloat)height breakType:(NSLineBreakMode)breakType{
    CGSize size = [textName sizeWithFont:font constrainedToSize:CGSizeMake(width, height) lineBreakMode:breakType];
    return size;
}






+(NSString *)getPicFromArrays:(NSString *)name{
 
    
    if ([name rangeOfString:@"胸肌"].location != NSNotFound) {
        
        return @"muscle_ea";
    }else if([name rangeOfString:@"三头"].location != NSNotFound){
    
        int random = arc4random()%4;
        if (random == 0) {
            return @"muscle_aa";
        }else if(random == 1){
            return @"muscle_ab";
        }else if(random == 2){
            return @"muscle_ac";
        }else if (random == 3){
            return @"muscle_cb";
        }
        
        
        
    }else if ([name rangeOfString:@"腹肌"].location != NSNotFound){
    
        int random = arc4random()%3;
        if (random == 0) {
            return @"muscle_fa";
        }else if(random == 1){
            return @"muscle_fb";
        }else if(random == 2){
            return @"muscle_fc";
        }

        
    }else if([name rangeOfString:@"背部"].location != NSNotFound){
    
        return @"muscle_da";
    }else if ([name rangeOfString:@"二头"].location != NSNotFound){
    
        return @"muscle_ca";
        
    }else if([name rangeOfString:@"肩部"].location != NSNotFound){
    
    }else if ([name rangeOfString:@"腿部"].location != NSNotFound){
     return @"muscle_ha";
    }else if([name rangeOfString:@"前臂"].location != NSNotFound){
     return @"muscle_aa";
    }else if ([name rangeOfString:@"斜方肌"].location != NSNotFound){
      return @"muscle_db";
    }

    return @"muscle_ha";
}

+(void)jumpAppStore:(NSString *)appUrl{
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];

}


+(void)jumpRecApps{
    
  
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.com/apps/%@",APPAUTHOR]]];
    
}

+(void)setImage:(NSString *)imageUrl withImageView:(UIImageView *)imageview withHeight:(int) height withWidth:(int) width{
    
    
    NSString *picUrl = [NSString stringWithFormat:@"%@",imageUrl];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __block NSString *cacheKey = [NSString stringWithFormat:@"%@_cover",picUrl];
    UIImage *memoryImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:cacheKey];
    if (memoryImage){
        UIImage *scaleImage = [FUtils imageByScalingAndCroppingForSize:CGSizeMake(width, height) sourceImage:memoryImage];
        [imageview setImage:scaleImage];
    }else{
        UIImage *diskImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheKey];
        if (diskImage){
            UIImage *scaleImage = [FUtils imageByScalingAndCroppingForSize:CGSizeMake(width, height) sourceImage:diskImage];
            [imageview setImage:scaleImage];
            
        }else{
            
            [manager downloadWithURL:[NSURL URLWithString:picUrl]
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize){
                                
                            }
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                               if (image){
                                   
                                   [[SDImageCache sharedImageCache] storeImage:image forKey:cacheKey];
                                   UIImage *scaleImage = [FUtils imageByScalingAndCroppingForSize:CGSizeMake(width, height) sourceImage:image];
                                   [imageview setImage:scaleImage];
                               }
                           }];
        }
    }
    
    
    
    
    
}


+(void)rateApps{

    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APPID]]];
}

+(void)getImageFromUrl:(NSString *)picUrl OriginImage:(UIImage *)image{

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __block NSString *cacheKey = [NSString stringWithFormat:@"%@_cover",picUrl];
    UIImage *memoryImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:cacheKey];
    if (memoryImage){
        UIImage *scaleImage = [FUtils imageByScalingAndCroppingForSize:CGSizeMake(30, 30) sourceImage:memoryImage];
        image = scaleImage;
    }else{
        UIImage *diskImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheKey];
        if (diskImage){
            UIImage *scaleImage = [FUtils imageByScalingAndCroppingForSize:CGSizeMake(30, 30) sourceImage:diskImage];
            image = scaleImage;
            
        }else{
            

            [manager downloadWithURL:[NSURL URLWithString:picUrl]
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize){
                                
                            }
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                               if (image){
                                   
                                   [[SDImageCache sharedImageCache] storeImage:image forKey:cacheKey];
                                   UIImage *scaleImage = [FUtils imageByScalingAndCroppingForSize:CGSizeMake(30, 30) sourceImage:image];
                                   image =  scaleImage;
                               }
                           }];
        
        
    }
    }


}


+(BOOL)isFileExist:(NSString *)name{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return  [file_manager fileExistsAtPath:path];
    
}

+ (BOOL)isZH
{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    NSLog(@"当前语言:%@", preferredLang);
    if ([preferredLang rangeOfString:@"zh"].location != NSNotFound) {
        return YES;
    }
    
    
    return NO;
    
}

@end
