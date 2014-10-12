//
//  Tool.m
//  dlxzs
//
//  Created by Mac OS X on 14-3-24.
//  Copyright (c) 2014年 duolia Inc. All rights reserved.
//

#import "Tool.h"
#import "HttpClient.h"
#import <CoreText/CoreText.h>


@implementation Tool

+ (NSInteger)OSVersion {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

+ (CGSize)calculateSizeWithString:(NSString *)string
                             font:(UIFont *)font
                   constrainWidth:(CGFloat)width {
    CGSize expectSize = CGSizeZero;
    if ([Tool OSVersion] >= 7) {
        expectSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{UITextAttributeFont : font} context:nil].size;
    } else {
        expectSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    return expectSize;
}

// 压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
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

// 等比例放缩图片
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
                                
}

// 将从1970年的时间转成 YYYY-MM-DD hh:mm
+ (NSString*)convertTimeSince1970:(NSString*)dt {
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[dt doubleValue]/1000];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *time = [dateformatter stringFromDate:d];
    return time;
}

// 将从1970年的时间转成 DateFormatter 的形式
+ (NSString*)convertTimeSince1970:(NSString*)dt withDateFormatter:(NSDateFormatter *)dateFormatter {
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[dt doubleValue]/1000];
    NSString *time = [dateFormatter stringFromDate:d];
    return time;
}

+ (NSString*)dateToString:(NSDate*)date withDateFormatter:(NSString *)dateFormat{
    if(dateFormat==nil)
        dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.dateFormat = dateFormat;
    NSString * stringDate = [df stringFromDate:date];
    df.dateFormat = nil;
    df = nil;
    return stringDate;
}

// 将datepicker 的时间转出来成 YYYY-MM-DD
+ (NSString*)convertDatePickerValue:(UIDatePicker *)datePicker {
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)convertDatePickerValueToTimeIntervalSince1970:(UIDatePicker *)datePicker
{
    double totalmiliSeconds = [datePicker.date timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%.0f",totalmiliSeconds];
}

// 判断所有的uitextfield是不是都填了内容
+ (BOOL)isFillAllTextField:(UIView *)view {
    for (UIView *subview in [view subviews])
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            UITextField *textfield = (UITextField *)subview;
            if (textfield.text.length == 0)
            {
                return NO;
            }
        }
    }
    return YES;
}

// 将数组timateIdArray中的id对应的伙伴名字拼接而成的字符串 eg：@“thdthd1、aaa001、.....”
+ (NSString *)correspodingNameWithTeammateIdArray:(NSArray *)timateIdArray {
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    HttpClient *client = [HttpClient shareInstance];
    NSMutableArray *timateArray = [NSMutableArray arrayWithArray: client.allDataDict[@"data"][@"wdhb"]];
    for (NSDictionary *dic in timateArray) {
        for (NSString *timateID in timateIdArray) {
            if ([[dic objectForKey:TEAMMATE_id] isEqualToString:timateID]) {
                [nameArray addObject:[dic objectForKey:TEAMMATE_name]];
            }
        }
    }
    if (nameArray != nil) {
        return [nameArray componentsJoinedByString:@"、"];
    } else {
        return @"没有相关数据";
    }
}

// id对应的名字
+ (NSString *)correspodingNameWithTeammateIdString:(NSString *)timateIdString {
    NSString *nameString = nil;
    HttpClient *client = [HttpClient shareInstance];
    NSMutableArray *timateArray = [NSMutableArray arrayWithArray: client.allDataDict[@"data"][@"wdhb"]];
    for (NSDictionary *dic in timateArray) {
            if ([[dic objectForKey:TEAMMATE_id] isEqualToString:timateIdString]) {
                nameString = (NSString *)[dic objectForKey:TEAMMATE_name];
                break;
            }
        }
    
    if(nameString != nil) {
        return nameString;
    } else {
        return @"没有相关数据";
    }
}

//  需要根据不同uid（不同人有不同uid）来判断当前对应应该显示谁的头像
+ (NSString *)correspodingHeadPhotoWithTeammateIdString:(NSString *)authorID {
    NSString *headPhotoURL = nil;
    if ([authorID isEqualToString:[UserInfoModel uid]]) {
        return [UserInfoModel headPhotoURL];
    }
    else {
        HttpClient *client = [HttpClient shareInstance];
        NSMutableArray *timateArray = [NSMutableArray arrayWithArray: client.allDataDict[@"data"][@"wdhb"]];
        for (NSDictionary *dic in timateArray) {
            if ([[dic objectForKey:TEAMMATE_id] isEqualToString:authorID]) {
                headPhotoURL = (NSString *)[dic objectForKey:TEAMMATE_photo];
                break;
            }
        }
        
        if(headPhotoURL != nil) {
            return headPhotoURL;
        } else {
            return @"没有相关数据";
        }
        
        }
    
}

// 计算固定宽度为 194 的一串字符的高度 字体大小为 20
+ (CGFloat)heightForTextTitle:(NSString *)title withWidth:(NSInteger )width{
    CGFloat fontSize = 20.0f;
    CGSize titleLabelMaxSize = CGSizeMake(width, CGFLOAT_MAX);
    if (SystemVersion_floatValue >= 7.0) {
        CGFloat heightIndent = 3.0f;
        NSDictionary *attributes = @{ (NSString *)kCTFontAttributeName : [UIFont boldSystemFontOfSize:fontSize] };
        CGRect frame = [title boundingRectWithSize:titleLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        frame.size.height += heightIndent;
        return frame.size.height;
    }
    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:fontSize] constrainedToSize:titleLabelMaxSize lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}

// 计算固定宽度为 194 的一串字符的高度 字体大小不固定
+ (CGFloat)heightForTextTitle:(NSString *)title fontSize:(CGFloat)fontSize {
    CGSize titleLabelMaxSize = CGSizeMake(194, CGFLOAT_MAX);
    if (SystemVersion_floatValue >= 7.0) {
        CGFloat heightIndent = 3.0f;
        NSDictionary *attributes = @{ (NSString *)kCTFontAttributeName : [UIFont boldSystemFontOfSize:fontSize] };
        CGRect frame = [title boundingRectWithSize:titleLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        frame.size.height += heightIndent;
        return frame.size.height;
    }
    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:fontSize] constrainedToSize:titleLabelMaxSize lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}

+(int)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt {
    float fPadding = 16.0;
    CGSize constraint = CGSizeMake(txtView.contentSize.width - 10 - fPadding, CGFLOAT_MAX);
    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    float fHeight = size.height + 16.0;
    return fHeight;
}

/*! 获取全部的伙伴名字数组 */
+ (NSArray *)getTeammateArray {
    NSMutableArray *teammateArray = [NSMutableArray array];
    HttpClient *client = [HttpClient shareInstance];
    NSMutableArray *timateArray;
    timateArray = [NSMutableArray arrayWithArray: client.allDataDict[@"data"][@"wdhb"]];
    
    for (NSDictionary *item in timateArray) {
        NSDictionary *tim = @{item[TEAMMATE_id]: item[TEAMMATE_name]};
        [teammateArray addObject:tim];
        
    }
    
    return [teammateArray mutableCopy];
}

@end
