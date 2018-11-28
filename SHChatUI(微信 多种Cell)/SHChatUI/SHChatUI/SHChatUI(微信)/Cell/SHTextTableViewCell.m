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
@property (nonatomic, retain) SHTextView *textView;

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
    
    self.textView.frame = CGRectMake(kChat_margin + (self.isSend?0:kChat_angle_w), view_y, self.btnContent.width - (2*kChat_margin + kChat_angle_w), self.btnContent.height - 2*view_y);
    
    UIImage *image = nil;
    // 设置聊天气泡背景
    if (self.isSend) {
        image = [SHFileHelper imageNamed:@"chat_message_send@2x.png"];
    }else{
        image = [SHFileHelper imageNamed:@"chat_message_receive@2x.png"];
    }
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 25, 10, 25)];
    [self.btnContent setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark 文本消息视图
- (SHTextView *)textView{
    //文本
    if (!_textView) {
        _textView = [[SHTextView alloc]init];
        _textView.backgroundColor = [UIColor clearColor];
        [self.btnContent addSubview:_textView];
    }
    return _textView;
}


@end
