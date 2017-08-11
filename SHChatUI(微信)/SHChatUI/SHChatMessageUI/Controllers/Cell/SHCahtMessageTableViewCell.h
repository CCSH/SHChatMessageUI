//
//  SHCahtMessageTableViewCell.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/29.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMessage.h"
#import "SHMessageFrame.h"
#import "SHMessageContentView.h"

@class SHCahtMessageTableViewCell;
@class SHMessageFrame;

@protocol SHCahtMessageCellDelegate <NSObject>

@optional
//头像点击
- (void)headImageClick:(SHCahtMessageTableViewCell *)cell message:(SHMessage *)message clickType:(SHMessageClickType )clickType;
//消息点击
- (void)contentClick:(SHCahtMessageTableViewCell *)cell message:(SHMessage *)message clickType:(SHMessageClickType )clickType;

//重发点击
- (void)repeatClick:(SHCahtMessageTableViewCell *)cell message:(SHMessage *)message;

@end

@interface SHCahtMessageTableViewCell : UITableViewCell

@property (nonatomic, assign)id<SHCahtMessageCellDelegate>delegate;

@property (nonatomic, retain)SHMessageFrame *messageFrame;

@property (nonatomic, retain)SHMessageContentView *btnContent;

@property (nonatomic, retain)UILabel *labelTime;

@property (nonatomic, retain)UILabel *labelNum;

@property (nonatomic, retain)UIButton *btnHeadImage;

@end
