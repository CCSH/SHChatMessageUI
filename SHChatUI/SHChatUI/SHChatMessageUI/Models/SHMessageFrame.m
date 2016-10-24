//
//  SHMessageFrame.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/30.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageFrame.h"
#import "SHMessage.h"
#import "SHMessageMacroHeader.h"
#import "SHMessageTimeHelper.h"

@implementation SHMessageFrame

- (void)setMessage:(SHMessage *)message{
    
    _message = message;
    
    if (message.messageType == SHMessageBodyType_Prompt) {//提示消息显示时间
        _showName = NO;
    }
    
    CGFloat messageY = 0;
    
    // 1、计算时间的位置
    if (_showTime){
        
        NSDictionary *timeDic = [[NSDictionary alloc]initWithObjectsAndKeys:ChatTimeFont,NSFontAttributeName, nil];
        CGSize timeSize = [[SHMessageTimeHelper setFormattingMessageTime:message.sendTime] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:timeDic context:nil].size;
        
        CGFloat timeX = (kSHWIDTH - timeSize.width - 15) / 2;
        messageY = messageY + ChatMargin;
        _timeF = CGRectMake(timeX, messageY, timeSize.width + ChatTimeMarginW, timeSize.height + ChatTimeMarginH);
        messageY = messageY + _timeF.size.height;
    }
    
    
    // 2、计算头像位置
    CGFloat iconX = ChatMargin;
    messageY = messageY + ChatMargin;
    if (_message.bubbleMessageType == SHBubbleMessageType_Sending) {
        iconX = kSHWIDTH - ChatMargin - ChatIconWH;
    }
    _iconF = CGRectMake(iconX, messageY, ChatIconWH, ChatIconWH);
    
    // 3、计算ID位置
    if (_showName){

        NSDictionary *nameDic = [[NSDictionary alloc]initWithObjectsAndKeys:ChatTimeFont,NSFontAttributeName, nil];
        CGSize nameSize = [message.userName boundingRectWithSize:CGSizeMake(ChatContentW, CGFLOAT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin attributes:nameDic context:nil].size;
        
        CGFloat nameX = 2*ChatMargin + ChatIconWH;
        if (_message.bubbleMessageType == SHBubbleMessageType_Sending) {
            nameX = kSHWIDTH - nameX - nameSize.width;
        }
        _nameF = CGRectMake(nameX, messageY , nameSize.width, nameSize.height);
        messageY = messageY + _nameF.size.height;
    }
    
    // 4、计算内容位置
    //根据消息类型
    CGSize contentSize;
    switch (_message.messageType) {
        case SHMessageBodyType_Text:
        {
            //文字
            NSDictionary *contentDic = [[NSDictionary alloc]initWithObjectsAndKeys:ChatContentFont,NSFontAttributeName, nil];
            contentSize = [message.text boundingRectWithSize:CGSizeMake(ChatContentW, CGFLOAT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil].size;
        }
            break;
        case SHMessageBodyType_Image:
            //图片
            contentSize = CGSizeMake(ChatPicWH, ChatPicWH);
            
            break;
        case SHMessageBodyType_Voice:
            //语音
            contentSize = CGSizeMake((ChatVoiceW/kSHMaxRecordTime)*[message.voiceDuration intValue] + 40, 20);
            if (contentSize.width > ChatVoiceW) {//限制最大宽
                contentSize.width = ChatVoiceW;
            }
            
            break;
        case SHMessageBodyType_Location:
            //位置
            contentSize = CGSizeMake(ChatLocationW, ChatLocationH);
            
            break;
        case SHMessageBodyType_Video:
            //视频
            contentSize = CGSizeMake(ChatLocationWH, ChatLocationWH);
            
            break;
        case SHMessageBodyType_Prompt:
        {
            //提示
            NSDictionary *contentDic = [[NSDictionary alloc]initWithObjectsAndKeys:ChatPromptContentFont,NSFontAttributeName, nil];
            contentSize = [message.promptContent boundingRectWithSize:CGSizeMake(ChatPromptW, CGFLOAT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil].size;
        }
            break;
        case SHMessageBodyType_Card:
        {
            //名片
            contentSize = CGSizeMake(ChatCardW, ChatCardH);
        }
            break;
        default:
            break;
    }
    CGFloat contentX = CGRectGetMaxX(_iconF) + ChatMargin;
    
    if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
        contentX = iconX - contentSize.width - ChatContentLeft - ChatContentRight - ChatMargin;
    }
    
    //内容
    if (message.messageType == SHMessageBodyType_Prompt) {//提示消息
        contentX = (kSHWIDTH - contentSize.width - 2*ChatContentLR)/2;
        _contentF = CGRectMake(contentX, messageY, contentSize.width + 2*ChatContentLR, contentSize.height + 2*ChatContentTB);
    }else{
        _contentF = CGRectMake(contentX, messageY, contentSize.width + ChatContentLeft + ChatContentRight, contentSize.height + ChatContentTop + ChatContentBottom);
    }
    
    _cellHeight = CGRectGetMaxY(_contentF)  + ChatMargin;
    
}


@end
