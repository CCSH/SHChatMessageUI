//
//  SHChatMessageTableViewCell.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/29.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMessageFrame.h"
#import "SHMessageContentView.h"

@class SHChatMessageTableViewCell;

@protocol SHCahtMessageCellDelegate <NSObject>

@optional
//头像点击
- (void)headImageClick:(SHChatMessageTableViewCell *)cell message:(SHMessage *)message clickType:(SHMessageClickType )clickType;

//消息点击
- (void)contentClick:(SHChatMessageTableViewCell *)cell message:(SHMessage *)message clickType:(SHMessageClickType )clickType;

//重发点击
- (void)repeatClick:(SHChatMessageTableViewCell *)cell message:(SHMessage *)message;

@end

@interface SHChatMessageTableViewCell : UITableViewCell

//代理
@property (nonatomic, assign) id <SHCahtMessageCellDelegate>delegate;
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

@end
