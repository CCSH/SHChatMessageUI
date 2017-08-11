//
//  SHMessageVoiceHUD.m
//  SHChatMessageUI
//
//  Created by CSH on 16/8/4.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageVoiceHUD.h"
#import "SHMessageMacroHeader.h"

@interface SHMessageVoiceHUD ()

//录音界面图片
@property (nonatomic, strong) UIImageView *messageVoiceImage;

//录音界面文字
@property (nonatomic, strong) UILabel *messageVoiceLabel;
//录音界面背景
@property (nonatomic, strong) UIView *messageBgView;
//整体背景
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

@end

@implementation SHMessageVoiceHUD
@synthesize overlayWindow;

#pragma mark - 实例化
+ (id)shareInstance {
    static SHMessageVoiceHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SHMessageVoiceHUD alloc] init];
    });
    return instance;
}
#pragma mark - 界面显示
- (void)showVoiceWithMessage:(NSString *)message{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview){
            //跟视图
            overlayWindow = [UIApplication sharedApplication].keyWindow;
            overlayWindow.userInteractionEnabled = NO;
            [overlayWindow addSubview:self];
        }

        if (!self.messageBgView) {
            //背景
            self.messageBgView = [[UIView alloc] initWithFrame:CGRectMake((kSHWIDTH - 150)/2, (kSHHEIGHT - 170)/2 , 150, 160)];

            self.messageBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            self.messageBgView.layer.cornerRadius = 5;
            self.messageBgView.layer.masksToBounds = YES;

            [self addSubview:self.messageBgView];
        }
        
        
        if (!self.messageVoiceImage) {
            //图片
            self.messageVoiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(35, 15, 80, 90)];
            self.messageVoiceImage.image = [UIImage imageNamed:@"voice_play_animation_0.png"];
            
            [self.messageBgView addSubview:self.messageVoiceImage];
        }
        
        if (!self.messageVoiceLabel) {
            //文字
            self.messageVoiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,self.messageBgView.frame.size.height - 35,self.messageBgView.frame.size.width - 10 , 30)];
            self.messageVoiceLabel.textAlignment = NSTextAlignmentCenter;
            self.messageVoiceLabel.numberOfLines = 0;
            self.messageVoiceLabel.font = [UIFont systemFontOfSize:13];
            self.messageVoiceLabel.textColor = [UIColor whiteColor];
            self.messageVoiceLabel.layer.cornerRadius = 5;
            self.messageVoiceLabel.layer.borderWidth = 1;
            self.messageVoiceLabel.layer.borderColor = [UIColor clearColor].CGColor;
            self.messageVoiceLabel.layer.masksToBounds = YES;
            
            [self.messageBgView addSubview:self.messageVoiceLabel];
        }
        
        self.messageVoiceLabel.text = message;
        self.messageVoiceLabel.backgroundColor = [UIColor clearColor];
        
        if ([message isEqualToString:@"松开手指,取消发送"]) {
            self.messageVoiceLabel.backgroundColor = RGB(155, 57, 57, 1);
            self.messageVoiceImage.image = [UIImage imageNamed:@"voice_change.png"];
        }else if ([message isEqualToString:@"时间太短"]){
            self.messageVoiceImage.image = [UIImage imageNamed:@"voice_failure.png"];
        }
        
    });
    

    
}
#pragma mark - 界面消失
- (void)dissmissVoiceHUD {
    overlayWindow.userInteractionEnabled = YES;
    [self removeFromSuperview];
}

#pragma mark - 显示声音声波
- (void)showVoiceMeters:(int)meter {
    if (![self.messageVoiceLabel.text isEqualToString:@"上滑取消"]) {
        self.messageVoiceImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"voice_play_animation_%d.png",meter]];
    }
}

@end
