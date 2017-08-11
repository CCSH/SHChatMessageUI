//
//  SHVoiceRecordHelper.h
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SHVoiceRecordHelperDelegate <NSObject>
/**
 *  结束录音
 *
 *  @param wavPath        WAV路径
 *  @param amrPath        AMR路径
 *  @param recordDuration 音频长度
 */
- (void)voiceRecordFinishWithWavPath:(NSString *)wavPath AmrPath:(NSString *)amrPath RecordDuration:(NSString *)recordDuration;

/**
 *  没在规定时间内
 */
- (void)voiceRecordTimeWithRuleTime:(int)ruleTime;

@end


@interface SHVoiceRecordHelper : NSObject

//代理
@property (nonatomic, weak) id<SHVoiceRecordHelperDelegate> delegate;

- (id)initWithDelegate:(id<SHVoiceRecordHelperDelegate>)delegate;


/**
 *  开始录音
 */
- (void)startRecord;
/**
 *  停止录音
 */
- (void)stopRecord;
/**
 *  取消录音
 */
- (void)cancelRecord;

/**
 *  声音检测
 */
- (int)peekRecorderVoiceMeters;

@end
