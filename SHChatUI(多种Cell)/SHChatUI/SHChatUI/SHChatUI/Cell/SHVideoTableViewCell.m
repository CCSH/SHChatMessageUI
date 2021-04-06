//
//  SHVideoTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHVideoTableViewCell.h"
#import "SHMessageHeader.h"

@interface SHVideoTableViewCell ()

//视频图标
@property (nonatomic, strong) UIImageView *iconView;
//视频时间
@property (nonatomic, strong) UILabel *timeLab;

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
    
    self.bubbleBtn.layer.cornerRadius = 5;
    self.bubbleBtn.layer.masksToBounds = YES;
    self.bubbleBtn.backgroundColor = [UIColor blackColor];
    [self.bubbleBtn setBubbleImage:nil];
    
    self.timeLab.text = message.videoDuration;
    
    //视频第一帧图片路径
    NSString *imagePath;
    
    //先看本地
    imagePath = [SHFileHelper getFilePathWithName:message.fileName type:SHMessageFileType_video_image];

    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (image) {//本地
        
        [self.bubbleBtn setBackgroundImage:image forState:0];
    }else{//网络
//        [self.bubbleBtn setImage:[SHFileHelper imageNamed:@"chat_picture"] forState:0];
        [self.bubbleBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:message.fileUrl] forState:0];
    }
    
    //设置frame
    self.iconView.center = CGPointMake(self.bubbleBtn.width/2, self.bubbleBtn.height/2);
    self.timeLab.width = self.bubbleBtn.width - 2*self.timeLab.x;
    self.timeLab.y = self.bubbleBtn.height - self.timeLab.height;
}

#pragma mark 视频消息视图
//视频图标
- (UIImageView *)iconView{
   
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.size = CGSizeMake(30, 30);
        _iconView.image = [SHFileHelper imageNamed:@"chat_video"];
        [self.bubbleBtn addSubview:_iconView];
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
        [self.bubbleBtn addSubview:_timeLab];
    }
    return _timeLab;
}

@end
