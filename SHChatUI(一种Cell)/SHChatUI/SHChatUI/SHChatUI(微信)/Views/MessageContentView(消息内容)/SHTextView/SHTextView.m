//
//  SHTextView.m
//  Test
//
//  Created by CSH on 2018/6/12.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHTextView.h"

@interface SHTextView()<UITextViewDelegate>

@end

@implementation SHTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        //配置
        [self setup];
    }
    return self;
}

#pragma mark - 配置
- (void)setup{
    
    CGFloat padding = self.textContainer.lineFragmentPadding;
    
    self.editable = NO;
    self.scrollEnabled = NO;
    self.textContainerInset = UIEdgeInsetsMake(0, -padding, 0, -padding);
    self.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink;
    self.delegate = self;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(nonnull NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    return YES;
}

@end
