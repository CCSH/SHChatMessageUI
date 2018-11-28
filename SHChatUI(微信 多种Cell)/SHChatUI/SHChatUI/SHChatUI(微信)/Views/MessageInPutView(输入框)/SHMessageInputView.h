//
//  SHMessageInputView.h
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMessageHeader.h"

/**
 聊天输入框
 */

@protocol SHMessageInputViewDelegate <NSObject>

@optional

// text
- (void)chatMessageWithSendText:(NSString *)text;

// image
- (void)chatMessageWithSendImage:(NSString *)imageName size:(CGSize)size;

// video
- (void)chatMessageWithSendVideo:(NSString *)videoName;

// audio
- (void)chatMessageWithSendVoice:(NSString *)voiceName duration:(NSString *)duration;

// location
- (void)chatMessageWithSendLocation:(NSString *)locationName lon:(CGFloat)lon lat:(CGFloat)lat;

// card
- (void)chatMessageWithSendCard:(NSString *)card;

// note
- (void)chatMessageWithSendNote:(NSString *)note;

// red
- (void)chatMessageWithSendRedPackage:(NSString *)redPackage;

// gif
- (void)chatMessageWithSendGif:(NSString *)gifName size:(CGSize)size;

//工具栏高度改变
- (void)toolbarHeightChange;

//下方菜单点击
- (void)didSelecteMenuItem:(SHShareMenuItem *)menuItem index:(NSInteger)index;

@end

@interface SHMessageInputView : UIView

//父视图
@property (nonatomic, strong) UIViewController *supVC;
//代理
@property (nonatomic, weak) id<SHMessageInputViewDelegate> delegate;
//当前输入框类型
@property (nonatomic, assign) SHInputViewType inputType;
//多媒体数据
@property (nonatomic, strong) NSArray *shareMenuItems;

//刷新视图
- (void)reloadView;

#pragma mark - 菜单内容
//打开照片
- (void)openPhoto;
//打开相机
- (void)openCarema;
//打开定位
- (void)openLocation;
//打开名片
- (void)openCard;
//打开红包
- (void)openRedPaper;

@end
