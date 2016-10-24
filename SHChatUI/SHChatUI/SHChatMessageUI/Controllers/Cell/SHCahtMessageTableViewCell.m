//
//  SHCahtMessageTableViewCell.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/29.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHCahtMessageTableViewCell.h"
#import "SHMessageTimeHelper.h"
#import <Foundation/Foundation.h>
#import "SHMessageMacroHeader.h"

@interface SHCahtMessageTableViewCell ()<UIAlertViewDelegate>

@end

@implementation SHCahtMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 1、创建时间
        self.labelTime = [[UILabel alloc] init];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.textColor = [UIColor grayColor];
        self.labelTime.font = ChatTimeFont;
        [self.contentView addSubview:self.labelTime];
        
        // 2、创建ID
        self.labelNum = [[UILabel alloc] init];
        self.labelNum.textColor = [UIColor grayColor];
        self.labelNum.textAlignment = NSTextAlignmentCenter;
        self.labelNum.font = ChatTimeFont;
        [self.contentView addSubview:self.labelNum];
        
        // 3、创建头像
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        //点击
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        //长按头像
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(btnHeadImageLongClick:)];
        [self.btnHeadImage addGestureRecognizer:longTap];
        [self.contentView addSubview:self.btnHeadImage];
        
        // 4、创建内容
        self.btnContent = [SHMessageContentView buttonWithType:UIButtonTypeCustom];
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnContent];
        
        [self.btnContent.messgeActivity addTarget:self action:@selector(repeatClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //图片点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnContentClick)];
        [self.btnContent.imageMessageView addGestureRecognizer:tap];
        
    }
    return self;
}

