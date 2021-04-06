//
//  SHChatMessageLocationViewController.h
//  SHChatUI
//
//  Created by CSH on 2018/6/26.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMessageHeader.h"

/**
 定位界面
 */
@interface SHChatMessageLocationViewController : UIViewController

//地图类型
@property (nonatomic, assign) SHMessageLocationType locType;

//数据模型
@property (nonatomic, strong) SHMessage *message;

//回调
@property (nonatomic, copy) void (^block)(SHMessage *message);

@end
