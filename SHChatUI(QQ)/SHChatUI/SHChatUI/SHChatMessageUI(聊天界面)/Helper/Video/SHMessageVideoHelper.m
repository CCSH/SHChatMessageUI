//
//  SHMessageVideoHelper.m
//  SHChatMessageUI
//
//  Created by CSH on 16/8/9.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageVideoHelper.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVKit/AVKit.h>
#import "SHMessageMacroHeader.h"

@implementation SHMessageVideoHelper

+ (UIImage *)videoConverPhotoWithVideoPath:(NSString *)videoPath {
    
    if (!videoPath)
        return nil;
    AVURLAsset *asset;
    if ([videoPath hasPrefix:@"http"]) {//网络
        
        asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoPath] options:nil];
    }else{//本地
    
        asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    }

    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 1;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError ==== %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    CGImageRelease(thumbnailImageRef);
    
    if (thumbnailImage) {
        //图片写入本地
        NSData *data = [SHDataConversion imageToData:thumbnailImage CompressionNum:0.5];
        [data writeToFile:[SHFileHelper getVideoImageWithVideo:videoPath] atomically:NO];
    }
    
    return thumbnailImage;
}

//视频的时长
+ (CGFloat)getVideoLength:(NSURL *)url {
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:url];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}

//视频的大小
+ (CGFloat)getVideoSize:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float videoSize = -1.0;;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        videoSize = 1.0*size/1024;
    }else {
        NSLog(@"找不到文件");
    }
    return videoSize;
}

//压缩视频
+ (void)compressVideoWithURL:(NSURL *)url compressVideoResultPath:(compressVideoSuccessBlock)block {
    
    //没有压缩之前视频的大小
    NSLog(@"%@",[NSString stringWithFormat:@"%.2f kb",[SHMessageVideoHelper getVideoSize:[url path]]]);
    //视频的时长
    NSLog(@"%@",[NSString stringWithFormat:@"%f s",[SHMessageVideoHelper getVideoLength:url]]);

    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];

    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //创建视频本地路径
    NSString *localVideoUrl = [NSString stringWithFormat:@"%@.mp4",[SHMessageTimeHelper getTimeZoneMs]];
    NSString *localVideoPath = [NSString stringWithFormat:@"%@/%@",kSHVideoPath,localVideoUrl];
    exportSession.outputURL = [NSURL fileURLWithPath:localVideoPath];
    
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        NSLog(@"========%tu",exportSession.status);
        
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {//压缩完成
            
            
            NSLog(@"%@",[NSString stringWithFormat:@"%f s", [SHMessageVideoHelper getVideoLength:exportSession.outputURL]]);
            NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb",[SHMessageVideoHelper getVideoSize:localVideoPath]]);
            
            //压缩成功回调
            block(localVideoPath);
            
        }else {//压缩失败
            
            NSLog(@"压缩失败了呀");
        }
    }];
}

/**
 获取本地视频路径
 
 @param url 相册路径
 @return
 */
+ (NSString *)getVideoLocalWithUrl:(NSURL *)url{
    //创建视频本地路径
    NSString *videoName = [NSString stringWithFormat:@"%@.mp4",[SHMessageTimeHelper getTimeZoneMs]];
    NSString *videoPath = [NSString stringWithFormat:@"%@/%@",kSHVideoPath,videoName];

    //可以在此处进行再处理
    
    [[NSFileManager defaultManager] copyItemAtPath:[url path] toPath:videoPath error:nil];
    
    NSLog(@"2====%@",[NSString stringWithFormat:@"%.2f kb",[SHMessageVideoHelper getVideoSize:videoPath]]);
    return videoName;
}

#pragma mark 视频播放
+ (void)playVideoWithVideoUrl:(NSURL *)videoUrl SupVc:(UIViewController *)supVc{
    
    VideoPlayViewController *view = [[VideoPlayViewController alloc]init];
    view.videoURL = videoUrl;
    [supVc presentViewController:view animated:YES completion:nil];

//    //使用本地播放器播放
//    AVPlayer *player = [AVPlayer playerWithURL:videoUrl];
//    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
//    playerViewController.player = player;
//    [playerViewController.player play];
//    
//    playerViewController.navigationController.navigationBarHidden = YES;
//    
//    [supVc presentViewController:playerViewController animated:YES completion:nil];
}

@end
