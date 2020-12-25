//
//  SHTextTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHTextTableViewCell.h"

@interface SHTextTableViewCell ()

// text
@property (nonatomic, strong) SHTextView *textView;

@end

@implementation SHTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageFrame:(SHMessageFrame *)messageFrame{
    [super setMessageFrame:messageFrame];
    
    SHMessage *message = messageFrame.message;
    
    NSMutableAttributedString *str = (NSMutableAttributedString *)[SHEmotionTool getAttWithStr:message.text font:kChatFont_content];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str.length)];
    
    self.textView.attributedText = str;
    
    //设置frame
    CGFloat view_y = kChat_margin;
    if (kChatFont_content.lineHeight < kChat_min_h) {//为了使聊天内容与最小高度对齐
        view_y = (kChat_min_h - kChatFont_content.lineHeight)/2;
    }
    
    CGFloat margin = messageFrame.startX;
    self.textView.frame = CGRectMake(margin + kChat_margin, view_y, self.bubbleBtn.width - 2*kChat_margin - kChat_angle_w, self.bubbleBtn.height - 2*view_y);
}

#pragma mark 文本消息视图
- (SHTextView *)textView{
    //文本
    if (!_textView) {
        _textView = [[SHTextView alloc]init];
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.showsVerticalScrollIndicator = NO;
        [self.bubbleBtn addSubview:_textView];
    }
    return _textView;
}




@end
