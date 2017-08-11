//
//  SHMessageFrame.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/30.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageFrame.h"
#import "SHMessageMacroHeader.h"
#import "SHMessageTimeHelper.h"
#import "SHEmotionTool.h"

@implementation SHMessageFrame

- (void)setMessage:(SHMessage *)message{
    
    _message = message;
    
    if (message.messageType == SHMessageBodyType_Note || message.messageType == SHMessageBodyType_RedPaperNote || message.messageType == SHMessageBodyType_ReCall) {//提示的消息
        _showName = NO;
    }
    
    CGFloat messageY = 0;
    
    // 1、计算时间的位置
    if (_showTime){
    
        CGSize timeSize = [message.sendTime.chatTime boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ChatTimeFont} context:nil].size;
        
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

        CGSize nameSize = [message.userName boundingRectWithSize:CGSizeMake(ChatContentW, CGFLOAT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ChatTimeFont} context:nil].size;
        
        CGFloat nameX = 2*ChatMargin + ChatIconWH;
        if (_message.bubbleMessageType == SHBubbleMessageType_Sending) {
            nameX = kSHWIDTH - nameX - nameSize.width;
        }
        _nameF = CGRectMake(nameX, messageY , nameSize.width, nameSize.height);
        messageY = messageY + _nameF.size.height;
    }
    
    // 4、计算内容位置
    //根据消息类型
    CGSize contentSize = CGSizeZero;
    
    //判断消息类型
    switch (_message.messageType) {
        case SHMessageBodyType_Text://文字
        {
            contentSize = [message.text boundingRectWithSize:CGSizeMake(ChatContentW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ChatContentFont} context:nil].size;
        }
            break;
        case SHMessageBodyType_Image://图片
        {
            contentSize = [SHMessageImageHelper getSizeWithMaxSize:CGSizeMake(ChatPicWH, ChatPicWH) Size:CGSizeMake(self.message.imageWidth, self.message.imageHeight)];
        }
            break;
        case SHMessageBodyType_Voice://语音
        {
            contentSize = CGSizeMake((ChatVoiceW/kSHMaxRecordTime)*[message.voiceDuration intValue] + 20, ChatVoiceH);
            if (contentSize.width > ChatVoiceW) {//限制最大宽
                contentSize.width = ChatVoiceW;
            }
        }
            break;
        case SHMessageBodyType_Location://位置
        {
            contentSize = CGSizeMake(ChatLocationW, ChatLocationH);
        }
            break;
        case SHMessageBodyType_Note://提示
        {
            contentSize = [message.promptContent boundingRectWithSize:CGSizeMake(ChatPromptW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ChatPromptContentFont} context:nil].size;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 10) {
                contentSize.height += 5;
            }
        }
            break;
        case SHMessageBodyType_RedPaperNote://红包提示
        {
            contentSize = [message.promptContent boundingRectWithSize:CGSizeMake(ChatPromptW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ChatPromptContentFont} context:nil].size;
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 10) {
                contentSize.height += 5;
            }
        }
            break;
        case SHMessageBodyType_Card://名片
        {
            contentSize = CGSizeMake(ChatCardW, ChatCardH);
        }
            break;
        case SHMessageBodyType_RedPaper://红包
        {
            contentSize = CGSizeMake(ChatRedPackageW, ChatRedPackageH);
        }
            break;
        case SHMessageBodyType_Phone://通话
        {

        }
            break;
        case SHMessageBodyType_Burn://阅后即焚
        {
            contentSize = CGSizeMake(ChatBurnW, ChatBurnH);
        }
            break;
        case SHMessageBodyType_Gif://Gif
        {
            contentSize = [SHMessageImageHelper getSizeWithMaxSize:CGSizeMake(ChatGifWH, ChatGifWH) Size:CGSizeMake(self.message.gifWidth, self.message.gifHeight)];
        }
            break;
        case SHMessageBodyType_VoiceEmail://语音信箱
        {
            contentSize = CGSizeMake(ChatVoiceW, ChatVoiceH);
        }
            break;
        case SHMessageBodyType_ReCall://撤回
        {
            contentSize = [message.promptContent boundingRectWithSize:CGSizeMake(ChatPromptW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ChatPromptContentFont} context:nil].size;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 10) {
                contentSize.height += 5;
            }
        }
            break;
        case SHMessageBodyType_Video://视频
        {
            contentSize = CGSizeMake(ChatVideoWH, ChatVideoWH);
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
    if (message.messageType == SHMessageBodyType_Note || message.messageType == SHMessageBodyType_RedPaperNote || message.messageType == SHMessageBodyType_ReCall) {//提示的消息
        contentX = (kSHWIDTH - contentSize.width - 2*ChatContentLR)/2;
        _contentF = CGRectMake(contentX, messageY, contentSize.width + 2*ChatContentLR, contentSize.height + 2*ChatContentTB);
    }else{
        _contentF = CGRectMake(contentX, messageY, contentSize.width + ChatContentLeft + ChatContentRight, contentSize.height + ChatContentTop + ChatContentBottom);
    }
    
    _cellHeight = CGRectGetMaxY(_contentF)  + ChatMargin;
}

@end
