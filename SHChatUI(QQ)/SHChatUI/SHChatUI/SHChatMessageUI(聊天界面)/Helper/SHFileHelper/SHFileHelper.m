//
//  SHFileHelper.m
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SHMessageMacroHeader.h"

@implementation SHFileHelper

/**
 *  获取Documents目录路径
 **/
+ (NSString *)getDocumentsDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/**
 *  获取Caches目录路径
 **/
+ (NSString *)getCachesDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/**
 *  获取tmp目录路径
 **/
+ (NSString *)getTemporaryDirectory{
    return NSTemporaryDirectory();
}

/**
 *  获取文件夹（没有的话创建）
 **/
+ (NSString *)getCreateFilePath:(NSString *)path {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}


/**
 *  删除文件（文件路径）
 **/
+ (BOOL)deleteFileAtPath:(NSString *)path{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

/**
 *  删除文件（文件名)
 **/
+ (BOOL)deleteFileAtName:(NSString *)filename{
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[SHFileHelper getDocumentsDirectory],filename];
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

/**
 *  保存数据
 */
+ (BOOL)saveDataPath:(NSString *)path FileName:(NSString *)filename Content:(id)content{
    
    if (!path) {
        path = [SHFileHelper getDocumentsDirectory];
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[SHFileHelper getCreateFilePath:path],filename];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:content forKey:filename];
    return [dic writeToFile:filePath atomically:YES];
}

/**
 *  读取数据
 */
+ (id)loadDataPath:(NSString *)path FileName:(NSString *)filename{
    if (!path) {
        path = [SHFileHelper getDocumentsDirectory];
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[SHFileHelper getCreateFilePath:path],filename];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return [dic objectForKey:filename];
}

/**
 *  判断沙盒里面是否存在这个文件，不存在拷贝一份到沙盒路径
 */
+ (NSString *)oldFileName:(NSString *)oldFileName newFileName:(NSString *)newFileName{
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[SHFileHelper getDocumentsDirectory],newFileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) //如果不存在
    {
        NSLog(@"文件不存在，进行拷贝");
        NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:oldFileName ofType:nil];
        [[NSFileManager defaultManager] copyItemAtPath:backupDbPath toPath:filePath error:nil];
    }else{
        NSLog(@"文件存在，不作操作");
    }
    return filePath;
}

/**
 *  获取录音设置
 *
 *  @return 录音设置
 */
+ (NSDictionary *)getAudioRecorderSettingDict {
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    return recordSetting;
}

//获取资源文件路径
//获取视频第一帧路径
+ (NSString *)getVideoImageWithVideo:(NSString *)video{
    return [NSString stringWithFormat:@"%@/%@.jpg",kSHVideoImagePath,[[video.lastPathComponent componentsSeparatedByString:@"."] firstObject]];
}

#pragma mark 图片保存到本地
+ (NSString *)saveDataWithLocalData:(NSData *)data fileType:(NSString *)fileType{
    
    NSString *filePath;
    
    if ([fileType containsString:@"gif"]) {//Gif
        
        filePath = [NSString stringWithFormat:@"%@/%@.gif",kSHGifPath,[SHMessageTimeHelper getTimeZoneMs]];
    }else if ([fileType containsString:@"mp4"]){
        
        filePath = [NSString stringWithFormat:@"%@/%@.gif",kSHVideoPath,[SHMessageTimeHelper getTimeZoneMs]];
    }else{
        
        filePath = [NSString stringWithFormat:@"%@/%@.jpg",kSHImagePath,[SHMessageTimeHelper getTimeZoneMs]];
    }
    
    //保存到本地
    [data writeToFile:filePath atomically:NO];
    
    return filePath;
}

@end
