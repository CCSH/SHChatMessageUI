//
//  SHMessageContentView.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/30.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageContentView.h"
#import "SHMessageMacroHeader.h"

@implementation SHMessageContentView

#pragma mark - 懒加载
#pragma mark 图片消息视图
- (UIImageView *)imageMessageView{
    //图片
    if (!_imageMessageView) {
        _imageMessageView = [[UIImageView alloc]init];
        _imageMessageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imageMessageView];
    }
    return _imageMessageView;
}

#pragma mark 语音消息视图
- (UIImageView *)voiceMessageView{
    //语音声波
    if (!_voiceMessageView) {
        _voiceMessageView = [[UIImageView alloc]init];
        [self addSubview:_voiceMessageView];
        //动画
        _voiceMessageView.animationDuration = 1;
        _voiceMessageView.animationRepeatCount = 0;
    }
    return _voiceMessageView;
}

- (UILabel *)voiceNum{
    //语音时长
    if (!_voiceNum) {
        _voiceNum = [[UILabel alloc]init];
        _voiceNum.textColor = [UIColor lightGrayColor];
        _voiceNum.font = [UIFont systemFontOfSize:14];
        [self addSubview:_voiceNum];
    }
    return _voiceNum;
}

- (UIImageView *)readMarker{
    //未读标记
    if (!_readMarker) {
        _readMarker = [[UIImageView alloc]init];
        _readMarker.image = [UIImage imageNamed:@"unread.png"];
        [self addSubview:_readMarker];
    }
    return _readMarker;
}

#pragma mark 位置消息视图
- (MKMapView *)locationMapView{
    //位置背景
    if (!_locationMapView) {
        _locationMapView = [[MKMapView alloc]init];
        _locationMapView.mapType = MKMapTypeStandard;
        _locationMapView.userInteractionEnabled = NO;
        [self addSubview:_locationMapView];
    }
    return _locationMapView;
}

- (UILabel *)locationMessageLabel{
    //位置文字
    if (!_locationMessageLabel) {
        _locationMessageLabel = [[UILabel alloc]init];
        _locationMessageLabel.textColor = [UIColor whiteColor];
        _locationMessageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _locationMessageLabel.font = [UIFont systemFontOfSize:14];
        _locationMessageLabel.numberOfLines = 1;
        _locationMessageLabel.textAlignment = NSTextAlignmentCenter;
        [self.locationMapView addSubview:_locationMessageLabel];
    }
    return _locationMessageLabel;
}

#pragma mark 视频消息视图
- (UIImageView *)videoMessageView{
    //视频背景
    if (!_videoMessageView) {
        _videoMessageView = [[UIImageView alloc]init];
        _videoMessageView.contentMode = UIViewContentModeScaleToFill;
        _videoMessageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_videoMessageView];
    }
    return _videoMessageView;
}

- (UIImageView *)videoIconMessageView{
    //视频图标
    if (!_videoIconMessageView) {
        _videoIconMessageView = [[UIImageView alloc]init];
        _videoIconMessageView.image = [UIImage imageNamed:@"chat_video.png"];
        [self.videoMessageView addSubview:_videoIconMessageView];
    }
    return _videoIconMessageView;
}

#pragma mark 提示消息视图
- (UILabel *)promptLabel{
    //提示
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.font = ChatPromptContentFont;
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.numberOfLines = 0;
        
        [self addSubview:_promptLabel];
    }
    return _promptLabel;
}

#pragma mark 名片消息视图
- (UIImageView *)cardMessageBg{
    //背景
    if (!_cardMessageBg) {
        _cardMessageBg = [[UIImageView alloc]init];
        _cardMessageBg.backgroundColor = [UIColor whiteColor];
        _cardMessageBg.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_cardMessageBg];
    }
    return _cardMessageBg;
}

- (UIImageView *)cardMessageImage{
    //头像
    if (!_cardMessageImage) {
        _cardMessageImage = [[UIImageView alloc]init];
        _cardMessageImage.contentMode = UIViewContentModeScaleToFill;
        [self.cardMessageBg addSubview:_cardMessageImage];
    }
    return _cardMessageImage;
}

