//
//  SHFileHelper.h
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SHMessageEnum.h"

/**
 文件帮助类
 */
@interface SHFileHelper : NSObject

#pragma mark 获取文件路径（没有的话创建）
+ (NSString *)getCreateFilePath:(NSString *)path;

#pragma mark 获取录音设置
+ (NSDictionary *)getAudioRecorderSettingDict;

#pragma mark 获取资源路径并且保存资源
+ (NSString *)saveFileWithContent:(id)content type:(SHMessageFileType)type;

#pragma mark 获取资源路径
+ (NSString *)getFilePathWithName:(NSString *)name type:(SHMessageFileType)type;

#pragma mark 获取文件名
+ (NSString *)getFileNameWithPath:(NSString *)path;

#pragma mark 获取图片
+ (UIImage *)imageNamed:(NSString *)name;

#pragma mark 获取文件大小
+ (NSString *)getFileSize:(NSString *)path;

@end
