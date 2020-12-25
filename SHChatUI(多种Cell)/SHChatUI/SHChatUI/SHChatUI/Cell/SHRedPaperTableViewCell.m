//
//  SHRedPaperTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHRedPaperTableViewCell.h"

@interface SHRedPaperTableViewCell ()

//红包图片
@property(nonatomic, strong) UIImageView *redPaperImage;
//红包内容
@property(nonatomic, strong) UILabel *redPaperContent;
//红包备注
@property(nonatomic, strong) UILabel *redPaperRemark;
//红包来源
@property(nonatomic, strong) UILabel *redPaperSource;

@end

@implementation SHRedPaperTableViewCell

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
    
    //设置内容
    self.redPaperContent.text = message.redPackage;
    self.redPaperRemark.text = @"打开红包";
    self.redPaperSource.text = @"    红包";
    self.redPaperSource.backgroundColor = [UIColor whiteColor];
    self.redPaperSource.textColor = [UIColor grayColor];
    UIColor *color = kRGB(250, 157, 59, 1);
    self.redPaperImage.image = [SHFileHelper imageNamed:@"chat_red"];
    if (message.isReceive) {
        color = kRGB(247, 226, 197, 1);
        self.redPaperRemark.text = @"已领取";
        self.redPaperSource.backgroundColor = [UIColor clearColor];
        self.redPaperSource.textColor = [UIColor whiteColor];
        self.redPaperImage.image = [SHFileHelper imageNamed:@"chat_red_receive"];
    }
    
    [self.bubbleBtn setBubbleColor:color];

    CGFloat margin = messageFrame.startX;
    //设置frame
    //图标
    self.redPaperImage.frame = CGRectMake(kChat_margin + margin, kChat_margin, 30, 40);
    //内容
    self.redPaperContent.frame = CGRectMake(self.redPaperImage.maxX + kChat_margin, self.redPaperImage.y,self.bubbleBtn.width - self.redPaperImage.maxX - 2*kChat_margin - kChat_angle_w,20);
    //提示
    self.redPaperRemark.frame = CGRectMake(self.redPaperContent.x, self.redPaperContent.maxY, self.redPaperContent.width, 20);
    //来源
    self.redPaperSource.frame = CGRectMake(margin?margin - 1:0, self.redPaperImage.maxY + kChat_margin, self.bubbleBtn.width - kChat_angle_w + 1, 20);

    //剪切
    [self.bubbleBtn makeMaskView];
}

#pragma mark 红包消息视图
- (UIImageView *)redPaperImage {
    //图片
    if (!_redPaperImage) {
        _redPaperImage = [[UIImageView alloc]init];
        _redPaperImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.bubbleBtn addSubview:_redPaperImage];
    }
    return _redPaperImage;
}

- (UILabel *)redPaperContent {
    //内容
    if (!_redPaperContent) {
        _redPaperContent = [[UILabel alloc]init];
        _redPaperContent.textColor = [UIColor whiteColor];
        _redPaperContent.font = [UIFont systemFontOfSize:14];
        [self.bubbleBtn addSubview:_redPaperContent];
    }
    return _redPaperContent;
}

- (UILabel *)redPaperRemark {
    //提示
    if (!_redPaperRemark) {
        _redPaperRemark = [[UILabel alloc]init];
        _redPaperRemark.textColor = [UIColor whiteColor];
        _redPaperRemark.font = [UIFont systemFontOfSize:12];
        [self.bubbleBtn addSubview:_redPaperRemark];
    }
    return _redPaperRemark;
}

- (UILabel *)redPaperSource {
    //来源
    if (!_redPaperSource) {
        _redPaperSource = [[UILabel alloc]init];
        _redPaperSource.backgroundColor = [UIColor whiteColor];
        _redPaperSource.textColor = [UIColor grayColor];
        _redPaperSource.font = [UIFont systemFontOfSize:10];
        _redPaperSource.textAlignment = NSTextAlignmentLeft;
        
        [self.bubbleBtn addSubview:_redPaperSource];
    }
    return _redPaperSource;
}

@end
