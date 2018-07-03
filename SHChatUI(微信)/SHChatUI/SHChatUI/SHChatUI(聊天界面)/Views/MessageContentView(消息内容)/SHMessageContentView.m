//
//  SHMessageContentView.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/30.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageContentView.h"
#import "SHMessageHeader.h"
#import "SHMessageFrame.h"
#import "SHLocation.h"

@implementation SHMessageContentView

#pragma mark - 懒加载
#pragma mark 文本消息视图
- (SHTextView *)textView{
    //文本
    if (!_textView) {
        _textView = [[SHTextView alloc]init];
        _textView.backgroundColor = [UIColor clearColor];
        [self addSubview:_textView];
    }
    return _textView;
}

#pragma mark 语音消息视图
- (UIImageView *)voiceView{
    //语音声波
    if (!_voiceView) {
        _voiceView = [[UIImageView alloc]init];
        _voiceView.size = CGSizeMake(15, 15);
        [self addSubview:_voiceView];
        //动画
        _voiceView.animationDuration = 1;
        _voiceView.animationRepeatCount = 0;
    }
    return _voiceView;
}

- (UILabel *)voiceNum{
    //语音时长
    if (!_voiceNum) {
        _voiceNum = [[UILabel alloc]init];
        _voiceNum.size = CGSizeMake(25, 20);
        _voiceNum.textColor = [UIColor lightGrayColor];
        _voiceNum.font = [UIFont systemFontOfSize:14];
        [self addSubview:_voiceNum];
    }
    return _voiceNum;
}

- (UIImageView *)readMarker{
    //未读标记
    if (!_readMarker) {
        _readMarker = [[UIImageView alloc]init];
        _readMarker.frame = CGRectMake(0, 1, 9, 9);
        _readMarker.image = [UIImage imageNamed:@"unread.png"];
        [self addSubview:_readMarker];
    }
    return _readMarker;
}

#pragma mark 位置消息视图
- (MKMapView *)locView{
    //位置背景
    if (!_locView) {
        _locView = [[MKMapView alloc]init];
        _locName.origin = CGPointMake(0, 0);
        _locView.mapType = MKMapTypeStandard;
        _locView.userInteractionEnabled = NO;
        [self addSubview:_locView];
    }
    return _locView;
}

- (UILabel *)locName{
    //位置文字
    if (!_locName) {
        _locName = [[UILabel alloc]init];
        _locName.textColor = [UIColor whiteColor];
        _locName.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _locName.font = [UIFont systemFontOfSize:14];
        _locName.numberOfLines = 1;
        _locName.textAlignment = NSTextAlignmentCenter;
        [self.locView addSubview:_locName];
    }
    return _locName;
}

#pragma mark 视频消息视图
- (UIImageView *)videoIconView{
    //视频图标
    if (!_videoIconView) {
        _videoIconView = [[UIImageView alloc]init];
        _videoIconView.size = CGSizeMake(30, 30);
        _videoIconView.image = [UIImage imageNamed:@"chat_video.png"];
        [self addSubview:_videoIconView];
    }
    return _videoIconView;
}

#pragma mark 提示消息视图
- (UILabel *)noteLab{
    //提示
    if (!_noteLab) {
        _noteLab = [[UILabel alloc]init];
        _noteLab.font = kChatFont_note;
        _noteLab.textColor = [UIColor whiteColor];
        _noteLab.textAlignment = NSTextAlignmentLeft;
        _noteLab.numberOfLines = 0;
        [self addSubview:_noteLab];
    }
    return _noteLab;
}

#pragma mark 名片消息视图
- (UIImageView *)cardBg{
    //背景
    if (!_cardBg) {
        _cardBg = [[UIImageView alloc]init];
        _cardBg.origin = CGPointMake(0, 0);
        _cardBg.backgroundColor = [UIColor whiteColor];
        _cardBg.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_cardBg];
    }
    return _cardBg;
}

- (UIImageView *)cardHead{
    //头像
    if (!_cardHead) {
        _cardHead = [[UIImageView alloc]init];
        _cardHead.frame = CGRectMake(0, kChat_margin, 40, 40);
        _cardHead.contentMode = UIViewContentModeScaleToFill;
        [self.cardBg addSubview:_cardHead];
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
        [self.cardBg addSubview:_cardName];
    }
    return _cardName;
}

- (UIView *)cardLine{
    //分割线
    if (!_cardLine) {
        _cardLine = [[UIView alloc]init];
        _cardLine.backgroundColor = kRGB(245, 245, 245, 1);
        [self.cardBg addSubview:_cardLine];
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
        [self.cardBg addSubview:_cardPrompt];
    }
    return _cardPrompt;
}

