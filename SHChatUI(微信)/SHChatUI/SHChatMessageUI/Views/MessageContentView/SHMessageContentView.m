//
//  SHMessageContentView.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/30.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageContentView.h"
#import "SHMessageMacroHeader.h"
#import "SHMessageFrame.h"

@implementation SHMessageContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //图片
        self.imageMessageView = [[UIImageView alloc]init];
        self.imageMessageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageMessageView];
        
        //语音
        self.voiceMessageView = [[UIImageView alloc]init];
        [self addSubview:self.voiceMessageView];
    
        //语音时长
        self.voiceNum = [[UILabel alloc]init];
        self.voiceNum.textColor = [UIColor lightGrayColor];
        self.voiceNum.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.voiceNum];
        
        //未读标记
        self.readMarker = [[UIImageView alloc]init];
        self.readMarker.image = [UIImage imageNamed:@"chat_voice_unread.png"];
        [self addSubview:self.readMarker];
        
        //动画
        self.voiceMessageView.animationDuration = 1;
        self.voiceMessageView.animationRepeatCount = 0;
        
        //位置背景
        self.locationMessageView = [[UIImageView alloc]init];
        [self addSubview:self.locationMessageView];
        
        //位置文字
        self.locationMessageLabel = [[UILabel alloc]init];
        self.locationMessageLabel.textColor = [UIColor whiteColor];
        self.locationMessageLabel.font = [UIFont systemFontOfSize:12];
        self.locationMessageLabel.numberOfLines = 0;
        self.locationMessageLabel.textAlignment = NSTextAlignmentCenter;
        [self.locationMessageView addSubview:self.locationMessageLabel];
        
        //视频
        self.videoMessageView = [[UIImageView alloc]init];
        self.videoMessageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.videoMessageView];
        
        //视频图标
        self.videoIconMessageView = [[UIImageView alloc]init];
        [self.videoMessageView addSubview:self.videoIconMessageView];
        
        //提示
        self.promptLabel = [[UILabel alloc]init];
        self.promptLabel.font = ChatPromptContentFont;
        self.promptLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.promptLabel];
        
        //名片
        //背景
        self.cardMessageBg = [[UIImageView alloc]init];
        self.cardMessageBg.backgroundColor = [UIColor whiteColor];
        self.cardMessageBg.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.cardMessageBg];
        //提示文字
        self.cardMessagePromptLabel = [[UILabel alloc]init];
        self.cardMessagePromptLabel.textColor = [UIColor grayColor];
        self.cardMessagePromptLabel.font = [UIFont systemFontOfSize:12];
        self.cardMessagePromptLabel.textAlignment = NSTextAlignmentLeft;
        [self.cardMessageBg addSubview:self.cardMessagePromptLabel];
        //分割线
        self.cardCuttingLine = [[UIView alloc]init];
        self.cardCuttingLine.backgroundColor = RGB(245, 245, 245, 1);
        [self.cardMessageBg addSubview:self.cardCuttingLine];
        //头像
        self.cardMessageImage = [[UIImageView alloc]init];
        self.cardMessageImage.contentMode = UIViewContentModeScaleToFill;
        [self.cardMessageBg addSubview:self.cardMessageImage];
        //姓名
        self.cardMessageLabel = [[UILabel alloc]init];
        self.cardMessageLabel.textColor = [UIColor blackColor];
        self.cardMessageLabel.numberOfLines = 0;
        self.cardMessageLabel.font = [UIFont systemFontOfSize:14];
        [self.cardMessageBg addSubview:self.cardMessageLabel];
        
        
        
        
        //其他信息
        self.messgeActivity = [[SHActivityIndicatorView alloc]init];
        [self addSubview:self.messgeActivity];
        
//        self.messgeActivity.backgroundColor = [UIColor redColor];
//        self.readMarker.backgroundColor = [UIColor cyanColor];
//        self.voiceNum.backgroundColor = [UIColor orangeColor];
        
        self.imageMessageView.userInteractionEnabled = NO;
        self.voiceMessageView.userInteractionEnabled = NO;
        self.locationMessageView.userInteractionEnabled = NO;
        self.videoMessageView.userInteractionEnabled = NO;
        

    }
    return self;
}

#pragma mark - 语音播放开始动画
- (void)playVoiceAnimation
{
    [self.voiceMessageView stopAnimating];
    [self.voiceMessageView startAnimating];
}
#pragma mark - 语音播放停止动画
- (void)stopVoiceAnimation
{
    [self.voiceMessageView stopAnimating];
}


