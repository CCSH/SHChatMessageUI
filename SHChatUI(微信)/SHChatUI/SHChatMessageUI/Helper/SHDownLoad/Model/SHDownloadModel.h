//
//  SHDownloadModel.h
//  断点续传之下载
//
//  Created by CSH on 16/6/6.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DownloadState){
    DownloadStateStart = 0,     /** 下载中 */
    DownloadStateSuspended,     /** 下载暂停 */
    DownloadStateCompleted,     /** 下载完成 */
    DownloadStateFailed         /** 下载失败 */
};

typedef void(^SHDownloadProgressBlock)(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize);
typedef void(^SHDownloadStateBlock)(DownloadState state);

@interface SHDownloadModel : NSObject <NSCoding>

/** 流 */
@property (nonatomic, strong) NSOutputStream *stream;

/** 下载地址 */
@property (nonatomic, copy) NSString *url;
/** 开始下载时间 */
@property (nonatomic, strong) NSDate *startTime;
/** 文件名 */
@property (nonatomic, copy) NSString *fileName;
/** 文件大小 */
@property (nonatomic, copy) NSString *totalSize;

/** 获得服务器这次请求 返回数据的总长度 */
@property (nonatomic, assign) NSInteger totalLength;

/** 下载进度 */
@property (atomic, copy) SHDownloadProgressBlock progressBlock;

/** 下载状态 */
@property (atomic, copy) SHDownloadStateBlock stateBlock;

- (float)calculateFileSizeInUnit:(unsigned long long)contentLength;

- (NSString *)calculateUnit:(unsigned long long)contentLength;

@end
