//
//  SHEmotionTool.m
//  SHEmotionKeyboardUI
//
//  Created by CSH on 2016/12/7.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHEmotionTool.h"
#import "SHEmotionModel.h"

//最近表情数组
static NSMutableArray *_recentEmotions;
//收藏表情数组
static NSMutableArray *_collectImages;

@implementation SHEmotionTool

#pragma mark 初始化
+ (void)initialize{
    
    //拿出最近表情
    if (!_recentEmotions) {
        _recentEmotions = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:Recentemotions_PAHT]];
    }
    
    //拿出收藏表情
    if (!_collectImages) {
        _collectImages = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:CollectImage_PAHT]];
    }
}

#pragma mark - 通过表情的描述字符串找到对应表情模型
+ (SHEmotionModel *)emotionWithChs:(NSString *)chs{
    
    //先遍历自定义表情
    NSArray *customEmotions = [self customEmotions];
    for (SHEmotionModel *emotion in customEmotions) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    
    //没有的话遍历GIF表情
    NSArray *gifEmotions = [self gifEmotions];
    for (SHEmotionModel *emotion in gifEmotions) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    return nil;
}

#pragma mark - 添加最近图片
+ (void)addRecentEmotion:(SHEmotionModel *)emotion{
    
    [_recentEmotions removeObject:emotion];
    [_recentEmotions insertObject:emotion atIndex:0];
    
    //3.保存
    [NSKeyedArchiver archiveRootObject:[_recentEmotions copy] toFile:Recentemotions_PAHT];
}

#pragma mark - 添加收藏图片
+ (void)addCollectImageWithUrl:(NSString *)url{
    
    NSString *path = kCollect_Emoji_Path;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:url.lastPathComponent];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        BOOL result =[data writeToFile:path atomically:YES];
        if (result) {
            NSLog(@"添加收藏成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                SHEmotionModel *model = [[SHEmotionModel alloc]init];
                model.code = [NSString stringWithFormat:@"[%@]",url.lastPathComponent];
                model.png = url.lastPathComponent;
                model.type = SHEmoticonType_collect;
                model.url = url;
                
                [_collectImages removeObject:model];
                [_collectImages insertObject:model atIndex:0];
                
                [NSKeyedArchiver archiveRootObject:[_collectImages copy] toFile:CollectImage_PAHT];
            });
        }else{
            NSLog(@"添加收藏失败");
        }
    });
}

#pragma mark - 删除收藏图片
+ (void)delectCollectImageWithModel:(SHEmotionModel *)model{
    
    [_collectImages removeObject:model];
    [NSKeyedArchiver archiveRootObject:[_collectImages copy] toFile:CollectImage_PAHT];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"delectCollectImage" object:nil];
    
}

#pragma mark - 获取plist路径下的数据
+ (NSArray *)loadResourceWithName:(NSString *)name{
    
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"SHEmotionKeyboard.bundle" ofType:nil];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%@/info.plist",name] ofType:@""];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    return array;
}

#pragma mark - 获取other图片
+ (UIImage *)emotionImageWithName:(NSString *)name{
    
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"SHEmotionKeyboard.bundle" ofType:nil];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"other/%@@2x.png",name] ofType:@""];
    
    return [UIImage imageWithContentsOfFile:path];
}

#pragma mark - 获取图片
#pragma mark 收藏图片
+ (NSArray *)collectEmotions{
    return _collectImages;
}

#pragma mark 最近图片
+ (NSArray *)recentEmotions{
    return _recentEmotions;
}

#pragma mark 自定义表情
+ (NSArray *)customEmotions{
    //读取默认表情
    NSArray *array = [self loadResourceWithName:@"custom_emoji"];
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        //模型转换
        SHEmotionModel *model = [SHEmotionModel emotionWithDict:dict];
        model.type = SHEmoticonType_custom;
        [arrayM addObject:model];
    };
    
    return arrayM;
}

#pragma mark 系统表情
+ (NSArray *)systemEmotions{
    //读取emoji表情
    NSArray *array = [self loadResourceWithName:@"system_emoji"];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        //模型转换
        SHEmotionModel *model = [SHEmotionModel emotionWithDict:dict];
        model.type = SHEmoticonType_system;
        [arrayM addObject:model];
    }
    
    return arrayM;
}

#pragma mark GIF表情
+ (NSArray *)gifEmotions{
    //读取大表情
    NSArray *array = [self loadResourceWithName:@"gif_emoji"];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        //模型转换
        SHEmotionModel *model = [SHEmotionModel emotionWithDict:dict];
        model.type = SHEmoticonType_gif;
        [arrayM addObject:model];
    }

    return arrayM;
}

#pragma mark 字符串处理 字符串 -> 表情
+ (NSMutableAttributedString *)dealMessageWithEmotion:(SHEmotionModel *)emotion {
    
    NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];//添加附件,图片
    
    switch (emotion.type) {
        case SHEmoticonType_custom://自定义
        {
            textAttachment.image = [UIImage imageWithContentsOfFile:[kCustom_Emoji_Path stringByAppendingString:emotion.png]];
        }
            break;
        case SHEmoticonType_gif://Gif
        {
            textAttachment.image = [UIImage imageWithContentsOfFile:[kGif_Emoji_Path stringByAppendingString:emotion.png]];
        }
            break;
        case SHEmoticonType_system://系统
        {
            return [[NSMutableAttributedString alloc]initWithString:emotion.path];
        }
            break;
        default:
            break;
    }
    
    //调整位置
    CGFloat height = [UIFont systemFontOfSize:18].lineHeight;
    textAttachment.bounds = CGRectMake(0, -5, height, height);
    
    return [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
}

#pragma mark 全字符串处理 表情 -> 字符串
+ (NSMutableAttributedString *)dealMessageWithStr:(NSString *)str{
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];

    //    \\[(emoji_\\d+?)\\]               [emoji_数字]
    //    \\[[\\u4e00-\\u9fa5|a-z|A-Z]+\\]     [文字]
    
    NSString *zhengze = @"\\[[^\\[|^\\]]+\\]";
    //正则表达式
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:zhengze options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *arr = [re matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    NSMutableArray *faceArr = [[NSMutableArray alloc] init];
    //添加资源文件
    [faceArr addObjectsFromArray:[SHEmotionTool customEmotions]];
    [faceArr addObjectsFromArray:[SHEmotionTool gifEmotions]];
    
    //如果有多个表情图，必须从后往前替换，因为替换后Range就不准确了
    for (int j =(int) arr.count - 1; j >= 0; j--) {
        //NSTextCheckingResult里面包含range
        NSTextCheckingResult * result = arr[j];
        
        [faceArr enumerateObjectsUsingBlock:^(SHEmotionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([[str substringWithRange:result.range] isEqualToString:obj.code] || [[str substringWithRange:result.range] isEqualToString:obj.chs])//从数组中的字典中取元素
            {
                SHEmotionModel *model = [SHEmotionTool emotionWithChs:obj.chs];
                //替换未图片附件
                [attStr replaceCharactersInRange:result.range withAttributedString:[self dealMessageWithEmotion:model]];
                
                *stop = YES;
            }
        }];
    }

    return attStr;
}

@end
