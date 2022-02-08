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

// 文本
- (void)chatMessageWithSendText:(NSString *)text;

// 图片
- (void)chatMessageWithSendImage:(NSString *)imageName size:(CGSize)size;

// 视频
- (void)chatMessageWithSendVideo:(NSString *)videoName fileSize:(NSString *)fileSize duration:(NSString *)duration size:(CGSize)size;

// 语音
- (void)chatMessageWithSendAudio:(NSString *)audioName duration:(NSInteger)duration;

// 位置
- (void)chatMessageWithSendLocation:(NSString *)locationName lon:(CGFloat)lon lat:(CGFloat)lat;

// 名片
- (void)chatMessageWithSendCard:(NSString *)card;

// 通知
- (void)chatMessageWithSendNote:(NSString *)note;

// 红包
- (void)chatMessageWithSendRedPackage:(NSString *)redPackage packageId:(NSString *)packageId;

// 动图
- (void)chatMessageWithSendGif:(NSString *)gifName size:(CGSize)size;

// 文件
- (void)chatMessageWithSendFile:(NSString *)fileName displayName:(NSString *)displayName fileSize:(NSString *)fileSize;

//工具栏高度改变
- (void)toolbarHeightChange;

//下方菜单点击
- (void)didSelecteMenuItem:(SHShareMenuItem *)menuItem index:(NSInteger)index;

@end

@interface SHMessageInputView : UIView

//父视图
@property (nonatomic, weak) UIViewController *supVC;
//代理
@property (nonatomic, weak) id<SHMessageInputViewDelegate> delegate;
//当前输入框类型
@property (nonatomic, assign) SHInputViewType inputType;
//多媒体数据
@property (nonatomic, copy) NSArray *shareMenuItems;

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
//打开文件
- (void)openFile;

//清除内部通知
-(void)clear;

@end
