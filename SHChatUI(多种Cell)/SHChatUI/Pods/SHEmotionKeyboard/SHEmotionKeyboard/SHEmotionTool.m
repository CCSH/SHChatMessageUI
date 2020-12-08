//
//  SHEmotionTool.m
//  SHEmotionKeyboard
//
//  Created by CSH on 2016/12/7.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHEmotionTool.h"
#import "SHEmotionModel.h"
#import "SHEmotionAttachment.h"

//最近表情数组
static NSMutableArray *_recentEmotions;
//收藏表情数组
static NSMutableArray *_collectImages;

@implementation SHEmotionTool

#pragma mark 初始化
+ (void)initialize{
    
    //拿出最近表情
    if (!_recentEmotions) {
        _recentEmotions = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kRecent_save_path]];
    }
    
    //拿出收藏表情
    if (!_collectImages) {
        _collectImages = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kCollect_save_path]];
    }
}

#pragma mark - 获取plist路径下的数据
+ (NSArray *)loadResourceWithType:(SHEmoticonType)type{
    
    NSString *name;
    
    switch (type) {
        case SHEmoticonType_custom://自定义
        {
            name = @"custom_emoji";
        }
            break;
        case SHEmoticonType_gif://gif
        {
            name = @"gif_emoji";
        }
            break;
        case SHEmoticonType_system://系统
        {
            name = @"system_emoji";
        }
            break;
        default:
            break;
    }
    
    NSBundle *bundle = [NSBundle bundleWithPath:[self getEmotionBundle]];
    
    NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%@/sh_emotion_info",name] ofType:@"plist"];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    return array;
}

#pragma mark 获取Bundle路径
+ (NSString *)getEmotionBundle{
    
    return [[NSBundle bundleForClass:[SHEmotionTool class]] pathForResource:@"SHEmotionKeyboard" ofType:@"bundle"];
}

#pragma mark - 表情键盘操作
#pragma mark 添加到最近表情
+ (void)addRecentEmotion:(SHEmotionModel *)emotion{
    
    [_recentEmotions removeObject:emotion];
    [_recentEmotions insertObject:emotion atIndex:0];
    
    //最近表情保留前20
    if (_recentEmotions.count > 20) {
        NSArray *temp = [_recentEmotions subarrayWithRange:NSMakeRange(0, 20)];
        _recentEmotions = [NSMutableArray arrayWithArray:temp];
    }
  
    //保存
    [NSKeyedArchiver archiveRootObject:[_recentEmotions copy] toFile:kRecent_save_path];
}

#pragma mark 添加图片到收藏
+ (void)addCollectImageWithUrl:(NSString *)url{
    
    NSString *path = [SHEmotionTool getEmojiPathWithType:SHEmoticonType_collect];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:url.lastPathComponent];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BOOL isHave = NO;
        //是否存在
        for (SHEmotionModel *model in _collectImages) {
            if ([model.url isEqualToString:url]) {//已经存在
                [_collectImages removeObject:model];
                isHave = YES;
                break;
            }
        }
        //已经存在的话就不用下载了
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            BOOL result = [data writeToFile:path atomically:YES];
            if (!result) {
                NSLog(@"添加收藏失败");
                return ;
            }
        }
        
        //添加
        SHEmotionModel *model = [[SHEmotionModel alloc]init];
        model.code = [NSString stringWithFormat:@"[%@]",url.lastPathComponent];
        model.png = url.lastPathComponent;
        model.type = SHEmoticonType_collect;
        model.url = url;
        [_collectImages insertObject:model atIndex:0];
        
        [NSKeyedArchiver archiveRootObject:[_collectImages copy] toFile:kCollect_save_path];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollectViewNoti" object:nil];
    });
}
#pragma mark 删除收藏图片
+ (void)delectCollectImageWithModel:(SHEmotionModel *)model{
    [_collectImages removeObject:model];
    [NSKeyedArchiver archiveRootObject:[_collectImages copy] toFile:kCollect_save_path];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCollectViewNoti" object:nil];
}

#pragma mark - 获取资源图片
//获取表情图片路径
+ (NSString *)getEmojiPathWithType:(SHEmoticonType)type{
    
    switch (type) {
        case SHEmoticonType_custom://自定义
        {
            return [NSString stringWithFormat:@"%@/custom_emoji/",[self getEmotionBundle]];
        }
            break;
        case SHEmoticonType_gif://Gif
        {
            return [NSString stringWithFormat:@"%@/gif_emoji/",[self getEmotionBundle]];
        }
            break;
        case SHEmoticonType_collect://收藏
        {
            return [NSString stringWithFormat:@"%@CollectImage/",DocumentPatch];
        }
            break;
        default:
            break;
    }
    return @"";
}
//获取其他资源图片
+ (UIImage *)emotionImageWithName:(NSString *)name{
    NSBundle *bundle = [NSBundle bundleWithPath:[self getEmotionBundle]];
    
    NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"other/%@@2x.png",name] ofType:@""];
    
    return [UIImage imageWithContentsOfFile:path];
}

