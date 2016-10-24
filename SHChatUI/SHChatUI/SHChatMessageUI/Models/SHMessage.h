//
//  SHMessage.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/25.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SHMessageType.h"

/**
 *  聊天界面模型
 */

@interface SHMessage : NSObject

//公共内容

//消息ID
@property (nonatomic, strong) NSString *messageID;
//用户信息
//头像Image
@property (nonatomic, strong) UIImage *avatarImage;
//头像Url
@property (nonatomic, copy) NSString *userAvatarUrl;
//用户ID
@property (nonatomic, copy) NSString *userId;
//用户名
@property (nonatomic, copy) NSString *userName;
//用户昵称
@property (nonatomic, copy) NSString *nickName;
//发送时间
@property (nonatomic, copy) NSString *sendTime;
//是否已读
@property (nonatomic, assign) BOOL isRead;

//消息类型
@property (nonatomic, assign) SHMessageBodyType messageType;
//聊天类型
@property (nonatomic, assign) SHChatType chatType;
//消息状态
@property (nonatomic, assign) SHSendMessageStatus messageState;
//消息发送与接收
@property (nonatomic, assign) SHBubbleMessageType bubbleMessageType;
//聊天界面风格
@property (nonatomic, assign) SHMessageStyle messageStyle;



//文本
@property (nonatomic, copy) NSString *text;
//图片
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *originPhotoUrl;
//视频
@property (nonatomic, strong) UIImage *videoImage;
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *videoUrl;
//语音
@property (nonatomic, copy) NSString *voicePath;
@property (nonatomic, copy) NSString *voiceUrl;
@property (nonatomic, copy) NSString *voiceDuration;
//位置
@property (nonatomic, strong) UIImage *locationImage;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, strong) CLLocation *location;
//提示
@property (nonatomic, copy) NSString *promptContent;
//名片
@property (nonatomic, strong) NSString *userInfo;







@end
