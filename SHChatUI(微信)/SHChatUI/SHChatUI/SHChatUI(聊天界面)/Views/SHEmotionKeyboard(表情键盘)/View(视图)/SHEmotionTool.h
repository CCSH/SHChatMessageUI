//
//  SHEmotionTool.h
//  SHEmotionKeyboardUI
//
//  Created by CSH on 2016/12/7.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SHEmotionModel.h"

//Document目录
#define DocumentPatch [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

//最新表情的路径
#define Recentemotions_PAHT [DocumentPatch stringByAppendingPathComponent:@"recentemotions.archive"]

//收藏图片的路径
#define CollectImage_PAHT [DocumentPatch stringByAppendingPathComponent:@"CollectImage.archive"]


//收藏图片拼接路径
#define kCollect_Emoji_Path [DocumentPatch stringByAppendingPathComponent:@"CollectImage/"]
//自定义表情拼接路径
#define kCustom_Emoji_Path [NSString stringWithFormat:@"%@/custom_emoji/",[[NSBundle mainBundle] pathForResource:@"SHEmotionKeyboard" ofType:@"bundle"]]
//Gif表情拼接路径
#define kGif_Emoji_Path [NSString stringWithFormat:@"%@/gif_emoji/",[[NSBundle mainBundle] pathForResource:@"SHEmotionKeyboard" ofType:@"bundle"]]

/**
 表情键盘工具类
 */
@interface SHEmotionTool : NSObject

//通过表情的描述字符串找到对应表情模型
+ (SHEmotionModel *)emotionWithChs:(NSString *)chs;

//添加最近表情到最近表情列表(集合)
+ (void)addRecentEmotion:(SHEmotionModel *)emotion;
//添加图片到收藏
+ (void)addCollectImageWithUrl:(NSString *)url;
//删除收藏图片
+ (void)delectCollectImageWithModel:(SHEmotionModel *)model;
//获取other图片
+ (UIImage *)emotionImageWithName:(NSString *)name;


//获取最近表情列表
+ (NSArray *)recentEmotions;

//自定义表情
+ (NSArray *)customEmotions;

//系统表情
+ (NSArray *)systemEmotions;

//gif表情
+ (NSArray *)gifEmotions;

//收藏图片
+ (NSArray *)collectEmotions;

//字符串处理 字符串 -> 表情
+ (NSMutableAttributedString *)dealMessageWithEmotion:(SHEmotionModel *)emotion;

//字符串处理 表情 -> 字符串
+ (NSMutableAttributedString *)dealMessageWithStr:(NSString *)str;

@end
