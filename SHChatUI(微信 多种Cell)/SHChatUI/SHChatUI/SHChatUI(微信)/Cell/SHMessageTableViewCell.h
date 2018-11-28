//
//  SHMessageTableViewCell.h
//  SHChatUI
//
//  Created by CSH on 2018/6/7.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMessageHeader.h"
#import "SHActivityIndicatorView.h"

@class SHMessageContentView;
@class SHMessageFrame;
@class SHMessageTableViewCell;

@protocol SHChatMessageCellDelegate <NSObject>

@optional
//点击
- (void)didSelectWithCell:(SHMessageTableViewCell *)cell type:(SHMessageClickType)type message:(SHMessage *)message;

@end

@interface SHMessageTableViewCell : UITableViewCell

//点击位置
@property (nonatomic, assign) CGPoint tapPoint;

//代理
@property (nonatomic, weak) id <SHChatMessageCellDelegate>delegate;
//坐标
@property (nonatomic, retain) SHMessageFrame *messageFrame;
//内容
@property (nonatomic, retain) SHMessageContentView *btnContent;
//时间
@property (nonatomic, retain) UILabel *labelTime;
//ID
@property (nonatomic, retain) UILabel *labelNum;
//头像
@property (nonatomic, retain) UIButton *btnHeadImage;
//消息状态
@property (nonatomic, retain) SHActivityIndicatorView *activityView;

//是否发送
@property (nonatomic, assign) BOOL isSend;

@end