- (UILabel *)cardMessageLabel{
    //姓名
    if (!_cardMessageLabel) {
        _cardMessageLabel = [[UILabel alloc]init];
        _cardMessageLabel.textColor = [UIColor blackColor];
        _cardMessageLabel.numberOfLines = 0;
        _cardMessageLabel.font = [UIFont systemFontOfSize:14];
        [self.cardMessageBg addSubview:_cardMessageLabel];
    }
    return _cardMessageLabel;
}

- (UIView *)cardCuttingLine{
    //分割线
    if (!_cardCuttingLine) {
        //分割线
        _cardCuttingLine = [[UIView alloc]init];
        _cardCuttingLine.backgroundColor = RGB(245, 245, 245, 1);
        [self.cardMessageBg addSubview:_cardCuttingLine];
    }
    return _cardCuttingLine;
}

- (UILabel *)cardMessagePromptLabel{
    //提示文字
    if (!_cardMessagePromptLabel) {
        //提示文字
        _cardMessagePromptLabel = [[UILabel alloc]init];
        _cardMessagePromptLabel.textColor = [UIColor grayColor];
        _cardMessagePromptLabel.font = [UIFont systemFontOfSize:12];
        _cardMessagePromptLabel.textAlignment = NSTextAlignmentLeft;
        [self.cardMessageBg addSubview:_cardMessagePromptLabel];
    }
    return _cardMessagePromptLabel;
}

#pragma mark 红包消息视图
- (UIImageView *)redPaperBg {
    //背景
    if (!_redPaperBg) {
        
        _redPaperBg = [[UIImageView alloc]init];
        _redPaperBg.backgroundColor = RGB(250, 157, 59, 1);
        _redPaperBg.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_redPaperBg];
    }
    return _redPaperBg;
}

- (UIImageView *)redPaperImage {
    //图片
    if (!_redPaperImage) {
        _redPaperImage = [[UIImageView alloc]init];
        _redPaperImage.image = [UIImage imageNamed:@"redpackage.png"];
        _redPaperImage.contentMode = UIViewContentModeScaleToFill;
        [self.redPaperBg addSubview:_redPaperImage];
    }
    return _redPaperImage;
}

- (UILabel *)redPaperContentLable {
    //内容
    if (!_redPaperContentLable) {
        _redPaperContentLable = [[UILabel alloc]init];
        _redPaperContentLable.textColor = [UIColor whiteColor];
        _redPaperContentLable.font = [UIFont systemFontOfSize:14];
        [self.redPaperBg addSubview:_redPaperContentLable];
    }
    return _redPaperContentLable;
}

- (UILabel *)redPaperRemainLable {
    //提示
    if (!_redPaperRemainLable) {
        _redPaperRemainLable = [[UILabel alloc]init];
        _redPaperRemainLable.textColor = [UIColor whiteColor];
        _redPaperRemainLable.font = [UIFont systemFontOfSize:12];
        [self.redPaperBg addSubview:_redPaperRemainLable];
    }
    return _redPaperRemainLable;
}

- (UILabel *)redPaperResourceLable {
    //来源
    if (!_redPaperResourceLable) {
        _redPaperResourceLable = [[UILabel alloc]init];
        _redPaperResourceLable.backgroundColor = [UIColor whiteColor];
        _redPaperResourceLable.textColor = [UIColor grayColor];
        _redPaperResourceLable.font = [UIFont systemFontOfSize:10];
        _redPaperResourceLable.textAlignment = NSTextAlignmentLeft;
        [self.redPaperBg addSubview:_redPaperResourceLable];
    }
    return _redPaperResourceLable;
}

#pragma mark 阅后即焚消息视图
- (UIImageView *)burnImage{
    if (!_burnImage) {
        _burnImage = [[UIImageView alloc]init];
        _burnImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_burnImage];
    }
    return _burnImage;
}

- (UILabel *)burnLabel{
    //阅后即焚文字
    if (!_burnLabel) {
        _burnLabel = [[UILabel alloc]init];
        _burnLabel.numberOfLines = 0;
        _burnLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_burnLabel];
    }
    return _burnLabel;
}

- (UIImageView *)burnIconImage{
    //阅后即焚图标
    if (!_burnIconImage) {
        _burnIconImage = [[UIImageView alloc]init];
        _burnIconImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_burnIconImage];
    }
    return _burnIconImage;
}