- (void)setMessage:(SHMessage *)message
{
    _message = message;
    
    NSInteger set_space = 5;
    
    //发送状态
    self.messgeActivity.frame = CGRectMake( (message.bubbleMessageType == SHBubbleMessageType_Sending)?-(set_space + 20 + 10):(self.frame.size.width + set_space + 20 + 10), (self.frame.size.height - 20)/2, 20, 20);
    
    //未读标记
    self.readMarker.frame = CGRectMake((message.bubbleMessageType == SHBubbleMessageType_Sending)?(-set_space):self.frame.size.width + set_space, 5, 10, 10);

    //根据不同的类型定义控件
    switch (message.messageType) {
        case SHMessageBodyType_Text:{
            
        }
            break;
        case SHMessageBodyType_Image:
            //图片
            self.imageMessageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            break;
        case SHMessageBodyType_Video:
        {
            //视频
            self.videoMessageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            self.videoIconMessageView.frame = CGRectMake((self.videoMessageView.frame.size.width - 40)/2, (self.videoMessageView.frame.size.height - 40)/2, 40, 40);
        }
            break;
        case SHMessageBodyType_Location:
        {
            //位置
            self.locationMessageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            CGFloat locationLabelH = 55;
            self.locationMessageLabel.frame = CGRectMake(0, self.locationMessageView.frame.size.height - locationLabelH, self.locationMessageView.frame.size.width, locationLabelH);
        }
            break;
        case SHMessageBodyType_Voice:
        {
            //语音
            if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
                
                //语音图片
                self.voiceMessageView.frame = CGRectMake(self.frame.size.width - 45, (self.frame.size.height - 20)/2, 20, 20);
                //动画
                self.voiceMessageView.image = [UIImage imageNamed:@"chat_send_voice5.png"];
                self.voiceMessageView.animationImages = [NSArray arrayWithObjects:
                                                         [UIImage imageNamed:@"chat_send_voice1.png"],
                                                         [UIImage imageNamed:@"chat_send_voice2.png"],
                                                         [UIImage imageNamed:@"chat_send_voice3.png"],
                                                         [UIImage imageNamed:@"chat_send_voice4.png"],nil];
                //时长
                self.voiceNum.frame = CGRectMake(- (25 + 10 + set_space), (self.frame.size.height - 20)/2, 25, 20);
                self.voiceNum.textAlignment = NSTextAlignmentRight;
            
            }else{
                
                //语音图片
                self.voiceMessageView.frame = CGRectMake(25,(self.frame.size.height - 20)/2, 20, 20);
                //动画
                self.voiceMessageView.image = [UIImage imageNamed:@"chat_receive_voice5.png"];
                self.voiceMessageView.animationImages = [NSArray arrayWithObjects:
                                                         [UIImage imageNamed:@"chat_receive_voice1.png"],
                                                         [UIImage imageNamed:@"chat_receive_voice2.png"],
                                                         [UIImage imageNamed:@"chat_receive_voice3.png"],
                                                         [UIImage imageNamed:@"chat_receive_voice4.png"],nil];
                //时长
                self.voiceNum.frame = CGRectMake(self.frame.size.width + set_space + 10, (self.frame.size.height - 20)/2, 25, 20);
                self.voiceNum.textAlignment = NSTextAlignmentLeft;
            }
            
        }
            break;
        case SHMessageBodyType_Card:
        {
            //背景
            self.cardMessageBg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            //提示信息
            self.cardMessagePromptLabel.frame = CGRectMake(((message.bubbleMessageType == SHBubbleMessageType_Sending)?10:20), 70, self.frame.size.width - 30, 20);
            //分割线
            self.cardCuttingLine.frame = CGRectMake(0, 70, self.frame.size.width, 1);
            //头像
            self.cardMessageImage.frame = CGRectMake(10 + ((message.bubbleMessageType == SHBubbleMessageType_Sending)?0:10), 10, 50, 50);
            //名字
            self.cardMessageLabel.frame = CGRectMake(CGRectGetMaxX(self.cardMessageImage.frame) + 10, 10, self.frame.size.width - (CGRectGetMaxX(self.cardMessageImage.frame) + 20) - ((message.bubbleMessageType == SHBubbleMessageType_Sending)?10:0), 50);
            
            
        }
            break;
        case SHMessageBodyType_File:

            break;
        case SHMessageBodyType_RedPaper:

            break;
        case SHMessageBodyType_Command:

            break;
        case SHMessageBodyType_Prompt:
            self.promptLabel.frame = CGRectMake(ChatContentLR, ChatContentTB, self.frame.size.width - 2*ChatContentLR, self.frame.size.height - 2*ChatContentTB);
 
            break;
        case SHMessageBodyType_Other:

            break;
        default:
            break;
    }
}
#pragma mark 添加第一响应
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark 子视图超出父视图进行点击
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        CGPoint tempoint = [self.messgeActivity convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.messgeActivity.bounds, tempoint))
        {
            
            view = self.messgeActivity;
        }
    }
    return view;
}

@end
