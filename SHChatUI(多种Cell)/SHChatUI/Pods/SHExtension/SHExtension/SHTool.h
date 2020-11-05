//
//  SHTool.h
//  SHExtensionExample
//
//  Created by CSH on 2019/8/6.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *sh_fomat_1 = @"YYYY-MM-dd HH:mm:ss";
static NSString *sh_fomat_2 = @"YYYY.MM.dd";
static NSString *sh_fomat_3 = @"YYYY.MM.dd HH:mm";
static NSString *sh_fomat_4 = @"YYYY/MM/dd";
static NSString *sh_fomat_5 = @"YYYY-MM-dd HH:mm";
static NSString *sh_fomat_6 = @"YYYY-MM-dd";
static NSString *sh_fomat_7 = @"YYYY-MM-dd HH:mm:ss:SSS";
static NSString *sh_fomat_8 = @"YYYY-MM-dd-HH-mm-ss-SSS";

@interface SHTool : NSObject

#pragma mark - Time方法
#pragma mark 获取毫秒值
+ (NSString *)getTimeMs;

#pragma mark 获取指定格式时间
+ (NSString *)getTimeWithTime:(NSString *)time currentFormat:(NSString *)currentFormat format:(NSString *)format;

#pragma mark 获取毫秒值(time -> ms)
#pragma mark 获取当前
+ (NSString *)getMsTimeWithTime:(NSString *)time format:(NSString *)format;
#pragma mark 获取指定时区(8*60*60)
+ (NSString *)getMsTimeWithTime:(NSString *)time format:(NSString *)format GMT:(NSInteger)GMT;

#pragma mark 获取时间(ms -> time)
#pragma mark 获取当前
+ (NSString *)getTimeMsWithMs:(NSString *)ms format:(NSString *)format;
#pragma mark 获取指定(8*60*60)
+ (NSString *)getTimeMsWithMs:(NSString *)ms format:(NSString *)format GMT:(NSInteger)GMT;

#pragma mark 获取当前时区
+ (NSInteger)getCurrentGMT;

#pragma mark 获取即时时间
+ (NSString *)getInstantTimeWithTime:(NSString *)time;

#pragma mark 比较两个日期大小
+ (NSInteger)compareStartDate:(NSString *)startDate endDate:(NSString *)endDate;

#pragma mark 处理个数
+ (NSString *)dealCount:(NSString *)count;

#pragma mark 计算富文本的size
+ (CGSize)getSizeWithAtt:(NSAttributedString *)att
                 maxSize:(CGSize)maxSize;

#pragma mark 计算字符串的size
+ (CGSize)getSizeWithStr:(NSString *)str
                    font:(UIFont *)font
                 maxSize:(CGSize)maxSize;

#pragma mark 是否超过是否超过规定高度
+ (BOOL)isLineWithAtt:(NSAttributedString *)att lineH:(CGFloat)lineH maxW:(CGFloat)maxW;

#pragma mark 获取行高
+ (CGFloat)getLineHeightWithLine:(CGFloat)line font:(UIFont *)font;

#pragma mark 获取行间距
+ (CGFloat)getLineSpacingWithAtt:(NSMutableAttributedString *)att line:(CGFloat)line font:(UIFont *)font maxW:(CGFloat)maxW;

#pragma mark 处理金额(千分符 小数点后两位)
+ (NSString *)handleMoneyWithStr:(NSString *)str;

#pragma mark 处理价格(小数点后两位)
+ (NSString *)handlePriceWithStr:(NSString *)str;

#pragma mark - 获取一个渐变色的视图
+ (UIView *)getGradientViewWithSize:(CGSize)size colorArr:(NSArray *)colorArr;
+ (UIView *)getGradientViewWithSize:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colorArr:(NSArray *)colorArr;

#pragma mark - 格式化TextField字符串
+ (void)handleTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string rule:(NSArray *)rule;

#pragma mark - 格式化字符串
/// 格式化字符串
/// @param text 内容
/// @param rule 格式([@"3",@"4",@"4"])
+ (NSString *)handleStrWithText:(NSString *)text rule:(NSArray *)rule;

#pragma mark - 获取某个字符在字符串中出现的次数
+ (NSInteger)appearCountWithStr:(NSString *)str target:(NSString *)target;

@end

NS_ASSUME_NONNULL_END
