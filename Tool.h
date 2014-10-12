//
//  Tool.h
//  dlxzs
//
//  Created by Mac OS X on 14-3-24.
//  Copyright (c) 2014年 duolia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

+ (NSInteger)OSVersion;
+ (CGSize)calculateSizeWithString:(NSString *)string
                             font:(UIFont *)font
                   constrainWidth:(CGFloat)width;

/*! 压缩图片 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/*! 等比例放缩图片 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

/*! 将从1970年的时间转成 YYYY-MM-DD hh:mm */
+ (NSString*)convertTimeSince1970:(NSString*)dt;

/*! 将从1970年的时间转成 DateFormatter 的形式 */
+ (NSString*)convertTimeSince1970:(NSString*)dt withDateFormatter:(NSDateFormatter *)dateFormatter;

/*! 将datepicker 的时间转出来成 YYYY-MM-DD */
+ (NSString*)convertDatePickerValue:(UIDatePicker *)datePicker;

/*! 将datepicker 的时间转成 自1970 的秒数 */
+ (NSString*)convertDatePickerValueToTimeIntervalSince1970:(UIDatePicker *)datePicker;

+ (NSString*)dateToString:(NSDate*)date withDateFormatter:(NSString *)DateFormat;

/*! 判断所有的uitextfield是不是都填了内容 */
+ (BOOL)isFillAllTextField:(UIView *)view;

/**
 *@prama timateIdArray 是一个由伙伴成员的ID组成de数组 eg:@[@"903",@"100",...]
 *
 *@return 将数组timateIdArray中的id对应的伙伴名字拼接而成的字符串 eg：@“thdthd1、aaa001、.....”
 *
 *@discussion 如果找到的ID不是在自己伙伴
 */
+ (NSString *)correspodingNameWithTeammateIdArray:(NSArray *)timateIdArray;

/**
 *@prama timateIdString 是一个由伙伴成员的ID eg：@"903"
 *
 *@return 找到timateIdString的id对应的伙伴名字的字符串 eg：@“thdthd1”
 *
 *@discussion 如果找到的ID不是在自己伙伴
 */
+ (NSString *)correspodingNameWithTeammateIdString:(NSString *)timateIdString;

/*! 需要根据不同uid（不同人有不同uid）来判断当前对应应该显示谁的头像 */
+ (NSString *)correspodingHeadPhotoWithTeammateIdString:(NSString *)authorID;

/*! 计算不固定宽度的一串字符的高度 字体大小为 20 */
+ (CGFloat)heightForTextTitle:(NSString *)title withWidth:(NSInteger )width;

/*! 计算固定宽度为 194 的一串字符的高度 字体大小不固定 */
+ (CGFloat)heightForTextTitle:(NSString *)title fontSize:(CGFloat)fontSize;

/*! 计算文本的高度 不限定宽度 */
+ (int)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt;

/*! 获取全部的伙伴名字数组 */
+ (NSArray *)getTeammateArray;

@end
