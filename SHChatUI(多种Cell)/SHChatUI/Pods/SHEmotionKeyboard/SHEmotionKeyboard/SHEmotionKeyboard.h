//
//  SHEmotionKeyboard.h
//  SHEmotionKeyboard
//
//  Created by CSH on 2016/12/7.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHEmotionModel.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define SafeBottomH (([UIApplication sharedApplication].statusBarFrame.size.height != 20) ? 34 : 0)
//键盘高度
#define kKeyboardH 216
//下方工具栏按钮宽度
#define kToolBtnW 80
//页面控制高度
#define kPageControlH 30

@interface SHEmotionKeyboard : UIView

//下方按钮集合(SHEmoticonType)
@property (nonatomic, strong) NSArray *toolBarArr;
//位置(默认是第一个，使用前设置在reloadView之后)
@property (nonatomic, assign) SHEmoticonType index;
//点击回调
@property (nonatomic, copy) void (^clickEmotionBlock)(SHEmotionModel *model);
//发送回调
@property (nonatomic, copy) void (^sendEmotionBlock)(void);
//删除回调
@property (nonatomic, copy) void (^deleteEmotionBlock)(void);

- (void)reloadView;

@end
