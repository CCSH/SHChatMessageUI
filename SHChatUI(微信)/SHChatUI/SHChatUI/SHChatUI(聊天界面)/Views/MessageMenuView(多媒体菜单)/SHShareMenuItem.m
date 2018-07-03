//
//  SHShareMenuItem.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHShareMenuItem.h"

@implementation SHShareMenuItem

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title {
    self = [super init];
    return [self initWithIcon:icon title:title titleColor:nil titleFont:nil];
}

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont{
    self = [super init];
    if (self) {
        self.icon = icon;
        self.title = title;
        self.titleColor = titleColor;
        self.titleFont = titleFont;
    }
    return self;
}

@end
