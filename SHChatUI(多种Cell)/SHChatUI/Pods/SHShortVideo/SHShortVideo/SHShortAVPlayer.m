//
//  SHShortAVPlayer.m
//  SHShortVideoExmaple
//
//  Created by CSH on 2018/8/29.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHShortAVPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SHShortAVPlayer ()

//播放器对象
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation SHShortAVPlayer

- (void)dealloc {
    
    [self stop];
}

#pragma mark 播放完成
- (void)playFinished {
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

#pragma mark - 公共方法
#pragma mark 开始播放
- (void)play{
    
    //初始化
    self.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:self.videoUrl]];
    if (self.player.rate == 0) {
        [self.player play];
    }
    
    //创建播放器层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    playerLayer.frame = self.frame;
    [self.layer addSublayer:playerLayer];
    
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

#pragma mark 结束播放
- (void)stop{
    if (self.player.rate == 1) {
        [self.player pause];//如果在播放状态就停止
    }
    self.player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
