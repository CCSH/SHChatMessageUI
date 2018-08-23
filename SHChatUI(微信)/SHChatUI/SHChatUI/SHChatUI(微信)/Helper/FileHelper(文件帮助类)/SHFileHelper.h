//
//  SHFileHelper.h
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHMessageType.h"

/**
 文件帮助类
 */
@interface SHFileHelper : NSObject

//获取文件路径（没有的话创建）
+ (NSString *)getCreateFilePath:(NSString *)path;

//获取录音设置
+ (NSDictionary *)getAudioRecorderSettingDict;

//获取资源名字并且保存资源
+ (NSString *)getFileNameWithContent:(id)content type:(SHMessageFileType)type;

//获取资源路径
+ (NSString *)getFilePathWithName:(NSString *)name type:(SHMessageFileType)type;

//获取名字
+ (NSString *)getNameWithUrl:(NSString *)url;

@end
