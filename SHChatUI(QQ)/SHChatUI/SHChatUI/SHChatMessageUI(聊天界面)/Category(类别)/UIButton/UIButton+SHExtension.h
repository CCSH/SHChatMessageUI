//
//  UIButton+SHExtension.h
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target selector:(SEL)selector;

+ (UIButton *)buttonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(NSString*)image ImagePressed:(NSString *)imagePressed;

+ (UIButton *)buttonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(NSString*)image ImageSelected:(NSString *)imageSelected;

+ (UIButton *)buttonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(NSString*)image ImageSelected:(NSString *)imageSelected title:(NSString *)title;

+ (UIButton *)getLoginBtnWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector title:(NSString *)title;

@end
