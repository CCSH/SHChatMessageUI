//
//  SHVideoTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHVideoTableViewCell.h"

@interface SHVideoTableViewCell ()

//视频图标
@property (nonatomic, retain) UIImageView *iconView;
//视频时间
@property (nonatomic, retain) UILabel *timeLab;

@end

@implementation SHVideoTableViewCell

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
    
    self.btnContent.layer.cornerRadius = 5;
    self.btnContent.layer.masksToBounds = YES;
    self.btnContent.backgroundColor = [UIColor blackColor];
    [self setBubbleImage:nil];
    
    self.timeLab.text = message.videoDuration;
    
    //视频第一帧图片路径
    NSString *imagePath;
    
    //先看本地
    imagePath = [SHFileHelper getFilePathWithName:message.fileName type:SHMessageFileType_video_image];

    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (image) {//本地
        
        [self.btnContent setBackgroundImage:image forState:0];
    }else{//网络
        
//        [self.btnContent sd_setBackgroundImageWithURL:[NSURL URLWithString:message.fileUrl] forState:0];
    }
    
    //设置frame
    self.iconView.center = CGPointMake(self.btnContent.width/2, self.btnContent.height/2);
    self.timeLab.width = self.btnContent.width - 2*self.timeLab.x;
    self.timeLab.y = self.btnContent.height - self.timeLab.height;

}

#pragma mark 视频消息视图
//视频图标
- (UIImageView *)iconView{
   
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.size = CGSizeMake(30, 30);
        _iconView.image = [SHFileHelper imageNamed:@"chat_video"];
        [self.btnContent addSubview:_iconView];
    }
    return _iconView;
}

//视频时间
- (UILabel *)timeLab{
   
    if (!_timeLab) {
      
        _timeLab = [[UILabel alloc]init];
        _timeLab.x = 5;
        _timeLab.height = 20;
        _timeLab.font = [UIFont systemFontOfSize:10];
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.textAlignment = NSTextAlignmentRight;
        [self.btnContent addSubview:_timeLab];
    }
    return _timeLab;
}

@end
