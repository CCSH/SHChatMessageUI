//
//  SHDownloadManager.h
//  断点续传之下载
//
//  Created by CSH on 16/6/6.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHDownloadModel.h"

// 缓存主目录(下载目录)
#define SHCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"AppDownload"]

// 保存文件名
#define SHFileName(url)  [[url componentsSeparatedByString:@"/"] lastObject]

// 文件的存放路径（caches）
#define SHFileFullpath(url) [SHCachesDirectory stringByAppendingPathComponent:SHFileName(url)]

// 文件的已下载长度
#define SHDownloadLength(url) [[[NSFileManager defaultManager] attributesOfItemAtPath:SHFileFullpath(url) error:nil][NSFileSize] integerValue]

// 存储文件信息的路径（caches）
#define SHDownloadDetailPath [SHCachesDirectory stringByAppendingPathComponent:@"downloadDetail.txt"]

@protocol SHDownloadDelegate <NSObject>
/** 下载中的回调 */
- (void)downloadResponse:(SHDownloadModel *)downloadModel;

@end

@interface SHDownloadManager : NSObject

/** 保存所有下载相关信息字典 */
@property (nonatomic, strong, readonly) NSMutableDictionary *sessionModels;
/** 所有本地存储的所有下载信息数据数组 */
@property (nonatomic, strong, readonly) NSMutableArray *sessionModelsArray;
/** 下载完成的模型数组*/
@property (nonatomic, strong, readonly) NSMutableArray *downloadedArray;
/** 下载中的模型数组*/
@property (nonatomic, strong, readonly) NSMutableArray *downloadingArray;
/** SHDownloadDelegate */
@property (nonatomic, assign) id<SHDownloadDelegate> delegate;

/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (instancetype)sharedInstance;

/**
 * 归档
 */
- (void)save:(NSArray *)sessionModels;

/**
 * 读取model
 */
- (NSArray *)getSessionModels;

/**
 *  开启任务下载资源
 *
 *  @param url           下载地址
 *  @param progressBlock 回调下载进度
 *  @param stateBlock    下载状态
 */
- (void)downloadWithUrl:(NSString *)url progress:(SHDownloadProgressBlock)progressBlock state:(SHDownloadStateBlock)stateBlock;

/**
 *  查询该资源的下载进度值
 *
 *  @param url 下载地址
 *
 *  @return 返回下载进度值
 */
- (CGFloat)progress:(NSString *)url;

/**
 *  获取该资源总大小
 *
 *  @param url 下载地址
 *
 *  @return 资源总大小
 */
- (NSInteger)fileTotalLength:(NSString *)url;

/**
 *  判断该资源是否下载完成
 *
 *  @param url 下载地址
 *
 *  @return YES: 完成
 */
- (BOOL)isCompletion:(NSString *)url;

/**
 *  删除该资源
 *
 *  @param url 下载地址
 */
- (void)deleteFile:(NSString *)url;

/**
 *  清空所有下载资源
 */
- (void)deleteAllFile;

/**
 *  开始下载
 */
- (void)start:(NSString *)url;

/**
 *  暂停下载
 */
- (void)pause:(NSString *)url;

/**
 *  判断当前url是否正在下载
 *
 *  @param url   视频url
 *  @param block 下载进度
 *
 *  @return 是否在下载
 */
- (BOOL)isFileDownloadingForUrl:(NSString *)url withProgressBlock:(SHDownloadProgressBlock)block;

/**
 *  正在下载的视频URL的数组
 *
 *  @return 视频URL的数组
 */
- (NSArray *)currentDownloads;

@end
