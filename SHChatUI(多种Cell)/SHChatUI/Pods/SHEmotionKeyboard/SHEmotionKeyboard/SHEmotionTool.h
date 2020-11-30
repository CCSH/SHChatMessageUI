//
//  SHEmotionTool.h
//  SHEmotionKeyboard
//
//  Created by CSH on 2016/12/7.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SHEmotionModel.h"

//Document目录
#define DocumentPatch [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
//最近表情的路径
#define kRecent_save_path [DocumentPatch stringByAppendingPathComponent:@"recentemotions.archive"]
//收藏图片的路径
#define kCollect_save_path [DocumentPatch stringByAppendingPathComponent:@"collectemotions.archive"]

/**
 表情键盘工具类
 */
@interface SHEmotionTool : NSObject

#pragma mark - 表情键盘操作
//添加到最近表情
+ (void)addRecentEmotion:(SHEmotionModel *)emotion;

//添加图片到收藏
+ (void)addCollectImageWithUrl:(NSString *)url;
//删除收藏图片
+ (void)delectCollectImageWithModel:(SHEmotionModel *)model;

#pragma mark - 获取资源图片
//获取表情图片路径
+ (NSString *)getEmojiPathWithType:(SHEmoticonType)type;
//获取其他资源图片
+ (UIImage *)emotionImageWithName:(NSString *)name;

#pragma mark - 获取表情列表
//获取最近表情列表
+ (NSArray *)recentEmotions;
//收藏图片
+ (NSArray *)collectEmotions;
//自定义表情
+ (NSArray *)customEmotions;
//系统表情
+ (NSArray *)systemEmotions;
//gif表情
+ (NSArray *)gifEmotions;

#pragma mark - 字符串处理
//获取显示内容  model -> att
+ (NSAttributedString *)getAttWithEmotion:(SHEmotionModel *)emotion font:(UIFont *)font;
//获取model str -> model
+ (SHEmotionModel *)getEmotionWithCode:(NSString *)code;
//获取显示内容 str -> att
+ (NSAttributedString *)getAttWithStr:(NSString *)str font:(UIFont *)font;
//获取实际内容 att -> str
+ (NSString *)getRealStrWithAtt:(NSAttributedString *)att;

@end
