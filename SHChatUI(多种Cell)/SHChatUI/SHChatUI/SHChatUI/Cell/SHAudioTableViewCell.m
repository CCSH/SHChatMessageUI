//
//  SHAudioTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHAudioTableViewCell.h"

@interface SHAudioTableViewCell ()

// 动画
@property (nonatomic, strong) UIImageView *voiceImg;
// 时长
@property (nonatomic, strong) UILabel *num;
// 未读标记
@property (nonatomic, strong) UIImageView *readMarker;

@end

@implementation SHAudioTableViewCell

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

- (void)setMessageFrame:(SHMessageFrame *)messageFrame
{
    [super setMessageFrame:messageFrame];
    
    SHMessage *message = messageFrame.message;

    //设置内容
    //未读标记
    self.readMarker.hidden = YES;
    if (message.bubbleMessageType == SHBubbleMessageType_Receiving)
    {
        self.readMarker.hidden = message.messageRead;
    }
    
    //语音时长
    self.num.text = [NSString stringWithFormat:@"%@\"", message.audioDuration];
    [self.num sizeToFit];
    
    //文件内容
    if (!message.fileName.length)
    {
        message.fileName = [SHFileHelper getFileNameWithPath:message.fileUrl];
    }
    
    //动画
    self.voiceImg.image = [SHFileHelper imageNamed:@"chat_receive_voice4"];
    self.voiceImg.animationImages = @[
        [SHFileHelper imageNamed:@"chat_receive_voice1"],
        [SHFileHelper imageNamed:@"chat_receive_voice2"],
        [SHFileHelper imageNamed:@"chat_receive_voice3"],
        [SHFileHelper imageNamed:@"chat_receive_voice4"]
    ];
    
    //设置frame
    //内容
    self.voiceImg.centerY = self.bubbleBtn.height / 2;
    //时长
    self.num.centerY = self.bubbleBtn.height / 2;
    
    //未读标记
    self.readMarker.x = self.bubbleBtn.width + 5;
    
    //语音图片
    self.voiceImg.x = kChat_angle_w + kChat_margin;
    
    //时长
    self.num.x = self.voiceImg.maxX + 5;

    //判断收发
    if (message.bubbleMessageType == SHBubbleMessageType_Send)
    {
        //动画
        self.voiceImg.animationImages = @[
            [SHFileHelper imageNamed:@"chat_send_voice1"],
            [SHFileHelper imageNamed:@"chat_send_voice2"],
            [SHFileHelper imageNamed:@"chat_send_voice3"],
            [SHFileHelper imageNamed:@"chat_send_voice4"]
        ];
        self.num.textAlignment = NSTextAlignmentRight;
        
        //语音图片
        self.voiceImg.x = self.bubbleBtn.width - self.voiceImg.maxX;

        //时长
        self.num.x = self.voiceImg.x - (self.num.width + 5);
    }
    
    self.voiceImg.image = self.voiceImg.animationImages.lastObject;
    
    if (message.isPlaying) {
        [self.voiceImg startAnimating];
    }else{
        [self.voiceImg stopAnimating];
    }
}

#pragma mark - 语音动画
#pragma mark 语音播放开始动画
- (void)playVoiceAnimation
{
    self.readMarker.hidden = YES;
    if (self.voiceImg.isAnimating) {
        [self.voiceImg stopAnimating];
    }
 
    [self.voiceImg startAnimating];
}

#pragma mark 语音播放停止动画
- (void)stopVoiceAnimation
{
    [self.voiceImg stopAnimating];
}

#pragma mark 语音消息视图
- (UIImageView *)voiceImg
{
    //语音声波
    if (!_voiceImg)
    {
        _voiceImg = [[UIImageView alloc] init];
        _voiceImg.size = CGSizeMake(15, 15);
        [self.bubbleBtn addSubview:_voiceImg];
        //动画
        _voiceImg.animationDuration = 1;
        _voiceImg.animationRepeatCount = 0;
    }
    return _voiceImg;
}

- (UILabel *)num
{
    //语音时长
    if (!_num)
    {
        _num = [[UILabel alloc] init];
        _num.size = CGSizeMake(25, 20);
        _num.textColor = [UIColor lightGrayColor];
        _num.font = [UIFont systemFontOfSize:14];
        [self.bubbleBtn addSubview:_num];
    }
    return _num;
}

- (UIImageView *)readMarker
{
    //未读标记
    if (!_readMarker)
    {
        _readMarker = [[UIImageView alloc] init];
        _readMarker.frame = CGRectMake(0, 1, 9, 9);
        _readMarker.image = [SHFileHelper imageNamed:@"unread.png"];
        [self.bubbleBtn addSubview:_readMarker];
    }
    return _readMarker;
}

@end
