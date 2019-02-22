//
//  SHVoiceTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHVoiceTableViewCell.h"

@interface SHVoiceTableViewCell ()

// audio
@property (nonatomic, retain) UIImageView *voiceView;
// audio 时长
@property (nonatomic, retain) UILabel *voiceNum;
// 未读标记
@property (nonatomic, retain) UIImageView *readMarker;

@end

@implementation SHVoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageFrame:(SHMessageFrame *)messageFrame{
    [super setMessageFrame:messageFrame];
    
    SHMessage *message = messageFrame.message;
    self.readMarker.hidden = YES;
    
    NSInteger set_space = 5;
    
    if (!self.isSend) {
        self.readMarker.hidden = message.messageRead;
        //未读标记
        self.readMarker.x = self.btnContent.width + set_space;
    }
    
    self.voiceNum.hidden = (message.messageState != SHSendMessageType_Successed);
    self.voiceNum.text = [NSString stringWithFormat:@"%@\"",message.voiceDuration];
    
    if (!message.voiceName.length) {
        message.voiceName = [SHFileHelper getNameWithUrl:message.voiceUrl];
    }
    
    //设置frame
    self.voiceView.centerY = self.btnContent.height/2;
    self.voiceNum.centerY = self.btnContent.height/2;
    
    if (self.isSend) {
        //语音图片
        self.voiceView.x = self.btnContent.width - kChat_angle_w - kChat_margin - self.voiceView.width - 5;
        //动画
        self.voiceView.image = [SHFileHelper imageNamed:@"chat_send_voice4.png"];
        self.voiceView.animationImages = [NSArray arrayWithObjects:
                                          [SHFileHelper imageNamed:@"chat_send_voice1.png"],
                                          [SHFileHelper imageNamed:@"chat_send_voice2.png"],
                                          [SHFileHelper imageNamed:@"chat_send_voice3.png"],
                                          [SHFileHelper imageNamed:@"chat_send_voice4.png"],nil];
        //时长
        self.voiceNum.x = - (25 + set_space);
        self.voiceNum.textAlignment = NSTextAlignmentRight;
        
    }else{
        //语音图片
        self.voiceView.x = kChat_angle_w + kChat_margin + 5;
        
        //动画
        self.voiceView.image = [SHFileHelper imageNamed:@"chat_receive_voice4.png"];
        self.voiceView.animationImages = [NSArray arrayWithObjects:
                                          [SHFileHelper imageNamed:@"chat_receive_voice1.png"],
                                          [SHFileHelper imageNamed:@"chat_receive_voice2.png"],
                                          [SHFileHelper imageNamed:@"chat_receive_voice3.png"],
                                          [SHFileHelper imageNamed:@"chat_receive_voice4.png"],nil];
        //时长
        self.voiceNum.x = self.btnContent.width + set_space;
        self.voiceNum.textAlignment = NSTextAlignmentLeft;
    }
    
    UIImage *image = nil;
    // 设置聊天气泡背景
    if (self.isSend) {
        image = [SHFileHelper imageNamed:@"chat_message_send@2x.png"];
    }else{
        image = [SHFileHelper imageNamed:@"chat_message_receive@2x.png"];
    }
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 25, 10, 25)];
    [self.btnContent setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark - 语音动画
#pragma mark 语音播放开始动画
- (void)playVoiceAnimation {
    
    self.readMarker.hidden = YES;
    [self.voiceView stopAnimating];
    [self.voiceView startAnimating];
    self.isPlaying = YES;
}

#pragma mark 语音播放停止动画
- (void)stopVoiceAnimation {
    [self.voiceView stopAnimating];
    self.isPlaying = NO;
}

#pragma mark 语音消息视图
- (UIImageView *)voiceView{
    //语音声波
    if (!_voiceView) {
        _voiceView = [[UIImageView alloc]init];
        _voiceView.size = CGSizeMake(15, 15);
        [self.btnContent addSubview:_voiceView];
        //动画
        _voiceView.animationDuration = 1;
        _voiceView.animationRepeatCount = 0;
    }
    return _voiceView;
}

- (UILabel *)voiceNum{
    //语音时长
    if (!_voiceNum) {
        _voiceNum = [[UILabel alloc]init];
        _voiceNum.size = CGSizeMake(25, 20);
        _voiceNum.textColor = [UIColor lightGrayColor];
        _voiceNum.font = [UIFont systemFontOfSize:14];
        [self.btnContent addSubview:_voiceNum];
    }
    return _voiceNum;
}

- (UIImageView *)readMarker{
    //未读标记
    if (!_readMarker) {
        _readMarker = [[UIImageView alloc]init];
        _readMarker.frame = CGRectMake(0, 1, 9, 9);
        _readMarker.image = [SHFileHelper imageNamed:@"unread.png"];
        [self.btnContent addSubview:_readMarker];
    }
    return _readMarker;
}

@end
