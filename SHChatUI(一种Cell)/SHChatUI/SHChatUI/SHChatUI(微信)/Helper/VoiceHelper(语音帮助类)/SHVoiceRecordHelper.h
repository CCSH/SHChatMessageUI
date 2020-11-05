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
 *  @param voiceName    录音文件名字
 *  @param duration     音频长度
 */
- (void)voiceRecordFinishWithVoicename:(NSString *)voiceName duration:(NSString *)duration;

/**
 *  没在规定时间内
 */
- (void)voiceRecordTimeShort;

@end

@interface SHVoiceRecordHelper : NSObject

//代理
@property (nonatomic, weak) id<SHVoiceRecordHelperDelegate> delegate;

//出售啊
- (id)initWithDelegate:(id<SHVoiceRecordHelperDelegate>)delegate;

//开始录音
- (void)startRecord;

//停止录音
- (void)stopRecord;

//取消录音
- (void)cancelRecord;

//声音检测
- (int)peekRecorderVoiceMetersWithMax:(int)max;

@end
