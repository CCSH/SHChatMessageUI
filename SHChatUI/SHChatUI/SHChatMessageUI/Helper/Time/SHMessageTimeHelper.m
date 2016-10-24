//
//  SHMessageTimeHelper.m
//  SHChatMessageUI
//
//  Created by CSH on 16/8/1.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageTimeHelper.h"

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926


@implementation SHMessageTimeHelper

#pragma mark 格式化时间
+ (NSString *)setFormattingMessageTime:(NSString *)messageTime{

    //格式化
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDay = [dateFormatter dateFromString:messageTime];
    
    NSString *dateText = nil;
    NSString *timeText = nil;
    
    NSDate *today = [NSDate date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:today options:0];

    //当前
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDay];
    //今天
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    //昨天
    NSDateComponents *yesterdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:yesterday];
    
    timeText = [NSDateFormatter localizedStringFromDate:currentDay dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    if (dateComponents.year == todayComponents.year && dateComponents.month == todayComponents.month && dateComponents.day == todayComponents.day) {
        //今天
        return timeText;
    } else if (dateComponents.year == yesterdayComponents.year && dateComponents.month == yesterdayComponents.month && dateComponents.day == yesterdayComponents.day) {
        //昨天
        return [NSString stringWithFormat:@"昨天 %@",timeText];
    } else {
        //年月日
        dateText = [NSDateFormatter localizedStringFromDate:currentDay dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
        return [NSString stringWithFormat:@"%@ %@",dateText,timeText];
    }
    
    
    
}

#pragma mark 是否显示时间
+ (BOOL)isShowMessageTimeWithOnTime:(NSString *)onTime ThisTime:(NSString *)thisTime{
    
    if (onTime.length) {
        //格式化
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        if ([[dateFormatter dateFromString:thisTime] timeIntervalSinceDate:[dateFormatter dateFromString:onTime]] >= D_MINUTE) {
            //1分钟限制
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
    
}

@end
