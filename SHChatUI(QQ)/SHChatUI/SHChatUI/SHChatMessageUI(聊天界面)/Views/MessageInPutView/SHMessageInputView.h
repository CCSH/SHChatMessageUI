//
//  SHMessageInputView.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SHMessageMacroHeader.h"

@class SHMessageInputView;

@protocol SHMessageInputViewDelegate <NSObject>

// text
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendMessage:(NSString *)message;

// image
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendPicture:(NSString *)imagePath imageSize:(CGSize )imageSize;

// video
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendVideo:(NSString *)videoPath;

// audio
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendVoice:(NSString *)wavPath AmrPath:(NSString *)amrPath RecordDuration:(NSString *)recordDuration;

// location
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendLocation:(NSString *)locationName Lon:(CGFloat)lon Lat:(CGFloat)lat;

// card
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendCard:(NSString *)card;

// prompt
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendPrompt:(NSString *)prompt;

// red
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendRedPackage:(NSString *)redPackage;

// gif
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendGif:(NSString *)gifPath gifSize:(CGSize)gifSize;

//工具栏的出现与消失
- (void)toolbarWithIsShow:(BOOL)isShow;

@end

typedef void(^DidGetGeolocationsCompledBlock)(NSArray *placemarks);

@interface SHMessageInputView : UIView

//多媒体数据
@property (nonatomic, strong) NSArray *shareMenuItems;

//多媒体控件
@property (nonatomic, strong) SHShareMenuView *shareMenuView;
//表情控件
@property (nonatomic, strong) SHEmotionKeyboard *emotionKeyboard;
//相册控件
@property (nonatomic, strong) SHPhotoPicker *photoPicker;

//语音录入
@property (nonatomic, retain) UIButton *btnVoiceRecord;
//输入框
@property (nonatomic, retain) UITextView *textViewInput;

//阅后即焚控制
@property (nonatomic, assign) BOOL isBurn;
//代理
@property (nonatomic, assign) id<SHMessageInputViewDelegate>delegate;

/**
 *  绘制ToolBar
 *
 *  @param chatId  用户ID
 *  @param frame   坐标
 *  @param superVC 视图
 *  @param type    类型
 *
 *  @return SHMessageInputView
 */
- (SHMessageInputView *)initWithFrame:(CGRect)frame ChatId:(NSString *)chatId SuperVC:(UIViewController *)superVC Type:(SHChatType)type;

//打开照片
- (void)openPicLibrary;
//打开相机
- (void)openCarema;
//打开定位
- (void)openLocation;
//打开名片
- (void)openCard;
//打开红包
- (void)openRedPaper;
//打开涂鸦
- (void)openGraffiti;
//打开背景图
- (void)openBackground;

@end