#pragma mark 红包消息视图
- (UIImageView *)redPaperBg {
    //背景
    if (!_redPaperBg) {
        _redPaperBg = [[UIImageView alloc]init];
        _redPaperBg.origin = CGPointMake(0, 0);
        _redPaperBg.backgroundColor = kRGB(250, 157, 59, 1);
        _redPaperBg.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_redPaperBg];
    }
    return _redPaperBg;
}

- (UIImageView *)redPaperImage {
    //图片
    if (!_redPaperImage) {
        _redPaperImage = [[UIImageView alloc]init];
        _redPaperImage.image = [UIImage imageNamed:@"redpackage.png"];
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

#pragma mark Gif消息视图
- (WKWebView *)gifView{
    if (!_gifView) {
        _gifView = [[WKWebView alloc]init];
        _gifView.origin = CGPointMake(0, 0);
        _gifView.backgroundColor = [UIColor clearColor];
        _gifView.userInteractionEnabled = NO;
        _gifView.scrollView.scrollEnabled = NO;
        _gifView.opaque = NO;
        [self addSubview:_gifView];
    }
    return _gifView;
}

#pragma mark - 语音动画
#pragma mark 语音播放开始动画
- (void)playVoiceAnimation {
    [self.voiceView stopAnimating];
    [self.voiceView startAnimating];
}

#pragma mark 语音播放停止动画
- (void)stopVoiceAnimation {
    [self.voiceView stopAnimating];
}

#pragma mark - 设置内部控件Frame
- (void)setMessage:(SHMessage *)message {
    
    _message = message;
    
    // 初始化
    [self setBackgroundImage:nil forState:0];
    //文本
    self.textView.hidden = YES;
    //语音
    self.voiceView.hidden = YES;
    self.voiceNum.hidden = YES;
    self.readMarker.hidden = YES;
    //位置
    self.locView.hidden = YES;
    self.locName.hidden = YES;
    //视频
    self.videoIconView.hidden = YES;
    //通知
    self.noteLab.hidden = YES;
    //个人名片
    self.cardBg.hidden = YES;
    //红包
    self.redPaperBg.hidden = YES;
    //Gif
    self.gifView.hidden = YES;
    
    BOOL isSend = (message.bubbleMessageType == SHBubbleMessageType_Sending);
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 0;
    self.clipsToBounds = NO;
    
    // 背景颜色与描边
    switch (message.messageType) {
        case SHMessageBodyType_note:
        {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            self.layer.cornerRadius = 5;
            self.clipsToBounds = YES;
        }
            break;
        case SHMessageBodyType_image:case SHMessageBodyType_video://图片、视频
        {
            self.backgroundColor = [UIColor blackColor];
            self.layer.cornerRadius = 5;
            self.clipsToBounds = YES;
            
            if (isSend) {
                self.x -= kChat_angle_w;
            }else{
                self.x += kChat_angle_w;
            }
        }
            break;
        case SHMessageBodyType_gif:
        {
            if (isSend) {
                self.x -= kChat_angle_w;
            }else{
                self.x += kChat_angle_w;
            }
        }
            break;
        default:
            break;
    }
    
    // 设置聊天气泡背景
    UIImage *normal = nil;
    if (isSend) {
        normal = [UIImage imageNamed:@"chat_message_send"];
    }else{
        normal = [UIImage imageNamed:@"chat_message_receive"];
    }
    
    normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(30, 25, 10, 25)];
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    
    // 设置其他内容
    [self setContentWithMessage:message image:normal];
}

#pragma mark 设置内容
- (void)setContentWithMessage:(SHMessage *)message image:(UIImage *)image{
    
    BOOL isSend = (message.bubbleMessageType == SHBubbleMessageType_Sending);
    
    NSInteger set_space = 5;
    
    //判断消息类型
    switch (message.messageType) {
        case SHMessageBodyType_text://文字
        {
            self.textView.hidden = NO;
            
            NSMutableAttributedString *str = [SHEmotionTool dealMessageWithStr:message.text];
            [str addAttribute:NSFontAttributeName value:kChatFont_content range:NSMakeRange(0, str.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str.length)];
            
            self.textView.attributedText = str;
            
            //设置frame
            CGFloat view_y = kChat_margin;
            if (kChatFont_content.lineHeight < kChat_min_h) {//为了使聊天内容与最小高度对齐
                view_y = (kChat_min_h - kChatFont_content.lineHeight)/2;
            }
            
            self.textView.frame = CGRectMake(kChat_margin + (isSend?0:kChat_angle_w), view_y, self.width - (2*kChat_margin + kChat_angle_w), self.height - 2*view_y);
        }
            break;
        case SHMessageBodyType_image://图片
        {
            NSString *filePath = [SHFileHelper getFilePathWithName:message.imageName type:SHMessageFileType_image];
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            
            if (image) {//本地
                [self setBackgroundImage:image forState:0];
            }else{//网络
                //sdwebimage
                [self setBackgroundImage:[UIImage imageNamed:@"chat_picture.png"] forState:0];
            }
        }
            break;
        case SHMessageBodyType_voice://语音
        {
            //设置内容
            self.voiceView.hidden = NO;
            
            if (!isSend) {
                self.readMarker.hidden = message.messageRead;
                //未读标记
                self.readMarker.x = self.width + set_space;
            }
            
            self.voiceNum.hidden = (message.messageState != SHSendMessageType_Successed);
            self.voiceNum.text = [NSString stringWithFormat:@"%@\"",message.voiceDuration];
            
            if (!message.voiceName.length) {
                message.voiceName = [SHFileHelper getNameWithUrl:message.voiceUrl];
            }
            
            //设置frame
            self.voiceView.y = (self.height - self.voiceView.height)/2;
            self.voiceNum.y = (self.height - self.voiceNum.height)/2;
            
            if (isSend) {
                //语音图片
                self.voiceView.x = self.width - kChat_angle_w - kChat_margin - self.voiceView.width - 5;
                //动画
                self.voiceView.image = [UIImage imageNamed:@"chat_send_voice4.png"];
                self.voiceView.animationImages = [NSArray arrayWithObjects:
                                                  [UIImage imageNamed:@"chat_send_voice1.png"],
                                                  [UIImage imageNamed:@"chat_send_voice2.png"],
                                                  [UIImage imageNamed:@"chat_send_voice3.png"],
                                                  [UIImage imageNamed:@"chat_send_voice4.png"],nil];
                //时长
                self.voiceNum.x = - (25 + set_space);
                self.voiceNum.textAlignment = NSTextAlignmentRight;
                
            }else{
                //语音图片
                self.voiceView.x = kChat_angle_w + kChat_margin + 5;
                
                //动画
                self.voiceView.image = [UIImage imageNamed:@"chat_receive_voice4.png"];
                self.voiceView.animationImages = [NSArray arrayWithObjects:
                                                  [UIImage imageNamed:@"chat_receive_voice1.png"],
                                                  [UIImage imageNamed:@"chat_receive_voice2.png"],
                                                  [UIImage imageNamed:@"chat_receive_voice3.png"],
                                                  [UIImage imageNamed:@"chat_receive_voice4.png"],nil];
                //时长
                self.voiceNum.x = self.width + set_space;
                self.voiceNum.textAlignment = NSTextAlignmentLeft;
            }
        }
            break;
        case SHMessageBodyType_location://位置
        {
            self.locView.hidden = NO;
            self.locName.hidden = NO;
            
            SHLocation *location = [[SHLocation alloc]init];
            CLLocationCoordinate2D coordinate;
            coordinate.longitude = message.lon;
            coordinate.latitude = message.lat;
            
            location.coordinate = coordinate;
            //点击大头针的标题
            location.title = message.locationName;
            //将坐标添加到地图上
            [self.locView addAnnotation:location];
            
            //显示区域
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
            //重新设置地图视图的显示区域
            [self.locView setRegion:viewRegion animated:YES];
            
            self.locName.text = message.locationName;
            
            //编辑气泡
            [self makeMaskView:self.locView withImage:image];
            
            //设置frame
            self.locView.size = CGSizeMake(self.width, self.height);
            self.locName.frame = CGRectMake(isSend?0:kChat_angle_w, self.locView.height - 30, self.locView.width - kChat_angle_w, 30);
        }
            break;
        case SHMessageBodyType_note://提示文字
        {
            [self setBackgroundImage:nil forState:UIControlStateNormal];
            self.noteLab.hidden = NO;
            self.noteLab.text = message.note;
            
            //设置frame
            self.noteLab.frame = CGRectMake(kChat_margin, kChat_margin, self.width - 2*kChat_margin, self.height - 2*kChat_margin);
        }
            break;
        case SHMessageBodyType_card://名片
        {
            self.cardBg.hidden = NO;
            
            self.cardPrompt.text = @"    个人名片";
            self.cardName.text = @"小明";
            self.cardHead.image = [UIImage imageNamed:@"headImage.jpeg"];
            //编辑气泡
            [self makeMaskView:self.cardBg withImage:image];
            
            //设置frame
            //背景
            self.cardBg.size = CGSizeMake(self.width, self.height);
            //头像
            self.cardHead.x = kChat_margin + (isSend?0:kChat_angle_w);
            //名字
            self.cardName.frame = CGRectMake(self.cardHead.maxX + kChat_margin, self.cardHead.y, self.width - self.cardHead.maxX - 2*kChat_margin - kChat_angle_w, self.cardHead.height);
            //分割线
            self.cardLine.frame = CGRectMake((isSend?0:kChat_angle_w),self.cardHead.maxY + kChat_margin ,self.width - kChat_angle_w, 0.5);
            //提示信息
            self.cardPrompt.frame = CGRectMake(self.cardLine.x, self.cardLine.maxY, self.cardLine.width, 20);
        }
            break;
        case SHMessageBodyType_redPaper://红包
        {
            self.redPaperBg.hidden = NO;
            
            self.redPaperContent.text = message.redPackage;
            self.redPaperRemark.text = @"打开红包";
            self.redPaperSource.text = @"    红包";
            //编辑气泡
            [self makeMaskView:self.redPaperBg withImage:image];
            
            //设置frame
            //背景
            self.redPaperBg.size = CGSizeMake( self.width, self.height);
            //图标
            self.redPaperImage.frame = CGRectMake(kChat_margin + (isSend?0:kChat_angle_w), kChat_margin, 30, 40);
            //内容
            self.redPaperContent.frame = CGRectMake(self.redPaperImage.maxX + kChat_margin, self.redPaperImage.y,self.width - self.redPaperImage.maxX - 2*kChat_margin - kChat_angle_w,20);
            //提示
            self.redPaperRemark.frame = CGRectMake(self.redPaperContent.x, self.redPaperContent.maxY, self.redPaperContent.width, 20);
            //来源
            self.redPaperSource.frame = CGRectMake((isSend?0:kChat_angle_w), self.redPaperImage.maxY + kChat_margin, self.width - kChat_angle_w, 20);
        }
            break;
        case SHMessageBodyType_gif://Gif
        {
            [self setBackgroundImage:nil forState:UIControlStateNormal];
            self.gifView.hidden = NO;
            
            //获取Gif路径 (自带Gif)
            NSString *gifPath = [kGif_Emoji_Path stringByAppendingString:message.gifName];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:gifPath]) {
                
                //获取Gif路径(缓存)
                gifPath = [SHFileHelper getFilePathWithName:message.gifName type:SHMessageFileType_gif];
                
            }
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:gifPath]) {//本地
                
                if (@available(iOS 9.0, *)) {
                    [self.gifView loadData:[NSData dataWithContentsOfFile:gifPath] MIMEType:@"image/gif" characterEncodingName:@"" baseURL:[NSURL new]];
                } else {
                    // Fallback on earlier versions
                }
            }else{//网络
                
                [self.gifView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:message.gifUrl]]];
            }
            
            //设置frame
            self.gifView.size = CGSizeMake(self.width, self.height);
        }
            break;
        case SHMessageBodyType_video://视频
        {
            self.videoIconView.hidden = NO;
            [self setBackgroundImage:nil forState:0];
            
            //视频第一帧图片路径
            NSString *videoImagePath = [SHFileHelper getFilePathWithName:message.voiceName type:SHMessageFileType_video_image];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:videoImagePath]) {//本地
                
                [self setBackgroundImage:[UIImage imageWithContentsOfFile:videoImagePath] forState:0];
            }else{//网络
                
                //异步获取
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    //把第一帧图片保存到本地中
                    NSString *videoImageName = [SHFileHelper getFileNameWithContent:message.videoUrl type:SHMessageFileType_video_image];
                    NSString *imagePath = [SHFileHelper getFileNameWithContent:videoImageName type:SHMessageFileType_video_image];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {//获取到第一帧图片
                            
                            [self setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:0];
                        }
                    });
                });
            }
            
            //设置frame
            self.videoIconView.origin = CGPointMake((self.width - self.videoIconView.width)/2, (self.height - self.videoIconView.height)/2);
        }
            break;
        default:
            break;
    }
}

#pragma mark 剪切视图
- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
        imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
        view.layer.mask = imageViewMask.layer;
    });
}

@end
