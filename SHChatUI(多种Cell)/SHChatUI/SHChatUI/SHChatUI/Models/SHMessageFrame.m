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
    
    //数据源的一些修改（计算时间、头像、id、聊天气泡大小）
    //这些消息状态只有成功
    switch (message.messageType) {
        case SHMessageBodyType_redPaper:
        case SHMessageBodyType_note:
        {//红包、通知
            message.messageState = SHSendMessageType_Successed;
        }
            break;
        default:
            break;
    }
    
    // 判断收发
    BOOL isSend = (message.bubbleMessageType == SHBubbleMessageType_Send);
    // 消息居中
    BOOL isCenter = NO;
    // 角
    BOOL isAngle = YES;
    
    // 计算整体聊天气泡的Size
    CGSize contentSize = CGSizeZero;
    // 判断消息类型
    switch (_message.messageType) {
        case SHMessageBodyType_text://文字
        {
            //TODO: 有表情计算高度偏高
            NSMutableAttributedString *att = (NSMutableAttributedString *)[SHEmotionTool getAttWithStr:message.text font:kChatFont_content];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5.0; // 设置行间距
            [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, att.length)];
            
            _att = att;
            contentSize = [SHTool getSizeWithAtt:att maxSize:CGSizeMake(kChat_content_maxW - 2*kChat_angle_w, CGFLOAT_MAX)];
            
            contentSize.height += 2*kChat_margin;
            
            if (contentSize.height < kChat_min_h) {//为了使聊天内容与最小高度对齐
                contentSize.height = kChat_min_h;
            }
            contentSize.width += 2*kChat_margin;
        }
            break;
        case SHMessageBodyType_image://图片
        {
            isAngle = NO;
            contentSize = [SHMessageHelper getSizeWithMaxSize:kChat_pic_size size:CGSizeMake(message.imageWidth, message.imageHeight) min:kChat_min_h];
        }
            break;
        case SHMessageBodyType_voice://语音
        {
            contentSize = CGSizeMake(((kChat_voice_size.width - 60)/kSHMaxRecordTime)*[message.audioDuration intValue] + 60, kChat_voice_size.height);
            if (contentSize.width > kChat_voice_size.width) {//限制最大宽
                contentSize.width = kChat_voice_size.width;
            }
        }
            break;
        case SHMessageBodyType_location://位置
        {
            contentSize = kChat_location_size;
        }
            break;
        case SHMessageBodyType_note://通知
        {
            isCenter = YES;
            contentSize = [SHTool getSizeWithStr:message.note font:kChatFont_note maxSize:CGSizeMake(kChat_content_maxW - 2*kChat_margin, CGFLOAT_MAX)];
            //要预留出来边距
            contentSize.height += 2*kChat_margin;
            contentSize.width += 2*kChat_margin;
            
            _showName = NO;
            _showAvatar = NO;
        }
            break;
        case SHMessageBodyType_card://名片
        {
            contentSize = kChat_card_size;
        }
            break;
        case SHMessageBodyType_redPaper://红包
        {
            contentSize = kChat_red_size;
        }
            break;
        case SHMessageBodyType_gif://Gif
        {
            isAngle = NO;
            contentSize = [SHMessageHelper getSizeWithMaxSize:kChat_gif_size size:CGSizeMake(self.message.gifWidth, self.message.gifHeight) min:kChat_min_h];
        }
            break;
        case SHMessageBodyType_video://视频
        {
            isAngle = NO;
            contentSize = [SHMessageHelper getSizeWithMaxSize:kChat_video_size size:CGSizeMake(message.videoWidth, message.videoHeight) min:kChat_min_h];
        }
            break;
        case SHMessageBodyType_file://文件
        {
            contentSize = kChat_file_size;
        }
            break;
        default:
            break;
    }
    
    // 计算Y轴
    CGFloat viewY = kChat_margin;
    
    // 计算时间
    _timeF = CGRectZero;
    if (_showTime){
        
        CGSize timeSize = [SHTool getSizeWithStr:[SHMessageHelper getChatTimeWithTime:message.sendTime] font:kChatFont_time maxSize:CGSizeMake(CGFLOAT_MAX, kChat_content_maxW)];
        
        CGFloat timeX = (kSHWidth - timeSize.width - 2*kChat_margin_time) / 2;
        _timeF = CGRectMake(timeX, viewY, timeSize.width + 2*kChat_margin_time, timeSize.height + 2*kChat_margin_time);
        
        viewY = CGRectGetMaxY(_timeF) + kChat_margin;
    }
    
    // 计算头像
    _iconF = CGRectZero;
    if (_showAvatar) {
        
        CGFloat iconX = kChat_margin;
        CGFloat iconY = viewY;
        if (isSend) {//发送方
            iconX = kSHWidth - iconX - kChat_icon;
        }
        
        if (_showName) {
            //显示名字则多出名字距离，保证名字Y中心
            iconY += kChat_name_h/2;
        }
        _iconF = CGRectMake(iconX, iconY, kChat_icon, kChat_icon);
    }
    
    // 计算用户名
    _nameF = CGRectZero;
    if (_showName){
        CGFloat nameX = kChat_margin + 4;
        if (_showAvatar) {
            nameX += kChat_margin + kChat_icon;
        }
        _nameF = CGRectMake(nameX, viewY, kSHWidth - 2*nameX, kChat_name_h);
        viewY = CGRectGetMaxY(_nameF) + 4;//微调
    }
    
    // 计算X轴
    CGFloat viewX = 0;
    
    // 气泡居中
    if (isCenter) {
        viewX = (kSHWidth - contentSize.width)/2;
    }else{//其他消息 根据发送方X轴不一样
        
        if (isAngle) {
            contentSize.width += kChat_angle_w;
        }
        
        viewX = CGRectGetMaxX(_iconF) + kChat_margin;
        if (isSend) {
            viewX = kSHWidth - kChat_margin - contentSize.width;
            if (_showAvatar) {
                viewX -= kChat_icon + kChat_margin;
            }
        }
        
        // 起始位置
        _startX = isSend ? 0 : kChat_angle_w;
        //角处理
        if (!isAngle) {
            if (isSend) {
                viewX -= kChat_angle_w;
            }else{
                viewX += kChat_angle_w;
            }
        }
    }
    
    //聊天气泡frame
    _contentF = CGRectMake(viewX, viewY, contentSize.width, contentSize.height);
    //cell高度
    _cell_h = CGRectGetMaxY(_contentF)  + kChat_margin;
}

@end
