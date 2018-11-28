//
//  SHMessageFrame.m
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHMessageFrame.h"

@implementation SHMessageFrame

#pragma mark - 修改一些数据源与界面frame的计算
- (void)setMessage:(SHMessage *)message{
    _message = message;
    
    //数据源的一些修改
    //这些消息状态只有成功
    switch (message.messageType) {
        case SHMessageBodyType_redPaper:case SHMessageBodyType_note://红包、通知
        {
            message.messageState = SHSendMessageType_Successed;
        }
            break;
        default:
            break;
    }
    
    // 判断特殊消息
    BOOL isSpecial = (message.messageType == SHMessageBodyType_note);
    // 判断收发
    BOOL  isSend = (message.bubbleMessageType == SHBubbleMessageType_Sending);
    
    // 特殊消息不显示用户名
    if (isSpecial) {
        _showName = NO;
    }
    
    CGFloat content_y = 0;
    
    // 计算时间
    if (_showTime){
        
        content_y = content_y + kChat_margin;
        
        CGSize timeSize = [[SHMessageHelper getChatTimeWithTime:message.sendTime] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kChat_content_maxW) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kChatFont_time} context:nil].size;

        CGFloat timeX = (kSHWidth - timeSize.width - 2*kChat_margin_time) / 2;
        _timeF = CGRectMake(timeX, content_y, timeSize.width + 2*kChat_margin_time, timeSize.height + 2*kChat_margin_time);
        
        content_y = content_y + _timeF.size.height + kChat_margin;
    }
    
    // 计算头像
    if (!isSpecial) {//特殊消息没有头像
        
        content_y = content_y + kChat_margin;
        
        CGFloat iconX = kChat_margin;
        if (isSend) {//发送方
            iconX = kSHWidth - kChat_margin - kChat_icon_wh;
        }
        _iconF = CGRectMake(iconX, content_y, kChat_icon_wh, kChat_icon_wh);
    }
    
    // 计算用户名
    if (_showName){
        CGFloat nameX = kChat_margin + kChat_icon_wh  + kChat_margin + kChat_angle_w;
        _nameF = CGRectMake(nameX, content_y , kSHWidth - 2*nameX, kChat_name_h);
        content_y = content_y + kChat_name_h;
    }
    
    // 计算整体聊天气泡的Size
    CGSize contentSize = CGSizeZero;
    // 判断消息类型
    switch (_message.messageType) {
        case SHMessageBodyType_text://文字
        {
            NSMutableAttributedString *str = [SHEmotionTool getAttWithStr:message.text font:kChatFont_content];
            
            contentSize = [str boundingRectWithSize:CGSizeMake((kChat_content_maxW - 2*kChat_angle_w), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            
            //其他微调
            if (kChatFont_content.lineHeight < kChat_min_h) {//为了使聊天内容与最小高度对齐
                contentSize.height += (kChat_min_h - kChatFont_content.lineHeight);
            }else{
                contentSize.height += 2*kChat_margin;
            }
            contentSize.width += (2*kChat_margin + kChat_angle_w);
        }
            break;
        case SHMessageBodyType_image://图片
        {
            contentSize = [SHMessageHelper getSizeWithMaxSize:CGSizeMake(kChat_pic_wh, kChat_pic_wh) size:CGSizeMake(message.imageWidth, message.imageHeight)];
        }
            break;
        case SHMessageBodyType_voice://语音
        {
            contentSize = CGSizeMake(((kChat_voice_maxW - 60)/kSHMaxRecordTime)*[message.voiceDuration intValue] + 60, kChat_min_h);
            if (contentSize.width > kChat_voice_maxW) {//限制最大宽
                contentSize.width = kChat_voice_maxW;
            }
            contentSize.width +=  kChat_angle_w;
        }
            break;
        case SHMessageBodyType_location://位置
        {
            contentSize = CGSizeMake(kChat_location_w, kChat_location_h);
        }
            break;
        case SHMessageBodyType_note://通知
        {
            contentSize = [message.note boundingRectWithSize:CGSizeMake(kChat_content_maxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kChatFont_note} context:nil].size;
            //要预留出来边距
            contentSize.height += 2*kChat_margin;
            contentSize.width += 2*kChat_margin;
        }
            break;
        case SHMessageBodyType_card://名片
        {
            contentSize = CGSizeMake(kChat_card_w, kChat_card_h);
            contentSize.width +=  kChat_angle_w;
        }
            break;
        case SHMessageBodyType_redPaper://红包
        {
            contentSize = CGSizeMake(kChat_redPackage_w, kChat_redPackage_h);
            contentSize.width +=  kChat_angle_w;
        }
            break;
        case SHMessageBodyType_gif://Gif
        {
            contentSize = [SHMessageHelper getSizeWithMaxSize:CGSizeMake(kChat_gif_wh, kChat_gif_wh) size:CGSizeMake(self.message.gifWidth, self.message.gifHeight)];
        }
            break;
        case SHMessageBodyType_video://视频
        {
            contentSize = CGSizeMake(kChat_video_wh, kChat_video_wh);
        }
            break;
        default:
            break;
    }
    
    CGFloat content_x = 0;
    
    if (isSpecial) {//特殊消息 居中显示
        
        content_x = (kSHWidth - contentSize.width)/2;
        
    }else{//其他消息 根据发送方X轴不一样
        
        content_x = CGRectGetMaxX(_iconF) + kChat_margin;
        if (isSend) {
            content_x = CGRectGetMidX(_iconF) - kChat_margin - contentSize.width - 2*kChat_margin;
        }
    }
    
    //聊天气泡frame
    _contentF = CGRectMake(content_x, content_y, contentSize.width, contentSize.height);
    //cell高度
    _cell_h = CGRectGetMaxY(_contentF)  + kChat_margin;
}

@end
