//
//  SHMessageHelper.h
//  iOSAPP
//
//  Created by CSH on 2016/11/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHMessageMacroHeader.h"

/**
 消息帮助类
 */
@interface SHMessageHelper : NSObject

/**
 添加公共配置

 @param message 消息model
 @return 新的消息model
 */
+ (SHMessage *)addPublicParameterWidthSHMessage:(SHMessage *)message;

@end
