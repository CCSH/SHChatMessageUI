//
//  SHEmotionModel.h
//  SHEmotionKeyboard
//
//  Created by CSH on 2016/12/7.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SHEmoticonType) {
    SHEmoticonType_custom = 101,  //自定义表情
    SHEmoticonType_system,        //系统表情
    SHEmoticonType_gif,           //GIF表情
    SHEmoticonType_collect,       //收藏表情
    SHEmoticonType_recent,        //最近表情
};

/**
 表情键盘模型
 */
@interface SHEmotionModel : NSObject

/**
 *  emoji表情的code
 */
@property (nonatomic, copy) NSString *code;

/**
 *  图片名字
 */
@property (nonatomic, copy) NSString *png;

/**
 *  GIF图片名字
 */
@property (nonatomic, copy) NSString *gif;

/**
 *  收藏图片Url
 */
@property (nonatomic, copy) NSString *url;

/**
 *  表情对应的路径
 */
@property (nonatomic, copy) NSString *path;

/**
 表情类型
 */
@property (nonatomic, assign) SHEmoticonType type;

//转换
+ (instancetype)emotionWithDict:(NSDictionary *)dict;

@end
