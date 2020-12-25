//
//  SHFileTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2020/11/3.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHFileTableViewCell.h"

@interface SHFileTableViewCell ()

//文件图标
@property (nonatomic, strong) UIImageView *iconImg;
//文件名称
@property (nonatomic, strong) UILabel *fileName;
//文件大小
@property (nonatomic, strong) UILabel *fileSize;

@end

@implementation SHFileTableViewCell

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
    self.fileName.text = message.displayName;
    self.fileSize.text = message.fileSize;
    
    [self.bubbleBtn setBubbleColor:[UIColor whiteColor]];
    
    //设置frame
    CGFloat margin = messageFrame.startX;
    
    self.iconImg.x = self.bubbleBtn.width - kChat_margin - self.iconImg.width + margin;
    
    self.fileSize.width = self.iconImg.x -  self.fileName.x - kChat_margin;
    
    self.fileName.x = margin + kChat_margin;
    self.fileName.width = self.fileSize.width;
    [self.fileName sizeToFit];
    
    self.fileSize.origin = CGPointMake(self.fileName.x, self.fileName.maxY + 5);
}

#pragma mark 文件消息视图
//文件图标
- (UIImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [[UIImageView alloc]init];
        _iconImg.size = CGSizeMake(40, 45);
        _iconImg.y = kChat_margin;
        _iconImg.image = [SHFileHelper imageNamed:@"chat_file"];
        [self.bubbleBtn addSubview:_iconImg];
    }
    return _iconImg;
}

//文件名称
- (UILabel *)fileName {
    //来源
    if (!_fileName) {
        _fileName = [[UILabel alloc]init];
        _fileName.y = kChat_margin;
        _fileName.font = [UIFont boldSystemFontOfSize:16];
        _fileName.textColor = [UIColor blackColor];
        _fileName.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _fileName.numberOfLines = 2;
        [self.bubbleBtn addSubview:_fileName];
    }
    return _fileName;
}

//文件大小
- (UILabel *)fileSize {
    //来源
    if (!_fileSize) {
        _fileSize = [[UILabel alloc]init];
        _fileSize.font = [UIFont systemFontOfSize:10];
        _fileSize.height = _fileSize.font.lineHeight;
        _fileSize.textColor = [UIColor grayColor];
        [self.bubbleBtn addSubview:_fileSize];
    }
    return _fileSize;
}
@end
