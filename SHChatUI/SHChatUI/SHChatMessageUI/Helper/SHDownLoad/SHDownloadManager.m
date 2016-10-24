//
//  SHDownloadManager.m
//  断点续传之下载
//
//  Created by CSH on 16/6/6.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHDownloadManager.h"

@interface SHDownloadManager()<NSCopying, NSURLSessionDelegate>

/** 保存所有任务(注：用下载地址/后作为key) */
@property (nonatomic, strong) NSMutableDictionary *tasks;
/** 保存所有下载相关信息字典 */
@property (nonatomic, strong) NSMutableDictionary *sessionModels;
/** 所有本地存储的所有下载信息数据数组 */
@property (nonatomic, strong) NSMutableArray *sessionModelsArray;
/** 下载完成的模型数组*/
@property (nonatomic, strong) NSMutableArray *downloadedArray;
/** 下载中的模型数组*/
@property (nonatomic, strong) NSMutableArray *downloadingArray;


@end

@implementation SHDownloadManager

- (NSMutableDictionary *)tasks
{
    if (!_tasks) {
        _tasks = [NSMutableDictionary dictionary];
    }
    return _tasks;
}

- (NSMutableDictionary *)sessionModels
{
    if (!_sessionModels) {
        _sessionModels = @{}.mutableCopy;
    }
    return _sessionModels;
}


- (NSMutableArray *)sessionModelsArray
{
    if (!_sessionModelsArray) {
        _sessionModelsArray = @[].mutableCopy;
        [_sessionModelsArray addObjectsFromArray:[self getSessionModels]];
    }
    return _sessionModelsArray;
}

- (NSMutableArray *)downloadingArray
{
    if (!_downloadingArray) {
        _downloadingArray = @[].mutableCopy;
        for (SHDownloadModel *obj in self.sessionModelsArray) {
            if (![self isCompletion:obj.url]) {
                [_downloadingArray addObject:obj];
            }
        }
    }
    return _downloadingArray;
}

- (NSMutableArray *)downloadedArray
{
    if (!_downloadedArray) {
        _downloadedArray = @[].mutableCopy;
        for (SHDownloadModel *obj in self.sessionModelsArray) {
            if ([self isCompletion:obj.url]) {
                [_downloadedArray addObject:obj];
            }
        }
    }
    return _downloadedArray;
}

static SHDownloadManager *_downloadManager;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _downloadManager = [super allocWithZone:zone];
    });
    
    return _downloadManager;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return _downloadManager;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadManager = [[self alloc] init];
    });
    
    return _downloadManager;
}

/**
 * 归档
 */
- (void)save:(NSArray *)sessionModels
{
    [NSKeyedArchiver archiveRootObject:sessionModels toFile:SHDownloadDetailPath];
}

/**
 * 读取model
 */
- (NSArray *)getSessionModels
{
    // 文件信息
    NSArray *sessionModels = [NSKeyedUnarchiver unarchiveObjectWithFile:SHDownloadDetailPath];
    return sessionModels;
}


/**
 *  创建缓存目录文件
 */
- (void)createCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:SHCachesDirectory]) {
        [fileManager createDirectoryAtPath:SHCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

/**
 *  开启任务下载资源
 */
- (void)downloadWithUrl:(NSString *)url progress:(SHDownloadProgressBlock)progressBlock state:(SHDownloadStateBlock)stateBlock
{
    if (!url) return;
    if ([self isCompletion:url]) {
        stateBlock(DownloadStateCompleted);
        NSLog(@"资源已下载完成：%@",url);
        return;
    }
    
    // 暂停
    if ([self.tasks valueForKey:SHFileName(url)]) {
        [self handle:url];
        return;
    }
    
    // 创建缓存目录文件
    [self createCacheDirectory];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    // 创建流
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:SHFileFullpath(url) append:YES];
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // 设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", SHDownloadLength(url)];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    // 创建一个Data任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    NSUInteger taskIdentifier = arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
    [task setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];
    // 保存任务
    [self.tasks setValue:task forKey:SHFileName(url)];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:SHFileFullpath(url)]) {
        SHDownloadModel *sessionModel = [[SHDownloadModel alloc] init];
        sessionModel.url = url;
        sessionModel.progressBlock = progressBlock;
        sessionModel.stateBlock = stateBlock;
        sessionModel.stream = stream;
        sessionModel.startTime = [NSDate date];
        sessionModel.fileName = SHFileName(url);
        [self.sessionModels setValue:sessionModel forKey:@(task.taskIdentifier).stringValue];
        [self.sessionModelsArray addObject:sessionModel];
        [self.downloadingArray addObject:sessionModel];
        // 保存
        [self save:self.sessionModelsArray];
    }else {
        for (SHDownloadModel *sessionModel in self.sessionModelsArray) {
            if ([sessionModel.url isEqualToString:url]) {
                sessionModel.url = url;
                sessionModel.progressBlock = progressBlock;
                sessionModel.stateBlock = stateBlock;
                sessionModel.stream = stream;
                sessionModel.startTime = [NSDate date];
                sessionModel.fileName = SHFileName(url);
                [self.sessionModels setValue:sessionModel forKey:@(task.taskIdentifier).stringValue];
            }
        }
    }
    [self start:url];
}