#pragma mark Gif消息视图
- (WKWebView *)gifView{
    if (!_gifView) {
        _gifView = [[WKWebView alloc]init];
        _gifView.backgroundColor = [UIColor clearColor];
        _gifView.userInteractionEnabled = NO;
        _gifView.scrollView.scrollEnabled = NO;
        _gifView.opaque = NO;
        [self addSubview:_gifView];
    }
    return _gifView;
}

#pragma mark 语音信箱消息视图
- (UIImageView *)voiceEmailView{
    //语音声波
    if (!_voiceEmailView) {
        _voiceEmailView = [[UIImageView alloc]init];
        [self addSubview:_voiceEmailView];
        //动画
        _voiceEmailView.animationDuration = 1;
        _voiceEmailView.animationRepeatCount = 0;
    }
    return _voiceEmailView;
}

#pragma mark 消息发送状态视图
- (SHActivityIndicatorView *)messgeActivity{
    if (!_messgeActivity) {
        _messgeActivity = [[SHActivityIndicatorView alloc]init];
        [self addSubview:_messgeActivity];
    }
    return _messgeActivity;
}

#pragma mark - 语音播放开始动画
- (void)playVoiceAnimation {
    [self.voiceMessageView stopAnimating];
    [self.voiceMessageView startAnimating];
}

#pragma mark - 语音播放停止动画
- (void)stopVoiceAnimation {
    [self.voiceMessageView stopAnimating];
}

