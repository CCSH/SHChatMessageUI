//
//  SHAudioPlayerHelper.m
//  后台播放语音队列Demo
//
//  Created by CSH on 16/6/2.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHAudioPlayerHelper.h"
#import "SHMessageHeader.h"

@interface SHAudioPlayerHelper () < AVAudioPlayerDelegate >

//播放器
@property (nonatomic, strong) AVAudioPlayer *player;
//播放的语音位置
@property (nonatomic, assign) int playingIndex;
//播放的语音数组
@property (nonatomic, copy) NSArray <SHMessage *>*audioArr;
//定时器
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SHAudioPlayerHelper

#pragma mark - 实例化
+ (instancetype)shareInstance
{
    static SHAudioPlayerHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SHAudioPlayerHelper alloc] init];
    });
    return instance;
}

#pragma mark - 设置代理
- (void)setDelegate:(id< SHAudioPlayerHelperDelegate >)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
        
        if (_delegate == nil)
        {
            [self stopAudio];
        }
    }
}

#pragma mark - 初始化各个参数
- (void)managerAudioWithFileArr:(NSArray *)fileArr isClear:(BOOL)isClear
{
    if (!fileArr.count)
    {
        return;
    }
    
    self.playMark = nil;
    
    if (isClear)
    {
        //清除之前的队列
        if (_player)
        { //如果有播放那就停止
            [self stopAudio];
        }
        _playingIndex = 0;
        _player = nil;
        self.audioArr = [NSArray arrayWithArray:fileArr];
        [self preparePlayAudio];
    }
    else
    {
        //不清除之前的队列，做添加
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        if (self.audioArr.count)
        {
            [arr addObjectsFromArray:self.audioArr];
        }
        
        [arr addObjectsFromArray:fileArr];
        
        self.audioArr = [NSArray arrayWithArray:arr];
        
        if (!_player && !_player.isPlaying)
        { //如果没有播放那么开始播放
            
            [self preparePlayAudio];
        }
    }
    
    //添加通知，切换播放源后暂停播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
}

#pragma mark - pause
#pragma mark 暂停播放语音
- (void)pauseAudio
{
    if (_player)
    {
        [_player pause];
        if ([self.delegate respondsToSelector:@selector(audioPlayerPausePlay:)])
        {
            [self.delegate audioPlayerPausePlay:self.playMark];
        }
    }
}
#pragma mark - stop
#pragma mark 停止播放语音
- (void)stopAudio
{
    if (_player && _player.isPlaying)
    {
        [_player stop];
    }
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    if ([self.delegate respondsToSelector:@selector(audioPlayerEndPlay:error:)])
    {
        [self.delegate audioPlayerEndPlay:self.playMark error:nil];
    }
    _player = nil;
    self.playMark = nil;
}

#pragma mark - play
#pragma mark 准备开始播放语音
- (void)preparePlayAudio
{
    NSString *fileName = [self getAudioFileName];
    
    if (fileName.length > 0)
    {
        //不随着静音键和屏幕关闭而静音
        //设置锁屏仍能继续播放
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        //暂停功能
        //        if (self.playingName && [audioPath isEqualToString:self.playingName]) {//上次播放的录音
        //            self.playingName = audioPath;
        //            if (_player) {
        //                [_player play];
        //                [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        //                if ([self.delegate respondsToSelector:@selector(didAudioPlayerBeginPlay:)]) {
        //                    [self.delegate didAudioPlayerBeginPlay:audioPath];
        //                }
        //            }
        //        } else {//不是上次播放的录音
        
        if (_player)
        {
            [_player stop];
            self.player = nil;
        }
        
        NSLog(@"语音文件名：%@", fileName);
        
        //拼接WAV文件路径
        NSString *wavfile = [SHFileHelper getFilePathWithName:fileName type:SHMessageFileType_wav];
        //获取AMR文件路径
        NSString *amrFile = [SHFileHelper getFilePathWithName:fileName type:SHMessageFileType_amr];
        
        //判断本地是否存在AMR
        if (![[NSFileManager defaultManager] fileExistsAtPath:amrFile])
        {
            //下载amr
            //                SHMessage *message = self.audioArr[_playingIndex - 1];
            //                message.fileUrl
        }
        //判断本地是否存在WAV
        if (![[NSFileManager defaultManager] fileExistsAtPath:wavfile])
        {
            //不存在此条语音进行转换 AMR ——> WAV
            [VoiceConverter amrToWav:amrFile wavSavePath:wavfile];
        }
        //开始播放
        [self startPlayAudioWithWavFile:wavfile];
        //        }
    }
    else
    {
        if (_playingIndex >= _audioArr.count)
        {
            NSLog(@"队列中没有播放文件了");
            _playingIndex = -1;
        }
        [self stopAudio];
    }
}

