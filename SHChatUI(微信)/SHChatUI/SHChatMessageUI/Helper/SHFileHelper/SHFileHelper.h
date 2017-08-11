//
//  SHFileHelper.h
//  CoolTalk
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  文件操作工具类
 */

@interface SHFileHelper : NSObject

/**
 *  获取Documents目录路径
 **/
+ (NSString *)getDocumentsDirectory;

/**
 *  获取Caches目录路径
 **/
+ (NSString *)getCachesDirectory;

/**
 *  获取tmp目录路径
 **/
+ (NSString *)getTemporaryDirectory;

/**
 *  获取文件夹（没有的话创建）
 **/
+ (NSString *)getCreateFilePath:(NSString *)path;

/**
 *  删除文件（文件路径）
 **/
+ (BOOL)deleteFileAtPath:(NSString *)path;

/**
 *  删除文件（文件名)
 **/
+ (BOOL)deleteFileAtName:(NSString *)filename;

/**
 *  保存数据
 */
+ (BOOL)saveDataPath:(NSString *)path FileName:(NSString *)filename Content:(id)content;

/**
 *  读取数据
 */
+ (id)loadDataPath:(NSString *)path FileName:(NSString *)filename;

/**
 *  根据当前时间生成字符串(文件用)
 **/
+ (NSString *)getFileCurrentTimeString;

/**
 *  根据当前时间生成字符串(显示用)
 */
+ (NSString *)getCurrentTimeString;

/**
 *  判断沙盒里面是否存在这个文件，不存在拷贝一份到沙盒路径
 *
 *  @param oldFileName 应用内文件名称
 *  @param newFileName 拷贝到沙河的文件
 *
 *  @return 拷贝完成的文件路径
 */
+ (NSString *)oldFileName:(NSString *)oldFileName newFileName:(NSString *)newFileName;

/**
 *  获取录音设置
 *
 *  @return 录音设置
 */
+ (NSDictionary*)getAudioRecorderSettingDict;



@end
