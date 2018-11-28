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

    NSString *filePath = [SHFileHelper getFilePathWithName:message.imageName type:SHMessageFileType_image];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    if (image) {//本地
        [self.btnContent setBackgroundImage:image forState:0];
    }else{//网络
        //sdwebimage
        [self.btnContent setBackgroundImage:[SHFileHelper imageNamed:@"chat_picture.png"] forState:0];
    }
}

@end
