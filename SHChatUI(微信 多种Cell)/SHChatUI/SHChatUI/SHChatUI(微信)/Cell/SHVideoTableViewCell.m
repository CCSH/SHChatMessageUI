//
//  SHVideoTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHVideoTableViewCell.h"

@interface SHVideoTableViewCell ()

// video
// video 图标
@property (nonatomic, retain) UIImageView *videoIconView;

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
    
    //视频第一帧图片路径
    NSString *videoImagePath;
    
    //先看本地
    if (message.videoName.length) {
        videoImagePath = [SHFileHelper getFilePathWithName:message.videoName type:SHMessageFileType_video_image];
    }
    
    //再看网络
    if (!videoImagePath.length) {
        videoImagePath = [SHFileHelper getFilePathWithName:message.videoUrl type:SHMessageFileType_video_image];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoImagePath]) {//本地
        
        [self.btnContent setBackgroundImage:[UIImage imageWithContentsOfFile:videoImagePath] forState:0];
    }else{//网络
        
        //异步获取
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            //视频第一帧图片路径
            NSString *videoPath;
            if (message.videoName.length) {
                videoPath = [SHFileHelper getFilePathWithName:message.videoName type:SHMessageFileType_video];
            }
            
            if (!videoPath.length) {
                videoPath = message.videoUrl;
            }
            
            //把第一帧图片保存到本地中
            NSString *imagePath = [SHFileHelper getFilePathWithName:[SHFileHelper getFileNameWithContent:videoPath type:SHMessageFileType_video_image] type:SHMessageFileType_video_image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {//获取到第一帧图片
                    
                    [self.btnContent setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:0];
                }
            });
        });
    }
    
    //设置frame
    self.videoIconView.origin = CGPointMake((self.width - self.videoIconView.width)/2, (self.height - self.videoIconView.height)/2);
}

#pragma mark 视频消息视图
- (UIImageView *)videoIconView{
    //视频图标
    if (!_videoIconView) {
        _videoIconView = [[UIImageView alloc]init];
        _videoIconView.size = CGSizeMake(30, 30);
        _videoIconView.image = [SHFileHelper imageNamed:@"chat_video.png"];
        [self.btnContent addSubview:_videoIconView];
    }
    return _videoIconView;
}


@end