- (void)handle:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    if (task.state == NSURLSessionTaskStateRunning) {
        [self pause:url];
    } else {
        [self start:url];
    }
}

/**
 *  开始下载
 */
- (void)start:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    [task resume];
    
    [self getSessionModel:task.taskIdentifier].stateBlock(DownloadStateStart);
}

/**
 *  暂停下载
 */
- (void)pause:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    [task suspend];
    
    [self getSessionModel:task.taskIdentifier].stateBlock(DownloadStateSuspended);
}

/**
 *  根据url获得对应的下载任务
 */
- (NSURLSessionDataTask *)getTask:(NSString *)url
{
    return (NSURLSessionDataTask *)[self.tasks valueForKey:SHFileName(url)];
}

/**
 *  根据url获取对应的下载信息模型
 */
- (SHDownloadModel *)getSessionModel:(NSUInteger)taskIdentifier
{
    return (SHDownloadModel *)[self.sessionModels valueForKey:@(taskIdentifier).stringValue];
}

/**
 *  判断该文件是否下载完成
 */
- (BOOL)isCompletion:(NSString *)url
{
    if ([self fileTotalLength:url] && SHDownloadLength(url) == [self fileTotalLength:url]) {
        return YES;
    }
    return NO;
}

/**
 *  查询该资源的下载进度值
 */
- (CGFloat)progress:(NSString *)url
{
    return [self fileTotalLength:url] == 0 ? 0.0 : 1.0 * SHDownloadLength(url) /  [self fileTotalLength:url];
}

/**
 *  获取该资源总大小
 */
- (NSInteger)fileTotalLength:(NSString *)url
{
    for (SHDownloadModel *model in self.sessionModelsArray) {
        if ([model.url isEqualToString:url]) {
            return model.totalLength;
        }
    }
    return 0;
}

#pragma mark - 删除
/**
 *  删除该资源
 */
- (void)deleteFile:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    if (task) {
        // 取消下载
        [task cancel];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:SHFileFullpath(url)]) {
        // 删除沙盒中的资源
        [fileManager removeItemAtPath:SHFileFullpath(url) error:nil];
        // 删除资源总长度
        if ([fileManager fileExistsAtPath:SHDownloadDetailPath]) {
            // 从沙盒中移除该条模型的信息
            for (SHDownloadModel *model in self.sessionModelsArray.mutableCopy) {
                if ([model.url isEqualToString:url]) {
                    // 关闭流
                    [model.stream close];
                    [self.sessionModelsArray removeObject:model];
                }
            }
        }
        // 删除任务
        [self.tasks removeObjectForKey:SHFileName(url)];
        [self.sessionModels removeObjectForKey:@([self getTask:url].taskIdentifier).stringValue];
        // 保存归档信息
        [self save:self.sessionModelsArray];
    }
}

/**
 *  清空所有下载资源
 */
- (void)deleteAllFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:SHCachesDirectory]) {
        
        // 删除沙盒中所有资源
        [fileManager removeItemAtPath:SHCachesDirectory error:nil];
        // 删除任务
        [[self.tasks allValues] makeObjectsPerformSelector:@selector(cancel)];
        [self.tasks removeAllObjects];
        
        for (SHDownloadModel *sessionModel in [self.sessionModels allValues]) {
            [sessionModel.stream close];
        }
        [self.sessionModels removeAllObjects];
        
        // 删除资源总长度
        if ([fileManager fileExistsAtPath:SHDownloadDetailPath]) {
            [fileManager removeItemAtPath:SHDownloadDetailPath error:nil];
            [self.sessionModelsArray removeAllObjects];
            self.sessionModelsArray = nil;
            [self.downloadedArray removeAllObjects];
            [self.downloadingArray removeAllObjects];
        }
    }
}

- (BOOL)isFileDownloadingForUrl:(NSString *)url withProgressBlock:(SHDownloadProgressBlock)progressBlock
{
    BOOL retValue = NO;
    NSURLSessionDataTask *task = [self getTask:url];
    SHDownloadModel *session = [self getSessionModel:task.taskIdentifier];
    if (session) {
        if (progressBlock) {
            session.progressBlock = progressBlock;
        }
        retValue = YES;
    }
    return retValue;
}

