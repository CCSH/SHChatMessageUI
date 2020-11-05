//
//  SHAudioRecordHelper.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHAudioRecordHelper.h"
#import "SHMessageHeader.h"

@interface SHAudioRecordHelper ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
//路径
@property (nonatomic, copy) NSString *path;

@end

@implementation SHAudioRecordHelper

#pragma mark - 设置代理
- (id)initWithDelegate:(id<SHAudioRecordHelperDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - 开始录音
- (void)startRecord{

    // 录音文件名字
    self.path = [SHFileHelper getFilePathWithName:nil type:SHMessageFileType_wav];
    //配置录音
    [self setRecorder];
    //开始录音
    [_recorder record];
}

#pragma mark - 停止录音
- (void)stopRecord
{
    //录制时间
    int recorderTime = (int)roundf(_recorder.currentTime);

    //停止录音
    [_recorder stop];

    //发送音频
    if ([_delegate respondsToSelector:@selector(audioFinishWithPath:duration:)])
    {
        //在规定时长内
        if (recorderTime >= kSHMinRecordTime)
        {
            [_delegate audioFinishWithPath:self.path duration:recorderTime];
        }
        else
        {
            //时间太短
            [_recorder deleteRecording];
            [_delegate audioFinishWithPath:nil duration:recorderTime];
        }
    }
}

#pragma mark - 取消录音
- (void)cancelRecord {
    [_recorder stop];
    [_recorder deleteRecording];
}

#pragma mark - 录音配置
- (void)setRecorder{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&setCategoryError];
    
    //获取配置
    NSDictionary *settings = [SHFileHelper getAudioRecorderSettingDict];
    //设置路径
    NSURL *url = [NSURL fileURLWithPath:self.path];

    _recorder = nil;
    _recorder =  [[AVAudioRecorder alloc] initWithURL:url settings:settings error:nil];
    _recorder.delegate = self;
    
    //开启声波检测
    _recorder.meteringEnabled = YES;

    [_recorder prepareToRecord];
}

#pragma mark - 声音检测
- (int)peekRecorderVoiceMetersWithMax:(int)max {
    [_recorder updateMeters];
   
    float peakPower = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    
    if (peakPower > 0.6) {
        peakPower = 0.6;
    }
    
    int power = max*peakPower/0.6;
    
    return power;
}

@end
