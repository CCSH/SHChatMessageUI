//
//  NSString+SHExtension.m
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "NSString+SHExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (Extension)

#define D_MINUTE    60
#define D_HOUR      3600
#define D_DAY       86400
#define D_WEEK      604800
#define D_MONTH     2592000
#define D_YEAR      31556926

#define TIME_Formatter @"yyyy-MM-dd HH:mm:ss"

#pragma mark - 属性
#pragma mark 获取拼音
- (NSString *)pinyin{

    if (self.length) {
        //系统
        NSMutableString *pinyin = [NSMutableString stringWithString:self];
        CFStringTransform((CFMutableStringRef)pinyin, NULL, kCFStringTransformToLatin, false);
        return [[[pinyin stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else{
        return self;
    }
}

- (void)setPinyin:(NSString *)pinyin{

}

#pragma mark 获取MD5加密
- (NSString *)md5{
    
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

- (void)setMd5:(NSString *)md5{
    
}

#pragma mark 获取字符串长度(中文：2 其他：1）
- (NSInteger)textLenght{
    
    //判断长度
    NSInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < self.length; i++) {
        
        unichar uc = [self characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

- (void)setTextLenght:(NSInteger)textLenght{

}

#pragma mark 是否为邮箱
- (BOOL)isEmail{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

- (void)setIsEmail:(BOOL)isEmail{
    
}

#pragma mark 是否包含特殊字符
- (BOOL)isSpecial{
    
    NSString *str = [[[NSMutableString alloc]initWithString:self] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (str.length) {
        //判断是否包含特殊字符
        NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$€"]];
        
        return (urgentRange.location != NSNotFound);
    }else{
        return YES;
    }
}

- (void)setIsSpecial:(BOOL)isSpecial{
    
}

#pragma mark 是否首字母开头
- (BOOL)isFirstLetter{
    
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    return [regextestA evaluateWithObject:[self substringToIndex:1]];
}

- (void)setIsFirstLetter:(BOOL)isFirstLetter{
    
}

#pragma mark 聊天界面时间
- (NSString *)chatTime{

    //格式化
    NSDate *currentDay = [[NSDate alloc]initWithTimeIntervalSince1970:[self longLongValue]/1000.0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc]init];
    
    NSString *timeText = [NSDateFormatter localizedStringFromDate:currentDay dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    NSDate *today = [NSDate date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:0];
//    [components setDay:-7];
//    NSDate *weekday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:0];
    
    //当前
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday  fromDate:currentDay];
    //今天
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    //昨天
    NSDateComponents *yesterdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:yesterday];
//    //本周
//    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:weekday];
    
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
        //今天
        return timeText;
    } else if (dateComponents.year == yesterdayComponents.year && dateComponents.month == yesterdayComponents.month && dateComponents.day == yesterdayComponents.day) {
        //昨天
        return [NSString stringWithFormat:@"昨天 %@",timeText];
//    } else if (dateComponents.weekday == weekdayComponents.weekday) {
//        //本周
//        [dateFormatter setDateFormat:@"EEEE HH:mm"];
//        return [dateFormatter stringFromDate:currentDay];
    }else {
        //年月日
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:currentDay];
    }
}

- (void)setChatTime:(NSString *)chatTime{
    
}

#pragma mark 获取日期（毫秒）
- (NSString *)date{
        
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[self longLongValue]/1000.0];
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:TIME_Formatter];
    
    return [dateformat stringFromDate:date];
}

- (void)setDate:(NSString *)date{
    
}

#pragma mark - 方法
#pragma mark 获取格式化后的时长
+ (NSString *)getFormatDuration:(NSInteger)duration{
    
    NSInteger hour = duration / D_HOUR;
    NSInteger minute = (duration - (hour * D_HOUR)) / D_MINUTE;
    NSInteger second = duration % 60;
    
    if (hour) {//有小时
        return [NSString stringWithFormat:@"%ld:%@:%@",(long)hour,[self getFormatSecond:minute],[self getFormatSecond:second]];
    }else{
        return [NSString stringWithFormat:@"%@:%@",[self getFormatSecond:minute],[self getFormatSecond:second]];
    }
}

#pragma mark 获取格式化秒数
+ (NSString *)getFormatSecond:(NSInteger)second{
    
    if (second < 10) {
        return [NSString stringWithFormat:@"0%ld",second];
    }else{
        return [NSString stringWithFormat:@"%ld",second];
    }
}

#pragma mark base64编码
- (NSString *)base64{
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (void)setBase64:(NSString *)base64{
    
}

#pragma mark base64解码
- (NSString *)decoded64{
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)setDecoded64:(NSString *)decoded64{
    
}

@end