- (NSArray *)currentDownloads {
    NSMutableArray *currentDownloads = [NSMutableArray new];
    [self.sessionModels enumerateKeysAndObjectsUsingBlock:^(id key, SHDownloadModel *download, BOOL *stop) {
        [currentDownloads addObject:download.url];
    }];
    return currentDownloads;
}

#pragma mark NSURLSessionDataDelegate

/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    SHDownloadModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 打开流
    [sessionModel.stream open];
    
    // 获得服务器这次请求 返回数据的总长度
    NSInteger totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + SHDownloadLength(sessionModel.url);
    sessionModel.totalLength = totalLength;
    
    // 总文件大小
    NSString *fileSizeInUnits = [NSString stringWithFormat:@"%.2f %@",
                                 [sessionModel calculateFileSizeInUnit:(unsigned long long)totalLength],
                                 [sessionModel calculateUnit:(unsigned long long)totalLength]];
    sessionModel.totalSize = fileSizeInUnits;
    // 更新数据(文件总长度)
    [self save:self.sessionModelsArray];
    
    // 添加下载中数组
    if (![self.downloadingArray containsObject:sessionModel]) {
        [self.downloadingArray addObject:sessionModel];
    }
    
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    SHDownloadModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 写入数据
    [sessionModel.stream write:data.bytes maxLength:data.length];
    
    // 下载进度
    NSUInteger receivedSize = SHDownloadLength(sessionModel.url);
    NSUInteger expectedSize = sessionModel.totalLength;
    CGFloat progress = 1.0 * receivedSize / expectedSize;
    
    // 每秒下载速度
    NSTimeInterval downloadTime = -1 * [sessionModel.startTime timeIntervalSinceNow];
    NSUInteger speed = receivedSize / downloadTime;
    if (speed == 0) { return; }
    float speedSec = [sessionModel calculateFileSizeInUnit:(unsigned long long) speed];
    NSString *unit = [sessionModel calculateUnit:(unsigned long long) speed];
    NSString *speedStr = [NSString stringWithFormat:@"%.2f%@/s",speedSec,unit];
    
    // 剩余下载时间
    NSMutableString *remainingTimeStr = [[NSMutableString alloc] init];
    unsigned long long remainingContentLength = expectedSize - receivedSize;
    int remainingTime = (int)(remainingContentLength / speed);
    int hours = remainingTime / 3600;
    int minutes = (remainingTime - hours * 3600) / 60;
    int seconds = remainingTime - hours * 3600 - minutes * 60;
    
    if(hours>0) {[remainingTimeStr appendFormat:@"%d 小时 ",hours];}
    if(minutes>0) {[remainingTimeStr appendFormat:@"%d 分 ",minutes];}
    if(seconds>0) {[remainingTimeStr appendFormat:@"%d 秒",seconds];}
    
    NSString *writtenSize = [NSString stringWithFormat:@"%.2f %@",
                             [sessionModel calculateFileSizeInUnit:(unsigned long long)receivedSize],
                             [sessionModel calculateUnit:(unsigned long long)receivedSize]];
    
    if (sessionModel.stateBlock) {
        sessionModel.stateBlock(DownloadStateStart);
    }
    if (sessionModel.progressBlock) {
        sessionModel.progressBlock(progress, speedStr, remainingTimeStr,writtenSize, sessionModel.totalSize);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(downloadResponse:)]) {
            [self.delegate downloadResponse:sessionModel];
        }
    });
}

/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    SHDownloadModel *sessionModel = [self getSessionModel:task.taskIdentifier];
    if (!sessionModel) return;
    
    // 关闭流
    [sessionModel.stream close];
    sessionModel.stream = nil;
    
    if ([self isCompletion:sessionModel.url]) {
        // 下载完成
        sessionModel.stateBlock(DownloadStateCompleted);
    } else if (error){
        // 下载失败
        sessionModel.stateBlock(DownloadStateFailed);
    }
    // 清除任务
    [self.tasks removeObjectForKey:SHFileName(sessionModel.url)];
    [self.sessionModels removeObjectForKey:@(task.taskIdentifier).stringValue];
    
    [self.downloadingArray removeObject:sessionModel];
    
    // 清除任务
    [self.tasks removeObjectForKey:SHFileName(sessionModel.url)];
    [self.sessionModels removeObjectForKey:@(task.taskIdentifier).stringValue];
    
    [self.downloadingArray removeObject:sessionModel];
    
    if (error.code == -999)    return;   // cancel
    
    if (![self.downloadedArray containsObject:sessionModel]) {
        [self.downloadedArray addObject:sessionModel];
    }
}
@end
