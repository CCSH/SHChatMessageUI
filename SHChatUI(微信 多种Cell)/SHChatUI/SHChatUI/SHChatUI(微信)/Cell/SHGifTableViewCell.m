//
//  SHGifTableViewCell.m
//  SHChatUI
//
//  Created by CSH on 2018/11/28.
//  Copyright © 2018 CSH. All rights reserved.
//

#import "SHGifTableViewCell.h"

@interface SHGifTableViewCell ()

// Gif
@property (nonatomic, retain) WKWebView *gifView;

@end

@implementation SHGifTableViewCell

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
    //获取Gif路径 (自带Gif)
    NSString *gifPath = [[SHEmotionTool getEmojiPathWithType:SHEmoticonType_gif] stringByAppendingString:message.gifName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:gifPath]) {
        
        //获取Gif路径(缓存)
        gifPath = [SHFileHelper getFilePathWithName:message.gifName type:SHMessageFileType_gif];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:gifPath]) {//本地
        [self.gifView loadData:[NSData dataWithContentsOfFile:gifPath] MIMEType:@"image/gif" characterEncodingName:@"" baseURL:[NSURL new]];
    }else{//网络
        [self.gifView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:message.gifUrl]]];
    }
    
    //设置frame
    self.gifView.size = CGSizeMake(self.btnContent.width, self.btnContent.height);
    
    [self.btnContent setBackgroundImage:nil forState:0];
}

#pragma mark Gif消息视图
- (WKWebView *)gifView{
    if (!_gifView) {
        _gifView = [[WKWebView alloc]init];
        _gifView.origin = CGPointMake(0, 0);
        _gifView.backgroundColor = [UIColor clearColor];
        _gifView.userInteractionEnabled = NO;
        _gifView.scrollView.scrollEnabled = NO;
        _gifView.opaque = NO;
        [self.btnContent addSubview:_gifView];
    }
    return _gifView;
}


@end
