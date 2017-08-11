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
typedef enum : NSUInteger {
    
    SHBubbleMessageType_Sending = 0, // 发送
    SHBubbleMessageType_Receiving // 接收
}SHBubbleMessageType;

/**
 *  聊天类型
 */
typedef enum : NSUInteger {
    
    SHChatType_Chat = 0,    //单聊
    SHChatType_GroupChat,   //群聊
    SHChatType_Public,      //公众号
} SHChatType;

/**
 *  消息类型
 */
typedef enum : NSUInteger {

    SHMessageBodyType_Text = 0,         //0 文本类型
    SHMessageBodyType_Image,            //1 图片类型
    SHMessageBodyType_Card,             //2 名片类型
    SHMessageBodyType_Voice,            //3 语音类型
    SHMessageBodyType_Location,         //4 位置类型
    SHMessageBodyType_Note,             //5 提示类型
    SHMessageBodyType_RedPaper,         //6 红包类型
    SHMessageBodyType_RedPaperNote,     //7 红包提示类型
    SHMessageBodyType_Phone,            //8 通话类型
    SHMessageBodyType_Burn,             //9 阅后即焚类型
    SHMessageBodyType_Read,             //10 已读类型
    SHMessageBodyType_FriendNote,       //11 朋友圈通知类型
    SHMessageBodyType_VoiceEmail,       //12 语音信箱类型
    SHMessageBodyType_Gif,              //13 Gif类型
    SHMessageBodyType_ReCall,           //14 撤回消息类型
    SHMessageBodyType_Video,            //15 视频类型
    
    SHMessageBodyType_File,             //文件类型
    SHMessageBodyType_Command,          //命令类型
    SHMessageBodyType_Other,            //其他类型
} SHMessageBodyType;

/**
 *  群组通知消息类型
 */
typedef enum : NSUInteger {
    
    SHMessageBodyGroupType_Name = 1001,  //修改群组名
    SHMessageBodyGroupType_Not,         //修改群组公告
    SHMessageBodyGroupType_Nick,        //群成员修改在群中的昵称
    SHMessageBodyGroupType_Create,      //创建群组
    SHMessageBodyGroupType_Add,         //添加成员
    SHMessageBodyGroupType_Delete,      //删除成员
    SHMessageBodyGroupType_QrCode,      //扫码进群
    SHMessageBodyGroupType_Face,        //面对面进群
} SHMessageBodyGroupType;

/**
 *  红包通知消息类型
 */
typedef enum : NSUInteger {
    
    SHMessageBodyRedType_Solo = 110,        //单人
    SHMessageBodyRedType_Group = 120,       //群组
    SHMessageBodyRedType_Out = 130,         //被领取
    SHMessageBodyRedType_TimeOut = 140,     //退款
    SHMessageBodyRedType_In = 150,          //领取
} SHMessageBodyRedType;

/**
 *  朋友圈通知消息类型
 */
#define SHMessageFriendNoteType_Notify      @"notify"       //发布朋友圈
#define SHMessageFriendNoteType_Comment     @"comment"      //评论
#define SHMessageFriendNoteType_DropComment @"dropComment"  //取消评论
#define SHMessageFriendNoteType_Praise      @"praise"       //点赞
#define SHMessageFriendNoteType_DropPraise  @"dropPraise"   //取消点赞

/**
 *  消息发送状态
 */
typedef enum : NSUInteger {
    
    SHSendMessageType_Delivering = 0,   //发送中
    SHSendMessageType_Successed,        //发送成功
    SHSendMessageType_Failed,           //发送失败
}SHSendMessageStatus;

/**
 *  输入框类型
 */
typedef enum : NSUInteger {
    
    SHInputViewType_Normal = 0, //默认
    SHInputViewType_Text,       //文本
    SHInputViewType_Voice,      //语音
    SHInputViewType_Burn,       //阅后即焚
    SHInputViewType_Emotion,    //表情
    SHInputViewType_ShareMenu,  //多媒体更多
    SHInputViewType_Picture,    //相册
    SHInputViewType_Camera,     //相机
 } SHInputViewType;

/**
 *  地图类型
 */
typedef enum : NSUInteger {
    
    SHMessageLocationType_Location = 0,   //定位
    SHMessageLocationType_Look            //查看
}SHMessageLocationType;

/**
 *  点击类型
 */
typedef enum : NSUInteger {
    
    SHMessageClickType_Click = 0,   //点击
    SHMessageClickType_Long,        //长按
}SHMessageClickType;

@interface SHMessageType : NSObject


@end