#pragma mark 内容及Frame设置
- (void)setMessageFrame:(SHMessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    SHMessage *message = messageFrame.message;
    
    // 1、设置时间
    self.labelTime.frame = messageFrame.timeF;
    self.labelTime.text = [SHMessageTimeHelper setFormattingMessageTime:message.sendTime];
    
    // 2、设置头像
    self.btnHeadImage.frame = messageFrame.iconF;
    [self.btnHeadImage setBackgroundImage:message.avatarImage forState:UIControlStateNormal];
    
    // 3、设置昵称
    self.labelNum.frame = messageFrame.nameF;
    self.labelNum.text = message.userName;
    
    if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
        self.labelNum.textAlignment = NSTextAlignmentRight;
    }else{
        self.labelNum.textAlignment = NSTextAlignmentLeft;
    }
    
    
    // 4、设置内容
    self.btnContent.frame = messageFrame.contentF;
    
    // 5、初始化
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    
    self.btnContent.imageMessageView.hidden = YES;
    
    self.btnContent.voiceMessageView.hidden = YES;
    self.btnContent.voiceNum.hidden = YES;
    self.btnContent.readMarker.hidden = YES;
    
    self.btnContent.locationMessageView.hidden = YES;
    self.btnContent.locationMessageLabel.hidden = YES;
    
    self.btnContent.videoMessageView.hidden = YES;
    self.btnContent.videoIconMessageView.hidden = YES;
    
    self.btnContent.messgeActivity.hidden = YES;
    
    self.btnContent.promptLabel.hidden = YES;
    
    self.btnContent.cardMessageBg.hidden = YES;
    
    self.btnContent.message = message;
    
    // 6、字体颜色与偏移量
    
    if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
        
        [self.btnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft);
    }else{
        [self.btnContent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
    }
    
    // 7、设置发送状态
    if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
    
        self.btnContent.messgeActivity.hidden = (message.messageState == SHSendMessageType_Successed);
    }
    
    
    // 设置发送状态样式
    if (!self.btnContent.messgeActivity.hidden) {
        
        switch (message.messageState) {
            case SHSendMessageType_Delivering:
                [self.btnContent.messgeActivity showType:ShowActivityType_Activity];
                break;
            case SHSendMessageType_Failed:
                [self.btnContent.messgeActivity showType:ShowActivityType_Fail];
                break;
            case SHSendMessageType_Successed:
                
                break;
                
            default:
                break;
        }
    }
    
        
    // 8、设置聊天气泡背景
    UIImage *normal = nil;
        
    if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
        
        normal = [UIImage imageNamed:@"chat_message_send_1"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    }else{
        
        normal = [UIImage imageNamed:@"chat_message_receive_1"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    }
    
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    
    // 9、背景颜色与描边
    if (message.messageType == SHMessageBodyType_Prompt) {
        //提示框的背景颜色
        self.btnContent.backgroundColor = [[UIColor colorWithWhite:0.5 alpha:1] colorWithAlphaComponent:0.1];
        self.btnContent.layer.cornerRadius = 5;
    }else{
        self.btnContent.backgroundColor = [UIColor clearColor];
        self.btnContent.layer.cornerRadius = 0;
    }
    
    // 10、设置属性
    switch (message.messageType) {
        case SHMessageBodyType_Text:
        {
            self.btnContent.titleLabel.font = ChatContentFont;
            [self.btnContent setTitle:message.text forState:UIControlStateNormal];
        }
            break;
        case SHMessageBodyType_Image:
        {
            self.btnContent.imageMessageView.hidden = NO;
            self.btnContent.imageMessageView.image = message.photo;
            //编辑图片
            [self makeMaskView:self.btnContent.imageMessageView withImage:normal];
        }
            break;
        case SHMessageBodyType_Voice:
        {
            self.btnContent.voiceMessageView.hidden = NO;
            self.btnContent.readMarker.hidden = message.isRead;
            self.btnContent.voiceNum.hidden = !self.btnContent.messgeActivity.hidden;
            
            self.btnContent.voiceNum.text = [NSString stringWithFormat:@"%@\"",message.voiceDuration];
        }
            break;
        case SHMessageBodyType_Location:
        {
            self.btnContent.locationMessageView.hidden = NO;
            self.btnContent.locationMessageLabel.hidden = NO;
    
            self.btnContent.locationMessageView.image = message.locationImage;
            self.btnContent.locationMessageLabel.text = message.locationName;
            
            //编辑图片
            [self makeMaskView:self.btnContent.locationMessageView withImage:normal];
        }
            break;
        case SHMessageBodyType_Video:
        {
            self.btnContent.videoMessageView.hidden = NO;
            self.btnContent.videoIconMessageView.hidden = NO;

            self.btnContent.videoMessageView.image = message.videoImage;
            self.btnContent.videoIconMessageView.image = [UIImage imageNamed:@"chat_video.png"];
            
            //编辑
            [self makeMaskView:self.btnContent.videoMessageView withImage:normal];
        }
            break;
        case SHMessageBodyType_Prompt:
        {
            [self.btnContent setBackgroundImage:nil forState:UIControlStateNormal];
            self.btnContent.promptLabel.hidden = NO;
            
            self.btnContent.promptLabel.text = message.promptContent;
        }
            break;
        case SHMessageBodyType_Card:
        {
            self.btnContent.cardMessageBg.hidden = NO;
            
            self.btnContent.cardMessagePromptLabel.text = @"个人名片";
            self.btnContent.cardMessageLabel.text = message.userInfo;
            self.btnContent.cardMessageImage.image = [UIImage imageNamed:@"headImage.jpeg"];
         
            //编辑
            [self makeMaskView:self.btnContent.cardMessageBg withImage:normal];
        }
            break;
        default:
            break;
    }
    
    // 10、添加长按内容
    if (message.messageType != SHMessageBodyType_Prompt) {
        //长按内容
        UILongPressGestureRecognizer *longContent = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longContent:)];
        [self addGestureRecognizer:longContent];
    }
    
}


#pragma mark 剪切视图
- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}


#pragma mark 点击头像
- (void)btnHeadImageClick:(id)button
{
    if ([self.delegate respondsToSelector:@selector(headImageClick:message:clickType:)])  {
        [self.delegate headImageClick:self message:self.messageFrame.message clickType:SHMessageClickType_Click];
    }
}

#pragma mark 长按头像
- (void)btnHeadImageLongClick:(id)button
{
    if ([self.delegate respondsToSelector:@selector(headImageClick:message:clickType:)])  {
        [self.delegate headImageClick:self message:self.messageFrame.message clickType:SHMessageClickType_Long];
    }
}

#pragma mark 点击消息
- (void)btnContentClick
{
    if ([_delegate respondsToSelector:@selector(contentClick:message:clickType:)]) {
        [_delegate contentClick:self message:self.messageFrame.message clickType:SHMessageClickType_Click];
    }
}

#pragma mark 长按消息
- (void)longContent:(id)button{
    if ([_delegate respondsToSelector:@selector(contentClick:message:clickType:)]) {
        [_delegate contentClick:self message:self.messageFrame.message clickType:SHMessageClickType_Long];
    }
}

#pragma mark 点击重发
- (void)repeatClick:(id)button{
    if (self.messageFrame.message.messageState == SHSendMessageType_Failed) {
        UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否重发此条消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [ale show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(repeatClick:message:)]) {
            [self.delegate repeatClick:self message:self.messageFrame.message];
        }
    }
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
