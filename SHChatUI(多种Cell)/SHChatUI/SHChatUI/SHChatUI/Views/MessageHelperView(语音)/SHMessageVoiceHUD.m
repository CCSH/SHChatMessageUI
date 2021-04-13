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
@property (nonatomic, strong) UIImageView *voiceImg;

//录音界面文字
@property (nonatomic, strong) UILabel *messageLab;
//录音界面背景
@property (nonatomic, strong) UIView *bgView;
//整体背景
@property (nonatomic, strong) UIWindow *window;

//是否正在倒计时
@property (nonatomic, assign) BOOL isCountDown;

@end

@implementation SHMessageVoiceHUD

#pragma mark - 实例化
+ (id)shareInstance
{
    static SHMessageVoiceHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SHMessageVoiceHUD alloc] init];
        //跟视图
        instance.window = [UIApplication sharedApplication].keyWindow;
    });
    return instance;
}

#pragma mark - 懒加载
- (UIView *)bgView
{
    if (!_bgView)
    {
        //背景
        _bgView = [[UIView alloc] initWithFrame:CGRectMake((kSHWidth - 150) / 2, (kSHHeight - 170) / 2, 150, 160)];
        
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        
        [self addSubview:_bgView];
    }
    
    return _bgView;
}

- (UIImageView *)voiceImg
{
    if (!_voiceImg)
    {
        //图片
        _voiceImg= [[UIImageView alloc] initWithFrame:CGRectMake(35, 15, 80, 90)];
        [self.bgView addSubview:_voiceImg];
    }
    
    return _voiceImg;
}

- (UILabel *)messageLab
{
    if (!_messageLab)
    {
        //文字
        _messageLab = [[UILabel alloc] initWithFrame:CGRectMake(5, self.bgView.frame.size.height - 35, self.bgView.frame.size.width - 10, 30)];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.numberOfLines = 0;
        _messageLab.font = [UIFont systemFontOfSize:13];
        _messageLab.textColor = [UIColor whiteColor];
        
        _messageLab.layer.cornerRadius = 5;
        _messageLab.layer.borderWidth = 1;
        _messageLab.layer.borderColor = [UIColor clearColor].CGColor;
        _messageLab.layer.masksToBounds = YES;
        
        [self.bgView addSubview:_messageLab];
    }
    
    return _messageLab;
}

#pragma mark - 设置状态
- (void)setHudType:(SHVoiceHudType)hudType
{
    if (_hudType == hudType)
    {
        return;
    }
    _hudType = hudType;
    
    if (![self.window.subviews containsObject:self])
    {
        self.isCountDown = NO;
        [self showVoiceMeters:1];
        [self.window addSubview:self];
    }

    switch (hudType)
    {
        case SHVoiceHudType_remove:
        {
            [self removeFromSuperview];
        }
            break;
        case SHVoiceHudType_recording:
        {
            if (!self.isCountDown) {
                self.messageLab.text = @"手指上滑，取消发送";
            }
        }
            break;
        case SHVoiceHudType_cancel:
        {
            if (!self.isCountDown) {
                self.messageLab.text = @"松开手指，取消发送";
            }
            self.voiceImg.image = [SHFileHelper imageNamed:@"voice_change"];
        }
            break;
        case SHVoiceHudType_warning:
        {
            self.messageLab.text = @"时间太短";
            self.voiceImg.image = [SHFileHelper imageNamed:@"voice_failure"];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 显示声音声波
- (void)showVoiceMeters:(int)meter
{
    if (self.hudType == SHVoiceHudType_recording)
    {
        NSString *imageName = [NSString stringWithFormat:@"voice_play_animation_%d", meter];
        self.voiceImg.image = [SHFileHelper imageNamed:imageName];
    }
}

- (void)showCountDownWithTime:(NSInteger)time
{
    self.isCountDown = YES;
    self.messageLab.text = [NSString stringWithFormat:@"%ld“ 后将停止录音",time];
}

@end
