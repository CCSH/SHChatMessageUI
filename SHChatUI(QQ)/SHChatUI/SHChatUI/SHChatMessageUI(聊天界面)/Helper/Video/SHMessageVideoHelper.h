//
//  SHMessageVideoHelper.h
//  SHChatMessageUI
//
//  Created by CSH on 16/8/9.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//视频压缩成功的block回调
typedef void(^compressVideoSuccessBlock)(NSString *localVideoPath);

@interface SHMessageVideoHelper : NSObject

/**
 *  获取视频截图
 *
 *  @param videoPath 路径
 *
 *  @return 截图
 */
+ (UIImage *)videoConverPhotoWithVideoPath:(NSString *)videoPath;

/**
 获取视频的大小（返回的单位是kb）

 @param path 视频的路径
 @return kb
 */
+ (CGFloat)getVideoSize:(NSString *)path;

/**
 获取视频的时长

 @param url 视频的地址
 @return 时长
 */
+ (CGFloat)getVideoLength:(NSURL *)url;

//压缩视频
+ (void)compressVideoWithURL:(NSURL *)url compressVideoResultPath:(compressVideoSuccessBlock)block;

/**
 获取本地视频路径

 @param url 相册路径
 @return 本地视频路径
 */
+ (NSString *)getVideoLocalWithUrl:(NSURL *)url;

/**
 视频播放

 @param videoUrl 路径
 @param supVc 界面
 */
+ (void)playVideoWithVideoUrl:(NSURL *)videoUrl SupVc:(UIViewController *)supVc;

@end
