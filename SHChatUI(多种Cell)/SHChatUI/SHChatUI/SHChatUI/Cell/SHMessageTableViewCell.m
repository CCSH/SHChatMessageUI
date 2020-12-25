//
//  SHMessageTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/6/7.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHMessageTableViewCell.h"
#import <Foundation/Foundation.h>
#import "SHMessageFrame.h"

@interface SHMessageTableViewCell ()

@end

@implementation SHMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 懒加载
#pragma mark 创建时间
- (UILabel *)labelTime{
    if (!_labelTime) {
        _labelTime = [[UILabel alloc] init];
        _labelTime.textAlignment = NSTextAlignmentCenter;
        _labelTime.textColor = [UIColor whiteColor];
        _labelTime.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _labelTime.layer.masksToBounds = YES;
        _labelTime.layer.cornerRadius = 5;
        _labelTime.font = kChatFont_time;
        [self.contentView addSubview:_labelTime];
    }
    return _labelTime;
}

#pragma mark 创建ID
- (UILabel *)labelNum{
    if (!_labelNum) {
        _labelNum = [[UILabel alloc] init];
        _labelNum.textColor = [UIColor grayColor];
        _labelNum.textAlignment = NSTextAlignmentCenter;
        _labelNum.font = kChatFont_name;
        [self.contentView addSubview:_labelNum];
    }
    return _labelNum;
}

#pragma mark 创建头像
- (UIButton *)btnHeadImage{
    if (!_btnHeadImage) {
        _btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnHeadImage.layer.cornerRadius = 5;
        _btnHeadImage.layer.masksToBounds = YES;
        //点击头像
        [_btnHeadImage addTarget:self action:@selector(didSelectHeadImage)  forControlEvents:UIControlEventTouchUpInside];
        //长按头像
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongHeadImage:)];
        
        [_btnHeadImage addGestureRecognizer:longTap];
        [self.contentView addSubview:_btnHeadImage];
    }
    return _btnHeadImage;
}

#pragma mark 创建内容
- (SHBubbleButton *)bubbleBtn{
    if (!_bubbleBtn) {
        _bubbleBtn = [SHBubbleButton buttonWithType:UIButtonTypeCustom];
        [_bubbleBtn addTarget:self action:@selector(didSelectMessage) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_bubbleBtn];
    }
    return _bubbleBtn;
}

#pragma mark 消息发送状态视图
- (SHActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[SHActivityIndicatorView alloc]init];
        [_activityView addTarget:self action:@selector(repeatClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_activityView];
    }
    return _activityView;
}

#pragma mark - 内容及Frame设置
- (void)setMessageFrame:(SHMessageFrame *)messageFrame {
    
    _messageFrame = messageFrame;
    SHMessage *message = messageFrame.message;
    
    // 初始化 (如果不显示时间、头像、ID，在frame中就没有计算)
    //发送状态
    self.activityView.hidden = YES;
    
    BOOL isSend = (message.bubbleMessageType == SHBubbleMessageType_Send);
    
    // 设置时间
    self.labelTime.frame = messageFrame.timeF;
    self.labelTime.text = [SHMessageHelper getChatTimeWithTime:message.sendTime];
    
    // 设置头像
    self.btnHeadImage.frame = messageFrame.iconF;
    [self.btnHeadImage setBackgroundImage:[UIImage imageNamed:message.avator] forState:0];
    
    // 设置昵称
    self.labelNum.frame = messageFrame.nameF;
    self.labelNum.text = message.userName;
    if (isSend) {
        self.labelNum.textAlignment = NSTextAlignmentRight;
    }else{
        self.labelNum.textAlignment = NSTextAlignmentLeft;
    }
    
    // 设置内容
    self.bubbleBtn.frame = messageFrame.contentF;
    UIImage *image = nil;
    // 设置聊天气泡背景
    if (isSend) {
        image = [SHFileHelper imageNamed:@"chat_message_send"];
    }else{
        image = [SHFileHelper imageNamed:@"chat_message_receive"];
    }
    
    [self.bubbleBtn setBubbleImage:image];
    
    // 设置发送状态样式
    self.activityView.messageState = message.messageState;
    
    // 发送状态
    if (isSend && message.messageState != SHSendMessageType_Successed) {
        self.activityView.frame = CGRectMake(self.bubbleBtn.x - (5 + 20), self.bubbleBtn.y + (self.bubbleBtn.height - 20)/2, 20, 20);
    }
    
    // 添加长按内容
    if (message.messageType != SHMessageBodyType_note &&
        message.messageType != SHMessageBodyType_redPaper) {
        //长按内容
        UILongPressGestureRecognizer *longContent = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongMessage:)];
        longContent.minimumPressDuration = 0.4;
        [self.bubbleBtn addGestureRecognizer:longContent];
    }
}

#pragma mark - 点击事件
#pragma mark 点击头像
- (void)didSelectHeadImage{
    if ([self.delegate respondsToSelector:@selector(didSelectWithCell:type:message:)])  {
        [self.delegate didSelectWithCell:self type:SHMessageClickType_click_head message:self.messageFrame.message];
    }
}

#pragma mark 长按头像
- (void)didLongHeadImage:(UILongPressGestureRecognizer *)tap {
    
    if (tap.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(didSelectWithCell:type:message:)])  {
            [self.delegate didSelectWithCell:self type:SHMessageClickType_long_head message:self.messageFrame.message];
        }
    }
}

#pragma mark 点击消息体
- (void)didSelectMessage{
    if ([self.delegate respondsToSelector:@selector(didSelectWithCell:type:message:)])  {
        [self.delegate didSelectWithCell:self type:SHMessageClickType_click_message message:self.messageFrame.message];
    }
}

#pragma mark 长按消息体
- (void)didLongMessage:(UILongPressGestureRecognizer *)tap{

    if (tap.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(didSelectWithCell:type:message:)])  {
            
            self.tapPoint = [tap locationInView:self];
            [self.delegate didSelectWithCell:self type:SHMessageClickType_long_message message:self.messageFrame.message];
        }
    }
}

#pragma mark 点击重发
- (void)repeatClick{
    
    if (self.messageFrame.message.messageState == SHSendMessageType_Failed) {
        if ([self.delegate respondsToSelector:@selector(didSelectWithCell:type:message:)])  {
            [self.delegate didSelectWithCell:self type:SHMessageClickType_click_retry message:self.messageFrame.message];
        }
    }
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
