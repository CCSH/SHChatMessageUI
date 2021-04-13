//
//  SHAudioTableViewCell.h
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHMessageTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 语音消息Cell
 */
@interface SHAudioTableViewCell : SHMessageTableViewCell

//播放语音动画
- (void)playVoiceAnimation;
//停止语音动画
- (void)stopVoiceAnimation;

@end

NS_ASSUME_NONNULL_END
