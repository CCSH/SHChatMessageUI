//
//  SHAudioPlayerHelper.h
//  后台播放语音队列Demo
//
//  Created by CSH on 16/6/2.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/**
 *  语音播放帮助类
 */

@protocol SHAudioPlayerHelperDelegate <NSObject>

@optional

//开始播放
- (void)audioPlayerStartPlay:(NSString *)playMark;
//结束播放
- (void)audioPlayerEndPlay:(NSString *)playMark error:(NSError *)error;
//暂停播放
- (void)audioPlayerPausePlay:(NSString *)playMark;

@end

@interface SHAudioPlayerHelper : NSObject

//播放代理
@property (nonatomic, weak) id <SHAudioPlayerHelperDelegate> delegate;
//当前播放的标示
@property (nonatomic, copy) NSString *playMark;

/**
 *  实例化
 */
+ (id)shareInstance;

/**
 *  播放语音
 *
 *  @param fileArr 语音数组
 *  @param isClear 是否清除之前的播放列表
 */
- (void)managerAudioWithFileArr:(NSArray *)fileArr isClear:(BOOL)isClear;

/**
 *  前后台控制
 *
 *  @param isBackground 是否是后台
 */
- (void)backgroundPlayAudio:(BOOL)isBackground;

//暂停播放
- (void)pauseAudio;
//停止播放
- (void)stopAudio;
//开始播放
- (void)preparePlayAudio;

//是否正在播放
- (BOOL)isPlaying;

//销毁音频
- (void)deallocAudio;

@end
