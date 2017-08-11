//
//  NSString+SHExtension.h
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

//获取拼音
@property (nonatomic, copy) NSString *pinyin;
//获取MD5加密
@property (nonatomic, copy) NSString *md5;

//获取字符串长度(中文：2 其他：1）
@property (nonatomic, assign) NSInteger textLenght;

//是否为邮箱
@property (nonatomic, assign) BOOL isEmail;
//是否包含特殊字符
@property (nonatomic, assign) BOOL isSpecial;
//是否首字母开头
@property (nonatomic, assign) BOOL isFirstLetter;

//64编码
@property (nonatomic, copy) NSString *base64;
//64解码
@property (nonatomic, copy) NSString *decoded64;

//time
//格式化时间
//聊天界面时间
@property (nonatomic, copy) NSString *chatTime;
//日期(毫秒)
@property (nonatomic, copy) NSString *date;

//获取格式化后的时长
+ (NSString *)getFormatDuration:(NSInteger)duration;


@end
