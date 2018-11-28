//
//  SHRedPaperTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHRedPaperTableViewCell.h"

@interface SHRedPaperTableViewCell ()

//红包
//红包背景
@property(nonatomic, retain) UIImageView *redPaperBg;
//红包图片
@property(nonatomic, retain) UIImageView *redPaperImage;
//红包内容
@property(nonatomic, retain) UILabel *redPaperContent;
//红包备注
@property(nonatomic, retain) UILabel *redPaperRemark;
//红包来源
@property(nonatomic, retain) UILabel *redPaperSource;

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
    
    self.redPaperContent.text = message.redPackage;
    self.redPaperRemark.text = @"打开红包";
    self.redPaperSource.text = @"    红包";

    //设置frame
    //背景
    self.redPaperBg.size = CGSizeMake(self.btnContent.width, self.btnContent.height);
    //图标
    self.redPaperImage.frame = CGRectMake(kChat_margin + (self.isSend?0:kChat_angle_w), kChat_margin, 30, 40);
    //内容
    self.redPaperContent.frame = CGRectMake(self.redPaperImage.maxX + kChat_margin, self.redPaperImage.y,self.width - self.redPaperImage.maxX - 2*kChat_margin - kChat_angle_w,20);
    //提示
    self.redPaperRemark.frame = CGRectMake(self.redPaperContent.x, self.redPaperContent.maxY, self.redPaperContent.width, 20);
    //来源
    self.redPaperSource.frame = CGRectMake((self.isSend?0:kChat_angle_w), self.redPaperImage.maxY + kChat_margin, self.btnContent.width - kChat_angle_w, 20);
    
    UIImage *image = nil;
    // 设置聊天气泡背景
    if (self.isSend) {
        image = [SHFileHelper imageNamed:@"chat_message_send@2x.png"];
    }else{
        image = [SHFileHelper imageNamed:@"chat_message_receive@2x.png"];
    }
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 25, 10, 25)];
    [self.btnContent setBackgroundImage:image forState:UIControlStateNormal];
    
    //编辑气泡
    [self.btnContent makeMaskView:self.redPaperBg image:image];
}

#pragma mark 红包消息视图
- (UIImageView *)redPaperBg {
    //背景
    if (!_redPaperBg) {
        _redPaperBg = [[UIImageView alloc]init];
        _redPaperBg.origin = CGPointMake(0, 0);
        _redPaperBg.backgroundColor = kRGB(250, 157, 59, 1);
        _redPaperBg.contentMode = UIViewContentModeScaleToFill;
        [self.btnContent addSubview:_redPaperBg];
    }
    return _redPaperBg;
}

- (UIImageView *)redPaperImage {
    //图片
    if (!_redPaperImage) {
        _redPaperImage = [[UIImageView alloc]init];
        _redPaperImage.image = [SHFileHelper imageNamed:@"redpackage.png"];
        _redPaperImage.contentMode = UIViewContentModeScaleToFill;
        [self.redPaperBg addSubview:_redPaperImage];
    }
    return _redPaperImage;
}

- (UILabel *)redPaperContent {
    //内容
    if (!_redPaperContent) {
        _redPaperContent = [[UILabel alloc]init];
        _redPaperContent.textColor = [UIColor whiteColor];
        _redPaperContent.font = [UIFont systemFontOfSize:14];
        [self.redPaperBg addSubview:_redPaperContent];
    }
    return _redPaperContent;
}

- (UILabel *)redPaperRemark {
    //提示
    if (!_redPaperRemark) {
        _redPaperRemark = [[UILabel alloc]init];
        _redPaperRemark.textColor = [UIColor whiteColor];
        _redPaperRemark.font = [UIFont systemFontOfSize:12];
        [self.redPaperBg addSubview:_redPaperRemark];
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
        [self.redPaperBg addSubview:_redPaperSource];
    }
    return _redPaperSource;
}

@end
