//
//  SHCardTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHCardTableViewCell.h"

@interface SHCardTableViewCell ()

// card line
@property (nonatomic, retain) UIView *cardLine;
// card 头像
@property (nonatomic, retain) UIImageView *cardHead;
// card 姓名
@property (nonatomic, retain) UILabel *cardName;
// card 提示
@property (nonatomic, retain) UILabel *cardPrompt;

@end

@implementation SHCardTableViewCell

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
    
    self.cardPrompt.text = @"个人名片";
    self.cardName.text = message.card;
    self.cardHead.image = [UIImage imageNamed:@"headImage"];
    
    if (message.bubbleMessageType == SHBubbleMessageType_Send) {
        UIImage *image = [self.btnContent.currentBackgroundImage imageWithColor:[UIColor whiteColor]];
        [self setBubbleImage:image];
    }

    CGFloat margin = (message.bubbleMessageType == SHBubbleMessageType_Send) ? 0 : kChat_angle_w;
    //设置frame
    //头像
    self.cardHead.x = kChat_margin + margin;
    //名字
    self.cardName.frame = CGRectMake(self.cardHead.maxX + kChat_margin, self.cardHead.y, self.btnContent.width - self.cardHead.maxX - 2*kChat_margin - kChat_angle_w, self.cardHead.height);
    //分割线
    self.cardLine.frame = CGRectMake(margin + kChat_margin,self.cardHead.maxY + kChat_margin ,self.btnContent.width - kChat_angle_w - 2*kChat_margin, 0.5);
    //提示信息
    self.cardPrompt.frame = CGRectMake(margin + kChat_margin, self.cardLine.maxY - 0.5, self.btnContent.width - 2*kChat_margin - margin, 20);
    

}

#pragma mark 名片消息视图
- (UIImageView *)cardHead{
    //头像
    if (!_cardHead) {
        _cardHead = [[UIImageView alloc]init];
        _cardHead.frame = CGRectMake(0, kChat_margin, 40, 40);
        _cardHead.contentMode = UIViewContentModeScaleToFill;
        [self.btnContent addSubview:_cardHead];
    }
    return _cardHead;
}

- (UILabel *)cardName{
    //姓名
    if (!_cardName) {
        _cardName = [[UILabel alloc]init];
        _cardName.textColor = [UIColor blackColor];
        _cardName.numberOfLines = 0;
        _cardName.font = [UIFont systemFontOfSize:14];
        [self.btnContent addSubview:_cardName];
    }
    return _cardName;
}

- (UIView *)cardLine{
    //分割线
    if (!_cardLine) {
        _cardLine = [[UIView alloc]init];
        _cardLine.backgroundColor = kRGB(245, 245, 245, 1);
        [self.btnContent addSubview:_cardLine];
    }
    return _cardLine;
}

- (UILabel *)cardPrompt{
    //提示文字
    if (!_cardPrompt) {
        //提示文字
        _cardPrompt = [[UILabel alloc]init];
        _cardPrompt.textColor = [UIColor grayColor];
        _cardPrompt.font = [UIFont systemFontOfSize:10];
        _cardPrompt.textAlignment = NSTextAlignmentLeft;
        [self.btnContent addSubview:_cardPrompt];
    }
    return _cardPrompt;
}

@end
