//
//  SHTextView.m
//  Test
//
//  Created by CSH on 2018/6/12.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHTextView.h"

@interface SHTextView()

@end

@implementation SHTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //配置
        [self setup];
    }
    return self;
}

#pragma mark - 配置
- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.textContainer.lineFragmentPadding = 0;
    self.textContainerInset = UIEdgeInsetsZero;
    self.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}
//
//#pragma mark 设置光标
//- (CGRect)caretRectForPosition:(UITextPosition *)position {
//    CGRect rect = [super caretRectForPosition:position];
//    CGFloat y = CGRectGetMidY(rect);
//    rect.size.height = self.font.lineHeight - 3;
//    rect.origin.y = y - 8;
//    return rect;
//}
//
- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset{
    CGFloat padding = self.textContainer.lineFragmentPadding;
    [super setTextContainerInset:UIEdgeInsetsMake(textContainerInset.top, textContainerInset.left - padding, textContainerInset.bottom, textContainerInset.right - padding)];
}

@end
