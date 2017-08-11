//
//  SHChatMessageViewController.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMessage.h"

@interface SHChatMessageViewController : UIViewController

//用户信息
@property (nonatomic, strong)SHMessage *messageModel;

@end
