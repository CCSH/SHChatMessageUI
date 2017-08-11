//
//  SHMessageInputView.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SHShareMenuView.h"
#import "SHMessageType.h"

@class SHMessageInputView;

@protocol SHMessageInputViewDelegate <NSObject>

// text
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendMessage:(NSString *)message;

// image
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendPicture:(UIImage *)image;

// video
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendVideoPath:(NSString *)videoPath videoImage:(UIImage *)videoImage;

// audio
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendVoiceWithWavPath:(NSString *)wavPath AmrPath:(NSString *)amrPath RecordDuration:(NSString *)recordDuration;

// location
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendCLLocation:(CLLocation *)location LocationName:(NSString *)locationName;

// card
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendCard:(NSString *)card;

//语音点击
- (void)voiceRecordClick;
//输入框表情点击
- (void)expressionClick;
//多媒体点击
- (void)multimediaClick;

@end

typedef void(^DidGetGeolocationsCompledBlock)(NSArray *placemarks);

@interface SHMessageInputView : UIView

//语音、文本切换
@property (nonatomic, retain) UIButton *btnChangeVoiceState;
//发送多媒体
@property (nonatomic, retain) UIButton *btnMultimedia;
//发送表情
@property (nonatomic, retain) UIButton *btnExpression;

//语音录入
@property (nonatomic, retain) UIButton *btnVoiceRecord;
//输入框
@property (nonatomic, retain) UITextView *textViewInput;

@property (nonatomic, assign) UIViewController *superVC;

//当前的界面类型
@property (nonatomic, assign) SHInputViewType textViewInputViewType;

@property (nonatomic, assign) id<SHMessageInputViewDelegate>delegate;

/**
 *  绘制ToolBar
 *
 *  @param frame   坐标
 *  @param superVC 视图
 *  @param type    类型
 *
 *  @return 
 */
- (id)initWithFrame:(CGRect)frame SuperVC:(UIViewController *)superVC WithType:(NSString *)type
;

//打开照片
- (void)openPicLibrary;
//打开相机
- (void)openCarema;
//打开定位
- (void)openLocation;
//打开名片
- (void)openCard;



@end
