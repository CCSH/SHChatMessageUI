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
#import "SHMessage.h"
#import "SHActivityIndicatorView.h"
#import "SHTextView.h"

@class SHActivityIndicatorView;
@interface SHMessageContentView : UIButton

// text
@property (nonatomic, retain) SHTextView *textView;

// audio
@property (nonatomic, retain) UIImageView *voiceView;
// audio 时长
@property (nonatomic, retain) UILabel *voiceNum;
// 未读标记
@property (nonatomic, retain) UIImageView *readMarker;
// 正在播放 0 未播放 1 播放中
// 播放 YES 未播放 NO
@property (nonatomic, assign) BOOL isPlaying;

// location
@property (nonatomic, retain) MKMapView *locView;
// location 名称
@property (nonatomic, retain) UILabel *locName;

// video
// video 图标
@property (nonatomic, retain) UIImageView *videoIconView;

// note
@property (nonatomic, retain) UILabel *noteLab;

// card
// card 背景
@property (nonatomic, retain) UIImageView *cardBg;
// card line
@property (nonatomic, retain) UIView *cardLine;
// card 头像
@property (nonatomic, retain) UIImageView *cardHead;
// card 姓名
@property (nonatomic, retain) UILabel *cardName;
// card 提示
@property (nonatomic, retain) UILabel *cardPrompt;

// Gif
@property (nonatomic, retain) WKWebView *gifView;

//红包
//红包背景
@property(nonatomic, retain) UIImageView *redPaperBg;
//红包图片
@property(nonatomic, retain) UIImageView *redPaperImage;
//红包内容
@property(nonatomic, retain) UILabel *redPaperContent;
//红包备注
@property(nonatomic, retain) UILabel *redPaperRemark;
//红包来源
@property(nonatomic, retain) UILabel *redPaperSource;

//数据源
@property (nonatomic, retain) SHMessage *message;

//播放语音动画
- (void)playVoiceAnimation;
//停止语音动画
- (void)stopVoiceAnimation;

@end
