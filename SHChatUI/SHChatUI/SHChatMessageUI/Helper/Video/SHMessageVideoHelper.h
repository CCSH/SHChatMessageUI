//
//  SHMessageVideoHelper.h
//  SHChatMessageUI
//
//  Created by CSH on 16/8/9.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SHMessageVideoHelper : NSObject
/**
 *  获取视频截图
 *
 *  @param videoPath 路径
 *
 *  @return 截图
 */
+ (UIImage *)videoConverPhotoWithVideoPath:(NSString *)videoPath;

@end
