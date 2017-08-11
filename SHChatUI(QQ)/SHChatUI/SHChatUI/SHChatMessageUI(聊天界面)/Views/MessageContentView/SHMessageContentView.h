//
//  SHMessageContentView.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/30.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <WebKit/WebKit.h>
#import "SHActivityIndicatorView.h"

@interface SHMessageContentView : UIButton

//其他信息
@property (nonatomic, retain) SHActivityIndicatorView *messgeActivity;

// imgae
@property (nonatomic, retain) UIImageView *imageMessageView;

// audio
@property (nonatomic, retain) UIImageView *voiceMessageView;
// audio 时长
@property (nonatomic, retain) UILabel *voiceNum;
// 未读标记
@property (nonatomic, retain) UIImageView *readMarker;
// 正在播放 0 未播放 1 播放中 2 暂停
// 播放 YES 未播放 NO
@property (nonatomic, assign) BOOL isPlaying;

// location
@property (nonatomic, retain) MKMapView *locationMapView;
// location 名称
@property (nonatomic, retain) UILabel *locationMessageLabel;

// video
@property (nonatomic, retain) UIImageView *videoMessageView;
// video 图标
@property (nonatomic, retain) UIImageView *videoIconMessageView;

// prompt
@property (nonatomic, retain) UILabel *promptLabel;

// card
// card 背景
@property (nonatomic, retain) UIImageView *cardMessageBg;
// card line
@property (nonatomic, retain) UIView *cardCuttingLine;
// card 头像
@property (nonatomic, retain) UIImageView *cardMessageImage;
// card 姓名
@property (nonatomic, retain) UILabel *cardMessageLabel;
// card 提示
@property (nonatomic, retain) UILabel *cardMessagePromptLabel;

// Gif
@property (nonatomic, retain) WKWebView *gifView;

// voiceEmail
@property (nonatomic, retain) UIImageView *voiceEmailView;
// 正在播放 0 未播放 1 播放中 2 暂停
// 播放 YES 未播放 NO
@property (nonatomic, assign) BOOL voiceEmailIsPlaying;

//红包
//红包背景
@property(nonatomic, retain) UIImageView *redPaperBg;
//红包图片
@property(nonatomic, retain) UIImageView *redPaperImage;
//红包内容
@property(nonatomic, retain) UILabel *redPaperContentLable;
//红包提示
@property(nonatomic, retain) UILabel *redPaperRemainLable;
//红包来源
@property(nonatomic, retain) UILabel *redPaperResourceLable;

// burn
// 阅后即焚图片
@property(nonatomic, retain) UIImageView *burnImage;
// 阅后即焚文字
@property(nonatomic, retain) UILabel *burnLabel;
// 阅后即焚角标
@property(nonatomic, retain) UIImageView *burnIconImage;

@property (nonatomic, retain) SHMessage *message;

//播放语音动画
- (void)playVoiceAnimation;
//停止语音动画
- (void)stopVoiceAnimation;

@end
