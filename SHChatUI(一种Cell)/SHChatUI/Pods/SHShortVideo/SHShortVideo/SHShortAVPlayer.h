//
//  SHShortAVPlayer.h
//  SHShortVideoExmaple
//
//  Created by CSH on 2018/8/29.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 视频预览View
 */
@interface SHShortAVPlayer : UIView

//视频url
@property (copy, nonatomic) NSURL *videoUrl;

//开始播放
- (void)play;
//结束播放
- (void)stop;

@end