#pragma mark - 设置内部控件Frame
- (void)setMessage:(SHMessage *)message {
    
    _message = message;
    
    NSInteger set_space = 5;
    
    BOOL isSend = (message.bubbleMessageType == SHBubbleMessageType_Sending);
    
    //发送状态
    self.messgeActivity.frame = CGRectMake(isSend?-(set_space + 20 + 10):(self.frame.size.width + set_space + 20 + 10), (self.frame.size.height - 20)/2, 20, 20);
    
    //未读标记
    self.readMarker.frame = CGRectMake(isSend?(-set_space - 9):self.frame.size.width + set_space, 1, 9, 9);
    
    //判断消息类型
    switch (message.messageType) {
        case SHMessageBodyType_Text://文本
        {
            if (isSend) {
                
                [self setTitleColor:[UIColor whiteColor] forState:0];
            }else{
                
                [self setTitleColor:[UIColor grayColor] forState:0];
            }
        }
            break;
        case SHMessageBodyType_Image://图片
        {
            self.imageMessageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }
            break;
        case SHMessageBodyType_Voice://语音
        {
            if (isSend) {
                //语音图片
                self.voiceMessageView.frame = CGRectMake(self.frame.size.width - 42, (self.frame.size.height - 17)/2, 17, 17);
                //动画
                self.voiceMessageView.image = [UIImage imageNamed:@"chat_send_voice4.png"];
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
                self.voiceMessageView.frame = CGRectMake(22,(self.frame.size.height - 17)/2, 17, 17);
                //动画
                self.voiceMessageView.image = [UIImage imageNamed:@"chat_receive_voice4.png"];
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
        case SHMessageBodyType_Location://位置
        {
            self.locationMapView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            self.locationMessageLabel.frame = CGRectMake(isSend?0:8, self.locationMapView.frame.size.height - 30, self.locationMapView.frame.size.width - 7, 30);
        }
            break;
        case SHMessageBodyType_Video://视频
        {
            self.videoMessageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            self.videoIconMessageView.frame = CGRectMake((self.videoMessageView.frame.size.width - 40)/2, (self.videoMessageView.frame.size.height - 40)/2, 40, 40);
        }
            break;
        case SHMessageBodyType_Note://提示
        {
            self.promptLabel.frame = CGRectMake(ChatContentLR, ChatContentTB, self.frame.size.width - 2*ChatContentLR, self.frame.size.height - 2*ChatContentTB);
        }
            break;
        case SHMessageBodyType_RedPaperNote://红包提示
        {
            self.promptLabel.frame = CGRectMake(ChatContentLR, ChatContentTB, self.frame.size.width - 2*ChatContentLR, self.frame.size.height - 2*ChatContentTB);
        }
            break;
        case SHMessageBodyType_Card://名片
        {
            //背景
            self.cardMessageBg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            //提示信息
            self.cardMessagePromptLabel.frame = CGRectMake((isSend?10:20), 70, self.frame.size.width - 30, 20);
            //分割线
            self.cardCuttingLine.frame = CGRectMake(0, 70, self.frame.size.width, 1);
            //头像
            self.cardMessageImage.frame = CGRectMake(10 + (isSend?0:10), 10, 50, 50);
            //名字
            self.cardMessageLabel.frame = CGRectMake(self.cardMessageImage.maxX + 10, 10, self.frame.size.width - (self.cardMessageImage.maxX + 20) - (isSend?10:0), 50);
        }
            break;
        case SHMessageBodyType_RedPaper://红包
        {
            //背景
            self.redPaperBg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            //图标
            self.redPaperImage.frame = CGRectMake(10 + (isSend?0:8), 12, 32, 42);
            //内容
            self.redPaperContentLable.frame = CGRectMake(self.redPaperImage.maxX + 10, self.redPaperImage.y,self.frame.size.width - self.redPaperImage.maxX - 20 - (isSend?8:0),20);
            //提示
            self.redPaperRemainLable.frame = CGRectMake(self.redPaperImage.maxX + 10, self.redPaperContentLable.maxY + 1, self.frame.size.width - self.redPaperImage.maxX - 20 - (isSend?8:0), 20);
            //来源
            self.redPaperResourceLable.frame = CGRectMake((isSend?0:8), self.frame.size.height - 20, self.frame.size.width, 20);
        }
            break;
        case SHMessageBodyType_Burn://阅后即焚
        {
            //图标
            self.burnImage.frame = CGRectMake(15 + (isSend?0:8), (self.height - 45)/2 - 5, 35, 45);
            //提示文字
            self.burnLabel.frame = CGRectMake(self.burnImage.maxX + 10, self.burnImage.y, self.width - (self.burnImage.maxX + 10) - 2*15 - 10, self.burnImage.height);
            //角标
            self.burnIconImage.frame = CGRectMake(self.width - (isSend?0:8) - 15 - 15, self.height - 15 - 15, 15, 15);
        }
            break;
        case SHMessageBodyType_Phone://通话
        {
            if (isSend) {
                
                [self setTitleColor:[UIColor whiteColor] forState:0];
            }else{
                
                [self setTitleColor:[UIColor grayColor] forState:0];
            }
        }
            break;
        case SHMessageBodyType_Gif://Gif
        {
            self.gifView.frame = CGRectMake(0, 0, self.width, self.height);
        }
            break;
        case SHMessageBodyType_VoiceEmail://语音信箱
        {
            if (isSend) {
                //语音图片
                self.voiceEmailView.frame = CGRectMake(self.frame.size.width - 42, (self.frame.size.height - 17)/2, 17, 17);
                //动画
                self.voiceEmailView.image = [UIImage imageNamed:@"chat_send_voice4.png"];
                self.voiceEmailView.animationImages = [NSArray arrayWithObjects:
                                                         [UIImage imageNamed:@"chat_send_voice1.png"],
                                                         [UIImage imageNamed:@"chat_send_voice2.png"],
                                                         [UIImage imageNamed:@"chat_send_voice3.png"],
                                                         [UIImage imageNamed:@"chat_send_voice4.png"],nil];
            }else{
                //语音图片
                self.voiceEmailView.frame = CGRectMake(22,(self.frame.size.height - 17)/2, 17, 17);
                //动画
                self.voiceEmailView.image = [UIImage imageNamed:@"chat_receive_voice4.png"];
                self.voiceEmailView.animationImages = [NSArray arrayWithObjects:
                                                         [UIImage imageNamed:@"chat_receive_voice1.png"],
                                                         [UIImage imageNamed:@"chat_receive_voice2.png"],
                                                         [UIImage imageNamed:@"chat_receive_voice3.png"],
                                                         [UIImage imageNamed:@"chat_receive_voice4.png"],nil];
            }
        }
            break;
        case SHMessageBodyType_ReCall://撤回
        {
            self.promptLabel.frame = CGRectMake(ChatContentLR, ChatContentTB, self.frame.size.width - 2*ChatContentLR, self.frame.size.height - 2*ChatContentTB);
        }
            break;
        default:
            break;
    }
}
    
#pragma mark 添加第一响应
- (BOOL)canBecomeFirstResponder {
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
