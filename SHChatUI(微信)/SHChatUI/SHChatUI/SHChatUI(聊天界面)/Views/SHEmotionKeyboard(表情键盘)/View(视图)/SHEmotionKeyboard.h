//
//  SHEmotionKeyboard.h
//  SHEmotionKeyboardUI
//
//  Created by CSH on 2016/12/7.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Emoji.h"
#import "SHEmotionModel.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@protocol SHEmotionKeyboardDelegate <NSObject>
@optional

/**
 表情键盘内容点击

 @param text 内容
 @param model 表情模型
 */
- (void)emoticonInputWithText:(NSString *)text Model:(SHEmotionModel *)model isSend:(BOOL)isSend;

/**
 表情键盘发送点击
 */
- (void)emoticonInputSend;

@end

@interface SHEmotionKeyboard : UIView

//代理
@property (nonatomic, weak) id<SHEmotionKeyboardDelegate> delegate;

//下方按钮集合(SHEmoticonType)
@property (nonatomic, strong) NSArray *toolBarArr;

- (void)reloadView;

@end
