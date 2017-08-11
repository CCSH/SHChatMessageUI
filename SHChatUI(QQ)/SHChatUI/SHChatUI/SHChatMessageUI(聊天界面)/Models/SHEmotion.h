//
//  SHEmotion.h
//  iOSAPP
//
//  Created by CSH on 2016/12/6.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHEmotion : NSObject

/**
 *  emoji表情的code
 */
@property (nonatomic, copy) NSString *code;

/**
 *  表情对应的中文描述
 */
@property (nonatomic, copy) NSString *chs;

/**
 *  图片名字
 */
@property (nonatomic, copy) NSString *png;

/**
 *  图片名字
 */
@property (nonatomic, copy) NSString *gif;

@end
