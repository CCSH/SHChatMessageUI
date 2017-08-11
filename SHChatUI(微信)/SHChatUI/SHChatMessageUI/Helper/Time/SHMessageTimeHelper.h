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
 *  格式化时间
 *
 *  @param messageTime 时间
 *
 *  @return 格式化后的时间
 */
+ (NSString *)setFormattingMessageTime:(NSString *)messageTime;
/**
 *  是否显示时间
 *
 *  @param onTime   上一条时间
 *  @param thisTime 此条时间
 *
 *  @return YES、NO
 */
+ (BOOL)isShowMessageTimeWithOnTime:(NSString *)onTime ThisTime:(NSString *)thisTime;

@end
