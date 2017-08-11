//
//  SHMessageTimeHelper.m
//  SHChatMessageUI
//
//  Created by CSH on 16/8/1.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageTimeHelper.h"

#define D_MINUTE    60
#define D_HOUR      3600
#define D_DAY       86400
#define D_WEEK      604800
#define D_MONTH     2592000
#define D_YEAR      31556926

#define TIME_Formatter @"yyyy-MM-dd HH:mm"
#define TIME_Formatter2 @"yyyy-MM-dd HH:mm:ss"

@implementation SHMessageTimeHelper

#pragma mark 是否显示时间
+ (BOOL)isShowMessageTimeWithOnTime:(NSString *)onTime ThisTime:(NSString *)thisTime{
    
    if (onTime.length) {
        //格式化
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:TIME_Formatter];
        
        if ([[dateFormatter dateFromString:[self msToDateWithMs:thisTime]] timeIntervalSinceDate:[dateFormatter dateFromString:[self msToDateWithMs:onTime]]] >= 5*D_MINUTE) {
            //5分钟限制
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}

#pragma mark  时间分段（本周，本月，年月）
+ (NSString *)dealDataWithMessageTime:(NSString *)messageTime{
    
    messageTime = [self msToDateWithMs:messageTime];
    //格式化
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:TIME_Formatter];
    
    NSDate *currentDay = [dateFormatter dateFromString:messageTime];

    //取出现在的时间
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.firstWeekday = 2;
    //今天
    NSDateComponents *todayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:today];
    //传进来的
    NSDateComponents *currentComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:currentDay];

    if ([today timeIntervalSinceDate:currentDay] <= ([todayComp weekday] - 1)*D_DAY) {
        //本周
        return @"本周";
    }else if (currentComp.year == todayComp.year && currentComp.month == todayComp.month) {
        //本月
        return @"本月";
    }else {
        //年月日
        [dateFormatter setDateFormat:@"yyyy/MM"];
        return [dateFormatter stringFromDate:currentDay];
    }
}

#pragma mark 获取零时区的毫秒值
+ (NSString *)getTimeZoneMs{
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%llu",recordTime];
}

#pragma mark 获取零时区时间
+ (NSString *)getTimeZone{
    
    // 获得时间对象
    NSDate *date = [NSDate date];
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:TIME_Formatter2];
    
    return [dateFormatter stringFromDate:date];
}

#pragma mark 毫秒转时间
+ (NSString *)msToDateWithMs:(NSString *)ms{
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[ms longLongValue]/1000.0];
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:TIME_Formatter];
    
    return [dateformat stringFromDate:date];
}

#pragma mark 时间转毫秒
+ (NSString *)dateToMsWithDate:(NSString *)date{
    
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:TIME_Formatter];
    NSDate *msDate = [dateformat dateFromString:date];
    
    UInt64 recordTime = [msDate timeIntervalSince1970]*1000;
    
    return [NSString stringWithFormat:@"%llu",recordTime];
}

@end
