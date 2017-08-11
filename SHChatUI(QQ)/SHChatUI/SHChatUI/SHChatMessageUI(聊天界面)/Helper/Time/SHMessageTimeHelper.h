//
//  SHMessageTimeHelper.h
//  SHChatMessageUI
//
//  Created by CSH on 16/8/1.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMessageTimeHelper : NSObject

/**
 *  是否显示时间
 *
 *  @param onTime   上一条时间
 *  @param thisTime 此条时间
 *
 *  @return YES、NO
 */
+ (BOOL)isShowMessageTimeWithOnTime:(NSString *)onTime ThisTime:(NSString *)thisTime;

/**
 获取零时区时间的毫秒值
 
 @return 毫秒
 */
+ (NSString *)getTimeZoneMs;


/**
 获取零时区时间

 @return yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)getTimeZone;

/**
 毫秒转时间
 
 @param ms 毫秒
 
 @return 时间（格式化后的）
 */
+ (NSString *)msToDateWithMs:(NSString *)ms;

/**
 时间转毫秒
 
 @param date 时间
 
 @return 毫秒
 */
+ (NSString *)dateToMsWithDate:(NSString *)date;


/**
 时间分段（本周，本月，年月）

 @param messageTime 毫秒
 @return 本周，本月，年月
 */
+ (NSString *)dealDataWithMessageTime:(NSString *)messageTime;

@end