#pragma mark - 获取表情列表
#pragma mark 获取最近表情
+ (NSArray *)recentEmotions{
    return _recentEmotions;
}

#pragma mark 收藏图片
+ (NSArray *)collectEmotions{
    return _collectImages;
}

#pragma mark 自定义表情
+ (NSArray *)customEmotions{
    
    //读取默认表情
    NSArray *array = [self loadResourceWithType:SHEmoticonType_custom];
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
    NSArray *array = [self loadResourceWithType:SHEmoticonType_system];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        //模型转换
        SHEmotionModel *model = [SHEmotionModel emotionWithDict:dict];
        model.type = SHEmoticonType_system;
        [arrayM addObject:model];
    }
    
    return arrayM;
}

#pragma mark gif表情
+ (NSArray *)gifEmotions{
    //读取大表情
    NSArray *array = [self loadResourceWithType:SHEmoticonType_gif];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in array) {
        //模型转换
        SHEmotionModel *model = [SHEmotionModel emotionWithDict:dict];
        model.type = SHEmoticonType_gif;
        [arrayM addObject:model];
    }
    
    return arrayM;
}

#pragma mark - 字符串处理
#pragma mark model -> att
+ (NSAttributedString *)getAttWithEmotion:(SHEmotionModel *)emotion font:(UIFont *)font{
    
    SHEmotionAttachment *textAttachment = [[SHEmotionAttachment alloc]init];//添加附件,图片
    textAttachment.emotion = emotion;
    
    switch (emotion.type) {
        case SHEmoticonType_custom:case SHEmoticonType_gif://Gif、自定义
        {
            textAttachment.emotion = emotion;
            //调整位置
            CGFloat height = font.lineHeight;
            textAttachment.bounds = CGRectMake(0, -3, height, height);
            
            return [NSAttributedString attributedStringWithAttachment:textAttachment];
        }
            break;
        case SHEmoticonType_system://系统
        {
            return [[NSAttributedString alloc]initWithString:emotion.code];
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark str -> model
+ (SHEmotionModel *)getEmotionWithCode:(NSString *)code{
    
    //遍历自定义表情
    NSArray *emotions = [self customEmotions];
    for (SHEmotionModel *emotion in emotions) {
        if ([emotion.code isEqualToString:code]) {
            return emotion;
        }
    }
    
    //遍历GIF表情
    emotions = [self gifEmotions];
    for (SHEmotionModel *emotion in emotions) {
        if ([emotion.code isEqualToString:code]) {
            return emotion;
        }
    }
    return nil;
}

#pragma mark str -> att
+ (NSAttributedString *)getAttWithStr:(NSString *)str font:(UIFont *)font{
    
    NSString *zhengze = @"\\[[^\\[|^\\]]+\\]";
    //正则表达式
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:zhengze options:NSRegularExpressionCaseInsensitive error:nil];
    
    //找出所有符合正则的位置集合
    NSArray *zhengzeArr = [re matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    NSMutableArray *faceArr = [[NSMutableArray alloc] init];
    //添加资源文件
    [faceArr addObjectsFromArray:[SHEmotionTool customEmotions]];
    [faceArr addObjectsFromArray:[SHEmotionTool gifEmotions]];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:font}];
    
    //如果有多个表情图，必须从后往前替换，因为替换后Range就不准确了
    for (NSInteger j = (zhengzeArr.count - 1); j >= 0; j--) {
        
        //NSTextCheckingResult里面包含range
        NSTextCheckingResult *result = zhengzeArr[j];
        
        //去所有表情里面查找内容
        [faceArr enumerateObjectsUsingBlock:^(SHEmotionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //从数组中的字典中取元素、找到了进行替换
            if ([[str substringWithRange:result.range] isEqualToString:obj.code]){
                
                SHEmotionModel *model = [SHEmotionTool getEmotionWithCode:obj.code];

                //替换未图片附件
                [attStr replaceCharactersInRange:result.range withAttributedString:[self getAttWithEmotion:model font:font]];
                
                *stop = YES;
            }
        }];
    }
    
    return attStr;
}

#pragma mark att -> str
+ (NSString *)getRealStrWithAtt:(NSAttributedString *)att{
    
    NSMutableString *string = [NSMutableString string];
    
    // 2.遍历富文本里的所有内容
    [att enumerateAttributesInRange:NSMakeRange(0, att.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        SHEmotionAttachment *attach = attrs[@"NSAttachment"];
        
        if (attach.emotion.code) { // 如果是带有附件的富文本

            [string appendString:attach.emotion.code];
        } else { // 普通的文本

            NSString *substr = [att attributedSubstringFromRange:range].string;
            [string appendString:substr];
        }
    }];
    return string;
}

@end
