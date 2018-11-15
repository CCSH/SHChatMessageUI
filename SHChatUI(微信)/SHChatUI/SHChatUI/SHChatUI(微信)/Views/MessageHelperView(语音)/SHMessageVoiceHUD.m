//
//  SHMessageVoiceHUD.m
//  SHChatMessageUI
//
//  Created by CSH on 16/8/4.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageVoiceHUD.h"
#import "SHMessageHeader.h"

@interface SHMessageVoiceHUD ()

//录音界面图片
@property (nonatomic, strong) UIImageView *messageVoiceImage;

//录音界面文字
@property (nonatomic, strong) UILabel *messageVoiceLabel;
//录音界面背景
@property (nonatomic, strong) UIView *messageBgView;
//整体背景
@property (nonatomic, strong) UIWindow *overlayWindow;

@end

@implementation SHMessageVoiceHUD

#pragma mark - 实例化
+ (id)shareInstance {
    static SHMessageVoiceHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SHMessageVoiceHUD alloc] init];
        //跟视图
        instance.overlayWindow = [UIApplication sharedApplication].keyWindow;
    });
    return instance;
}

#pragma mark - 懒加载
- (UIView *)messageBgView{
    
    if (!_messageBgView) {
        //背景
        _messageBgView = [[UIView alloc] initWithFrame:CGRectMake((kSHWidth - 150)/2, (kSHHeight - 170)/2 , 150, 160)];
        
        _messageBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _messageBgView.layer.cornerRadius = 5;
        _messageBgView.layer.masksToBounds = YES;
        
        [self addSubview:_messageBgView];
    }
    
    return _messageBgView;
}

- (UIImageView *)messageVoiceImage{
    if (!_messageVoiceImage) {
        //图片
        self.messageVoiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(35, 15, 80, 90)];
        self.messageVoiceImage.image = [SHFileHelper imageNamed:@"voice_play_animation_0.png"];
        
        [self.messageBgView addSubview:self.messageVoiceImage];
    }
    
    return _messageVoiceImage;
}

- (UILabel *)messageVoiceLabel{
    if (!_messageVoiceLabel) {
        //文字
        _messageVoiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,self.messageBgView.frame.size.height - 35,self.messageBgView.frame.size.width - 10 , 30)];
        _messageVoiceLabel.textAlignment = NSTextAlignmentCenter;
        _messageVoiceLabel.numberOfLines = 0;
        _messageVoiceLabel.font = [UIFont systemFontOfSize:13];
        _messageVoiceLabel.textColor = [UIColor whiteColor];
        
        _messageVoiceLabel.layer.cornerRadius = 5;
        _messageVoiceLabel.layer.borderWidth = 1;
        _messageVoiceLabel.layer.borderColor = [UIColor clearColor].CGColor;
        _messageVoiceLabel.layer.masksToBounds = YES;
        
        [self.messageBgView addSubview:_messageVoiceLabel];
    }
    
    return _messageVoiceLabel;
}

#pragma mark - 设置状态
- (void)setHudType:(NSInteger)hudType{
    
    if (_hudType == hudType) {
        return;
    }
    _hudType = hudType;

    self.messageVoiceLabel.backgroundColor = [UIColor clearColor];
    [self removeFromSuperview];
    
    switch (hudType) {
        case 0://移除
        {
            self.overlayWindow.userInteractionEnabled = YES;
        }
            break;
        case 1://文字
        {
            self.messageVoiceLabel.text = @"手指上滑，取消发送";
            [self.overlayWindow addSubview:self];
        }
            break;
        case 2://取消发送
        {
            self.messageVoiceLabel.backgroundColor = kRGB(155, 57, 57, 1);
            
            self.messageVoiceLabel.text = @"松开手指，取消发送";
            self.messageVoiceImage.image = [SHFileHelper imageNamed:@"voice_change.png"];

            [self.overlayWindow addSubview:self];
        }
            break;
        case 3://警告
        {
            self.messageVoiceLabel.text = @"时间太短";
            self.messageVoiceImage.image = [SHFileHelper imageNamed:@"voice_failure.png"];
            [self.overlayWindow addSubview:self];
            
        }
            break;
        case 4://倒计时
        {
            self.messageVoiceLabel.text = @"最后10秒";
            [self.overlayWindow addSubview:self];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 显示声音声波
- (void)showVoiceMeters:(int)meter {
    
    if (self.hudType == 1) {
        
        NSString *imageName = [NSString stringWithFormat:@"voice_play_animation_%d.png",meter];
        self.messageVoiceImage.image = [SHFileHelper imageNamed:imageName];
    }
}

- (void)showCountDownWithTime:(NSInteger)time{
    
}


@end
