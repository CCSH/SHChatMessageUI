//
//  UIButton+SHExtension.m
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "UIButton+SHExtension.h"
#import "SHPhotoHeader.h"

@implementation UIButton (Extension)

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target selector:(SEL)selector {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:BTNCOLOR forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imagePressed] forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(NSString*)image ImageSelected:(NSString *)imageSelected {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector Image:(NSString*)image ImageSelected:(NSString *)imageSelected title:(NSString *)title{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:BTNCOLOR forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)getLoginBtnWithFrame:(CGRect)frame Target:(id)target Selector:(SEL)selector title:(NSString *)title{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    button.layer.borderColor = [UIColor clearColor].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 5;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
