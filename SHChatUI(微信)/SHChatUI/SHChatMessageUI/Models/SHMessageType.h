//
//  SHMessageType.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Type类型定义
 */

/**
 *  发送方
 */
typedef enum{
    
    SHBubbleMessageType_Sending = 0, // 发送
    SHBubbleMessageType_Receiving // 接收
}SHBubbleMessageType;

/**
 *  聊天类型
 */
typedef enum{
    
    SHChatType_Chat = 1,  //单聊
    SHChatType_GroupChat  //群聊
    
}SHChatType;

/**
 *  消息发送状态
 */
typedef enum{
    
    SHSendMessageType_Successed = 1,  //发送成功
    SHSendMessageType_Failed,         //发送失败
    SHSendMessageType_Delivering      //发送中
    
}SHSendMessageStatus;

/**
 *  消息类型
 */
typedef enum {
    
    SHMessageBodyType_Text = 1,  //文本类型
    SHMessageBodyType_Image,     //图片类型
    SHMessageBodyType_Video,     //视频类型
    SHMessageBodyType_Location,  //位置类型
    SHMessageBodyType_Voice,     //语音类型
    SHMessageBodyType_Card,      //名片类型
    SHMessageBodyType_File,      //文件类型
    SHMessageBodyType_Command,   //命令类型
    SHMessageBodyType_RedPaper,  //红包类型
    SHMessageBodyType_Prompt,    //提示类型
    SHMessageBodyType_Other      //其他类型
    
}SHMessageBodyType;

/**
 *  输入框类型
 */
typedef enum {
    SHInputViewType_Normal = 1,
    SHInputViewType_Text,
    SHInputViewType_Voice,
    SHInputViewType_Emotion,
    SHInputViewType_ShareMenu,
}SHInputViewType;

/**
 *  地图类型
 */
typedef enum {
    
    SHMessageLocationType_Location = 1,   //定位
    SHMessageLocationType_Look            //查看
    
}SHMessageLocationType;

/**
 *  点击类型
 */
typedef enum {
    
    SHMessageClickType_Click = 1,   //点击
    SHMessageClickType_Long,        //长按
    
}SHMessageClickType;

/**
 *  聊天界面风格
 */
typedef enum {
    
    SHMessageStyle_Default = 1,   //默认
    SHMessageStyle_WeChat,        //微信
    
}SHMessageStyle;

@interface SHMessageType : NSObject

+ (NSString *)messageTypeWithType:(SHMessageBodyType)type;

+ (SHMessageBodyType)messageTypeWithStr:(NSString *)str;

@end