#pragma mark 开始播放语音
- (void)startPlayAudioWithWavFile:(NSString *)wavFile
{
    SHMessage *message = self.audioArr[_playingIndex];
    self.playMark = message.messageId;
    
    //开启距离感应
    [self changeProximityMonitorEnableState:YES];
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:wavFile];
    AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithData:data error:&error];
    
    play.delegate = self;
    [play play];
    
    //播放开始回调
    if ([self.delegate respondsToSelector:@selector(audioPlayerStartPlay:)])
    {
        [self.delegate audioPlayerStartPlay:self.playMark];
    }
    
    self.player = play;
    
    if (!_player)
    {
        //播放错误
        if ([self.delegate respondsToSelector:@selector(audioPlayerEndPlay:error:)])
        {
            [self.delegate audioPlayerEndPlay:self.playMark error:error];
        }
        //播放下一条
        [self playNext];
    }
}

#pragma mark - 后台控制（为了后台播放）
- (void)backgroundPlayAudio:(BOOL)isBackground
{
    if (isBackground)
    {
        //让app支持接受远程控制事件
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self timeStart];
    }
    else
    {
        [self timeStop];
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setActive:YES error:nil];
    
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

#pragma mark 开始查找
- (void)timeStart
{
    if (!self.timer)
    {
        NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(isPlayAudio) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
        self.timer = time;
    }
}
#pragma mark 停止查找
- (void)timeStop
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark 是否存在播放
- (void)isPlayAudio
{
    if (_player)
    {
        [_player play];
    }
}

#pragma mark - 是否正在播放
- (BOOL)isPlaying
{
    if (!_player)
    {
        return NO;
    }
    return _player.isPlaying;
}

#pragma mark - 获取播放路径
- (NSString *)getAudioFileName
{
    if (self.audioArr.count > _playingIndex && _playingIndex != -1)
    {
        SHMessage *message = self.audioArr[_playingIndex];
        
        if (message.fileName.length)
        {
            return message.fileName;
        }
        else
        {
            return message.fileUrl;
        }
    }
    _playingIndex = -1;
    return @"";
}

#pragma mark - 销毁音频
- (void)deallocAudio
{
    self.playingIndex = 0;
    self.audioArr = nil;
    self.playMark = nil;
    self.player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //关闭距离感应
    [self changeProximityMonitorEnableState:NO];
}

#pragma mark - AVAudioPlayerDelegate
#pragma mark 语音播放完毕
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //关闭距离感应
    [self changeProximityMonitorEnableState:NO];
    
    [self stopAudio];
    
    [self playNext];
}

#pragma mark - 播放下一个
- (void)playNext
{
    _playingIndex++;
    //播放
    [self preparePlayAudio];
}

#pragma mark - 近距离传感器
- (void)changeProximityMonitorEnableState:(BOOL)enable
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:enable];
    
    if (enable)
    {
        //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    else
    {
        //删除近距离事件监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
}

- (void)sensorStateChange:(NSNotificationCenter *)notification
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        //用户接近屏幕
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        //用户没有接近屏幕
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (!_player || !_player.isPlaying)
        {
            //没有播放了，也没有在黑屏状态下，就可以把距离传感器关了
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}

#pragma mark - 一旦输出改变则执行此方法
- (void)routeChange:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    int changeReason = [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable)
    {
        AVAudioSessionRouteDescription *routeDescription = dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription = [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"])
        {
            //停止
            [self stopAudio];
        }
    }
}

@end
