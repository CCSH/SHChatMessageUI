//
//  SHBubbleButton.h
//  SHChatUI
//
//  Created by CCSH on 2020/12/24.
//  Copyright © 2020 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//聊天气泡
@interface SHBubbleButton : UIButton

#pragma mark 剪切视图
- (void)makeMaskView;

#pragma mark 设置气泡背景图片
- (void)setBubbleImage:(nullable UIImage *)image;

#pragma mark 设置气泡背景图片颜色
- (void)setBubbleColor:(nullable UIColor *)color;

@end

NS_ASSUME_NONNULL_END
