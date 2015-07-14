//
//  FUtils.h
//  FitnessSeries
//
//  Created by jackrex on 1/12/14.
//  Copyright (c) 2014 Dracarys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import "OpenUDID.h"
#import <SDImageCache.h>
#import <SDWebImageManager.h>
@interface FUtils : NSObject


+ (NSString *)stringFromDate:(NSDate *)date;
/**
 *	check if a string matches the patter
 *
 *	@param	str
 *	@param	pattern	regex pattern
 *
 *	@return	YES if matches,or NO
 */
+ (BOOL)regexTest:(NSString *)str pattern:(NSString *)pattern;

/**
 *	get string from date default in fomat of "yyyy年MM月dd日"
 *
 *	@param	date
 *
 *	@return
 */
+ (NSString *)getDateString:(NSDate *)date;

/**
 *	get string from date in a specific format
 *
 *	@param	date
 *	@param	dateformat
 *
 *	@return
 */
+ (NSString *)getDateString:(NSDate *)date dateFormat:(NSString *)dateformat;

/**
 *	parse a string to NSdate
 *
 *	@param	dateString	a string in format of "yyyy年MM月dd日"
 *
 *	@return
 */
+ (NSDate *)getDateFromString:(NSString *)dateString;

/**
 *	parse a string to NSDate in a specific format
 *
 *	@param	dateString
 *	@param	dateformat
 *
 *	@return
 */
+ (NSDate *)getDateFromString:(NSString *)dateString dateFormat:(NSString *)dateformat;

/**
 *	list the files and modified dates in Documents dir in NSLog
 */
+ (void)listDocumentsDirectory;

/**
 *	set navigationBar to a color
 *
 *	@param	navigationBar
 *	@param	color
 */
+ (void)setCustomNavigationBar:(UINavigationBar *)navigationBar withColor:(UIColor *)color;
+ (void)setCustomNavigationBar:(UINavigationBar *)navigationBar;

/**
 *	capture the landscape screen
 *
 *	@param	view
 *
 *	@return	a image of the screen
 */
+ (UIImage*)captureView:(UIView *)view;

/**
 *	@brief compress the sourceImage by targetSize
 *
 *	@param 	targetSize
 *	@param 	sourceImage
 *
 *	@return	UIImage instance
 */
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize sourceImage:(UIImage*)sourceImage;

/**
 *	@brief	对图片进行压缩
 *
 *	@param 	image 	<#image description#>
 *	@param 	newSize； 	<#newSize； description#>
 *
 *	@return	<#return value description#>
 */
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;


/**
 *	@brief	creat a circle image base on origin image
 *
 *	@return	image instance
 */
+ (UIImage*)circleImage:(UIImage*) image withParam:(CGFloat) inset;

/**
 *	translate hexadecimal into RGB
 *
 *	@param	ColorString
 *
 *	@return	UIColor type
 */

+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIColor *) colorFromHexRGB:(NSString *)ColorString;


/**
 *	@brief	<#Description#>
 *
 *	@param 	imageName 	<#imageName description#>
 *	@param 	capInsets 	<#capInsets description#>
 *	@param 	resizingMode 	<#resizingMode description#>
 *
 *	@return	<#return value description#>
 */
UIImage* resizeImageWithImage(NSString* imageName, UIEdgeInsets capInsets, UIImageResizingMode resizingMode);


/**
 *	@brief	点击放大图像
 *
 *	@param 	avatarImageView
 */
+(void)showImage:(UIImageView *)avatarImageView;

/**
 *  <#Description#>
 *
 *  @param textField <#textField description#>
 *  @param leave     <#leave description#>
 *  @param superView <#superView description#>
 */
+ (void)moveView:(UITextField *)textField leaveView:(BOOL)leave view:(UIView*)superView;

/**
 *	@brief	处理时间返回
 *
 *	@param 	time 	<#time description#>
 *
 *	@return	<#return value description#>
 */
+(NSString*)handlePostTime:(NSDate*)time;

+(NSString*)handlePostTimeString:(NSString*)time;

/**
 *	@brief	检查网络状况
 *
 *	@return	<#return value description#>
 */
- (BOOL)checkNetwork;

/**
 *	@brief	文本换行计算
 *
 *	@param 	textName 	<#textName description#>
 *	@param 	font 	<#font description#>
 *	@param 	width 	<#width description#>
 *	@param 	height 	<#height description#>
 *	@param 	breakType 	<#breakType description#>
 *
 *	@return	<#return value description#>
 */
+ (CGSize)labelSizeToFit:(NSString*)textName font:(UIFont*)font width:(CGFloat)width height:(CGFloat)height breakType:(NSLineBreakMode)breakType;

+(UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)sourceImg;
+(void)share:(NSString *)sharename message :(NSString *)message vc :(UIViewController *)view;

+(NSString *)getPicFromArrays:(NSString *)name;

/**
 *  验证手机号码
 */
+(BOOL) isValidateMobile:(NSString *)mobile;

// AppStore Utils
+ (BOOL)isZH;

+(void) jumpAppStore:(NSString *)appUrl;

+(void) jumpRecApps;

+(void) rateApps;

+(void)getImageFromUrl:(NSString *)picUrl OriginImage:(UIImage *)image;

+(BOOL)isFileExist:(NSString *)name;
+(void)setImage:(NSString *)imageUrl withImageView:(UIImageView *)imageview withHeight:(int) height withWidth:(int) width;
+(void)uploadToken;
@end
