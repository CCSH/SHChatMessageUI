//
//  SHImageTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHImageTableViewCell.h"

@implementation SHImageTableViewCell

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
    self.bubbleBtn.layer.cornerRadius = 5;
    self.bubbleBtn.layer.masksToBounds = YES;
    self.bubbleBtn.backgroundColor = [UIColor blackColor];
    [self.bubbleBtn setBubbleImage:nil];

    NSString *filePath = [SHFileHelper getFilePathWithName:message.fileName type:SHMessageFileType_image];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
  
    if (image) {//本地
        [self.bubbleBtn setImage:image forState:0];
    }else{//网络
        [self.bubbleBtn sd_setImageWithURL:[NSURL URLWithString:message.fileUrl] forState:0 placeholderImage:[SHFileHelper imageNamed:@"chat_picture"]];
    }
}

@end
