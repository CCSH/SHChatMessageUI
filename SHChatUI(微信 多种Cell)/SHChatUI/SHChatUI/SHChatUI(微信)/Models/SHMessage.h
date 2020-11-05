//
//  SHMessage.h
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHMessageHeader.h"
#import "SHMessageType.h"

/**
 聊天界面模型
 */
@interface SHMessage : NSObject

//当前聊天界面ID
@property (nonatomic, copy) NSString *chatId;

//消息公共内容
//消息ID
@property (nonatomic, copy) NSString *messageId;
//消息归属人的用户ID
@property (nonatomic, copy) NSString *userId;
//消息归属人的用户名
@property (nonatomic, copy) NSString *userName;
//消息归属人的头像Url
@property (nonatomic, copy) NSString *avator;

//消息的发送时间
@property (nonatomic, copy) NSString *sendTime;
//服务器时间(用于消息撤回)
@property (nonatomic, copy) NSString *severTime;
//消息的是否已读
@property (nonatomic, assign) BOOL isRead;
//消息的内容是否已读
@property (nonatomic, assign) BOOL messageRead;

//消息类型
@property (nonatomic, assign) SHMessageBodyType messageType;
//聊天类型
@property (nonatomic, assign) SHChatType chatType;
//消息状态
@property (nonatomic, assign) SHSendMessageStatus messageState;
//消息发送与接收
@property (nonatomic, assign) SHBubbleMessageType bubbleMessageType;

//所有资源文件(公共字段)
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileUrl;
@property (nonatomic, copy) NSString *fileSize;

//文本
@property (nonatomic, copy) NSString *text;
//图片
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *originUrl;
//视频
@property (nonatomic, assign) CGFloat videoWidth;
@property (nonatomic, assign) CGFloat videoHeight;
@property (nonatomic, copy) NSString *videoDuration;
//语音
@property (nonatomic, copy) NSString *audioDuration;
//位置
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, assign) CGFloat lon;
@property (nonatomic, assign) CGFloat lat;
//提示
@property (nonatomic, copy) NSString *note;
//名片
@property (nonatomic, copy) NSString *card;
//红包
@property (nonatomic, copy) NSString *redPackage;
@property (nonatomic, assign) BOOL isReceive;//是否可以领取
//通话
@property (nonatomic, strong) NSString *callInfo;
//Gif
@property (nonatomic, copy) NSString *gifName;
@property (nonatomic, copy) NSString *gifUrl;
@property (nonatomic, assign) CGFloat gifWidth;
@property (nonatomic, assign) CGFloat gifHeight;
//文件
@property (nonatomic, copy) NSString *displayName;


@end
