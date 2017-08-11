//
//  SHMessageHelper.m
//  iOSAPP
//
//  Created by CSH on 2016/11/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageHelper.h"

@implementation SHMessageHelper

#pragma mark - 添加公共参数
+ (SHMessage *)addPublicParameterWidthSHMessage:(SHMessage *)message{
    
    //设置消息归属人信息
    message.userId = @"user_12345";
    message.userAvatarUrl = @"12345";
    message.userName = @"小明";
    
    message.sendTime = [SHMessageTimeHelper getTimeZoneMs];
    message.messageId = [NSString stringWithFormat:@"MO_%@",[SHMessageTimeHelper getTimeZoneMs]];
    
    if (message.messageType == SHMessageBodyType_RedPaper || message.messageType == SHMessageBodyType_Phone || message.messageType == SHMessageBodyType_Note) {//红包消息、通话消息、提示消息
        message.messageState = SHSendMessageType_Successed;
    }else{
        message.messageState = SHSendMessageType_Delivering;
    }
    
    message.bubbleMessageType = SHBubbleMessageType_Sending;
    message.isRead = YES;
    message.messageRead = YES;
    
    //模拟数据
    message.bubbleMessageType = arc4random() % 2;

    if (message.bubbleMessageType == SHBubbleMessageType_Receiving) {
        message.messageState = SHSendMessageType_Successed;
        if (message.messageType == SHMessageBodyType_Voice) {
            message.isRead = NO;
            message.messageRead = NO;
        }
    }
 
    return message;
}

@end
