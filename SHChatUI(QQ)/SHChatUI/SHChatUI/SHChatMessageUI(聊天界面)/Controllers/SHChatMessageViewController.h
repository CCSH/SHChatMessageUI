//
//  SHChatMessageViewController.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMessageType.h"

/**
 *  聊天界面
 */
@interface SHChatMessageViewController : UIViewController

//界面类型
@property (nonatomic, assign) SHChatType chatType;
//聊天ID
@property (nonatomic, strong) NSString *chatId;
@end
