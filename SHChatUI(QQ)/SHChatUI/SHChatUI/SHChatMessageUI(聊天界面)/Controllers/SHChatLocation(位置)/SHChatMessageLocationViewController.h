//
//  SHChatMessageLocationViewController.h
//  SHChatMessageUI
//
//  Created by CSH on 16/8/8.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SHMessageType.h"
@class SHMessage;

/**
 *  位置消息展示界面
 */
@protocol SHLocationDelegate <NSObject>

//发送位置
- (void)sendCLLocationWithMessage:(SHMessage *)message;

@end

@interface SHChatMessageLocationViewController : UIViewController
//代理
@property (nonatomic, weak) id<SHLocationDelegate> delegate;
//地图类型
@property (nonatomic, assign) SHMessageLocationType locationType;
//数据模型
@property (nonatomic, strong) SHMessage *message;

@end
