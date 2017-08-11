//
//  SHChatMessageTableViewCell.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/29.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHChatMessageTableViewCell.h"
#import "SHMessageTimeHelper.h"
#import <Foundation/Foundation.h>
#import "SHMessageMacroHeader.h"
#import "SHLocation.h"
#import "SHEmotionTool.h"

@interface SHChatMessageTableViewCell ()<UIAlertViewDelegate>

@end

@implementation SHChatMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - 懒加载
#pragma mark 创建时间
- (UILabel *)labelTime{
    if (!_labelTime) {
        _labelTime = [[UILabel alloc] init];
        _labelTime.textAlignment = NSTextAlignmentCenter;
        _labelTime.textColor = [UIColor whiteColor];
        _labelTime.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _labelTime.layer.masksToBounds = YES;
        _labelTime.layer.cornerRadius = 5;
        _labelTime.font = ChatTimeFont;
        [self.contentView addSubview:_labelTime];
    }
    return _labelTime;
}

#pragma mark 创建ID
- (UILabel *)labelNum{
    if (!_labelNum) {
        _labelNum = [[UILabel alloc] init];
        _labelNum.textColor = [UIColor grayColor];
        _labelNum.textAlignment = NSTextAlignmentCenter;
        _labelNum.font = ChatTimeFont;
        [self.contentView addSubview:_labelNum];
    }
    return _labelNum;
}

#pragma mark 创建头像
- (UIButton *)btnHeadImage{
    if (!_btnHeadImage) {
        _btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        //描边
        _btnHeadImage.layer.cornerRadius = ChatIconWH/2;
        _btnHeadImage.layer.borderWidth = 0.5;
        _btnHeadImage.layer.borderColor = [UIColor clearColor].CGColor;
        _btnHeadImage.layer.masksToBounds = YES;
        //点击头像
        [_btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        //长按头像
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(btnHeadImageLongClick:)];
        
        [_btnHeadImage addGestureRecognizer:longTap];
        [self.contentView addSubview:_btnHeadImage];
    }
    return _btnHeadImage;
}

#pragma mark 创建内容
- (SHMessageContentView *)btnContent{
    if (!_btnContent) {
        _btnContent = [SHMessageContentView buttonWithType:UIButtonTypeCustom];
       
        _btnContent.titleLabel.font = ChatContentFont;
        _btnContent.titleLabel.numberOfLines = 0;
        [_btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
       
        //提示点击
        [_btnContent.messgeActivity addTarget:self action:@selector(repeatClick:) forControlEvents:UIControlEventTouchUpInside];
        
         [self.contentView addSubview:_btnContent];
    }
    return _btnContent;
    
}

#pragma mark - 内容及Frame设置
- (void)setMessageFrame:(SHMessageFrame *)messageFrame {
    
    _messageFrame = messageFrame;
    SHMessage *message = messageFrame.message;
    
    // 1、设置时间
    self.labelTime.frame = messageFrame.timeF;
    self.labelTime.text = message.sendTime.chatTime;
    
    // 2、设置头像
    self.btnHeadImage.frame = messageFrame.iconF;
    [self.btnHeadImage setBackgroundImage:[UIImage imageNamed:@"chatBg_2.jpg"] forState:0];
    
    // 3、设置昵称
    self.labelNum.frame = messageFrame.nameF;
    self.labelNum.text = message.userName;
    
    if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
        self.labelNum.textAlignment = NSTextAlignmentRight;
    }else{
        self.labelNum.textAlignment = NSTextAlignmentLeft;
    }
    
    // 4、设置内容
    self.btnContent.frame = messageFrame.contentF;    
    self.btnContent.message = message;
    
    // 5、初始化
    [self.btnContent setTitle:@"" forState:0];
    [self.btnContent setAttributedTitle:[[NSAttributedString alloc] init] forState:0];
    //头像
    self.btnHeadImage.hidden = YES;
    //图片
    self.btnContent.imageMessageView.hidden = YES;
    //语音
    self.btnContent.voiceMessageView.hidden = YES;
    self.btnContent.voiceNum.hidden = YES;
    self.btnContent.readMarker.hidden = YES;
    //位置
    self.btnContent.locationMapView.hidden = YES;
    self.btnContent.locationMessageLabel.hidden = YES;
    //视频
    self.btnContent.videoMessageView.hidden = YES;
    self.btnContent.videoIconMessageView.hidden = YES;
    //发送状态
    self.btnContent.messgeActivity.hidden = YES;
    //提示文字
    self.btnContent.promptLabel.hidden = YES;
    //个人名片
    self.btnContent.cardMessageBg.hidden = YES;
    //红包
    self.btnContent.redPaperBg.hidden = YES;
    //阅后即焚
    self.btnContent.burnImage.hidden = YES;
    self.btnContent.burnLabel.hidden = YES;
    self.btnContent.burnIconImage.hidden = YES;
    //Gif
    self.btnContent.gifView.hidden = YES;
    //语音信箱
    self.btnContent.voiceEmailView.hidden = YES;
    
    // 6、背景偏移量
    if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft);
    }else{
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
    }
    
    // 7、设置发送状态
    if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
        self.btnContent.messgeActivity.hidden = (message.messageState == SHSendMessageType_Successed);
    }
    
    // 8、设置发送状态样式
    if (!self.btnContent.messgeActivity.hidden) {
        
        switch (message.messageState) {
            case SHSendMessageType_Delivering:
                [self.btnContent.messgeActivity showType:ShowActivityType_Activity];
                break;
            case SHSendMessageType_Failed:
                [self.btnContent.messgeActivity showType:ShowActivityType_Fail];
                break;
            case SHSendMessageType_Successed:
                break;
            default:
                break;
        }
    }
        
    // 9、设置聊天气泡背景
    UIImage *normal = nil;
        
    if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
        
        if (message.messageType == SHMessageBodyType_Card || message.messageType == SHMessageBodyType_Image || message.messageType == SHMessageBodyType_Location ||message.messageType == SHMessageBodyType_Burn) {//名片、图片、位置、阅后即焚换气泡
            normal = [UIImage imageNamed:@"chat_message_send_special"];
        }else{
            normal = [UIImage imageNamed:@"chat_message_send"];
        }
    }else{
        
        normal = [UIImage imageNamed:@"chat_message_receive"];
    }
    
    normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(25, 17, 10, 17)];
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    
    // 10、背景颜色与描边
    if (message.messageType == SHMessageBodyType_Note || message.messageType == SHMessageBodyType_RedPaperNote || message.messageType == SHMessageBodyType_ReCall) {
        //提示框的背景颜色
        self.btnContent.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.btnContent.layer.cornerRadius = 5;
    }else{
        self.btnContent.backgroundColor = [UIColor clearColor];
        self.btnContent.layer.cornerRadius = 0;
    }
    
    // 11、设置属性
    switch (message.messageType) {
        case SHMessageBodyType_Text://文字
        {
            [self.btnContent setTitle:message.text forState:0];
        }
            break;
        case SHMessageBodyType_Image://图片
        {
            self.btnContent.imageMessageView.hidden = NO;

            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",kSHImagePath,message.imagePath.lastPathComponent]];
            
            if (!image) {
                self.btnContent.imageMessageView.image = [UIImage imageNamed:@"placeholderImage.png"];
            }else{
                self.btnContent.imageMessageView.image = image;
            }
            
            //编辑气泡
            [self makeMaskView:self.btnContent.imageMessageView withImage:normal];
        }
            break;
        case SHMessageBodyType_Voice://语音
        {
            self.btnContent.voiceMessageView.hidden = NO;
            self.btnContent.readMarker.hidden = message.messageRead;
            self.btnContent.voiceNum.hidden = !self.btnContent.messgeActivity.hidden;
            
            self.btnContent.voiceNum.text = [NSString stringWithFormat:@"%@\"",message.voiceDuration];
        }
            break;
        case SHMessageBodyType_Location://位置
        {
            self.btnContent.locationMapView.hidden = NO;
            self.btnContent.locationMessageLabel.hidden = NO;
            
            SHLocation *location = [[SHLocation alloc]init];
            CLLocationCoordinate2D coordinate;
            coordinate.longitude = message.lon;
            coordinate.latitude = message.lat;
            
            location.coordinate = coordinate;
            //点击大头针的标题
            location.title = message.locationName;
            //将坐标添加到地图上
            [self.btnContent.locationMapView addAnnotation:location];
            
            //显示区域
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
            //重新设置地图视图的显示区域
            [self.btnContent.locationMapView setRegion:viewRegion animated:YES];

            self.btnContent.locationMessageLabel.text = message.locationName;
            
            //编辑气泡
            [self makeMaskView:self.btnContent.locationMapView withImage:normal];
        }
            break;
        case SHMessageBodyType_Video://视频
        {
            self.btnContent.videoMessageView.hidden = NO;
            self.btnContent.videoIconMessageView.hidden = NO;
            
            //视频第一帧图片路径
            NSString *videoImagePath = [SHFileHelper getVideoImageWithVideo:message.videoUrl];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:videoImagePath]) {//如果本地路径存在
                
                self.btnContent.videoMessageView.image = [UIImage imageWithContentsOfFile:videoImagePath];
            }else{
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    //获取视频路径
                    NSString *videoPath = [NSString stringWithFormat:@"%@/%@",kSHVideoPath,message.videoUrl.lastPathComponent];
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {//如果本地路径不存在
                        videoPath = message.videoUrl;
                    }
                    
                    //把第一帧图片保存到本地中
                    UIImage *firstImage = [SHMessageVideoHelper videoConverPhotoWithVideoPath:videoPath];
                    if (firstImage) {//获取到第一帧图片
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.btnContent.videoMessageView.image = firstImage;
                        });
                    }
                });
            }
            //编辑气泡
            [self makeMaskView:self.btnContent.videoMessageView withImage:normal];
        }
            break;
        case SHMessageBodyType_Note://提示文字
        {
            [self.btnContent setBackgroundImage:nil forState:UIControlStateNormal];
            self.btnContent.promptLabel.hidden = NO;
            self.btnContent.promptLabel.text = message.promptContent;
        }
            break;
        case SHMessageBodyType_RedPaperNote://红包提示文字
        {
            [self.btnContent setBackgroundImage:nil forState:UIControlStateNormal];
            self.btnContent.promptLabel.hidden = NO;
            self.btnContent.promptLabel.text = message.promptContent;
        }
            break;
        case SHMessageBodyType_Card://名片
        {
            self.btnContent.cardMessageBg.hidden = NO;
            
            self.btnContent.cardMessagePromptLabel.text = @"个人名片";
            self.btnContent.cardMessageLabel.text = @"小明";
            self.btnContent.cardMessageImage.image = [UIImage imageNamed:@"chatBg_2.jpg"];
            //编辑气泡
            [self makeMaskView:self.btnContent.cardMessageBg withImage:normal];
        }
            break;
        case SHMessageBodyType_RedPaper://红包
        {
            self.btnContent.redPaperBg.hidden = NO;
            
            self.btnContent.redPaperContentLable.text = @"恭喜发财";
            self.btnContent.redPaperRemainLable.text = @"打开红包";
            self.btnContent.redPaperResourceLable.text = @"   红包";
            //编辑气泡
            [self makeMaskView:self.btnContent.redPaperBg withImage:normal];
        }
            break;
        case SHMessageBodyType_Phone://通话
        {
           
        }
            break;
            case SHMessageBodyType_Burn://阅后即焚
        {
            self.btnContent.burnImage.hidden = NO;
            self.btnContent.burnLabel.hidden = NO;
            self.btnContent.burnIconImage.hidden = NO;
            
            self.btnContent.burnImage.image = [UIImage imageNamed:@"message_burn_text.png"];

            self.btnContent.burnLabel.text = @"阅后即焚";
            self.btnContent.burnIconImage.image = [UIImage imageNamed:@"message_burn_icon.png"];
        }
            break;
        case SHMessageBodyType_Gif://Gif
        {
            [self.btnContent setBackgroundImage:nil forState:UIControlStateNormal];
            self.btnContent.gifView.hidden = NO;
            
            //获取Gif路径
            NSString *gifPath = [NSString stringWithFormat:@"%@/%@",kSHGifPath,message.gifUrl.lastPathComponent];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:gifPath]) {//如果本地路径存在则展示本地
                
                [self.btnContent.gifView loadData:[NSData dataWithContentsOfFile:gifPath] MIMEType:@"image/gif" characterEncodingName:@"" baseURL:[NSURL new]];
            }else{
                
                [self.btnContent.gifView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:message.gifUrl]]];
            }
        }
            break;
        case SHMessageBodyType_VoiceEmail://语音信箱
        {
            self.btnContent.voiceEmailView.hidden = NO;
            self.btnContent.readMarker.hidden = message.messageRead;
        }
            break;
        case SHMessageBodyType_ReCall://撤回
        {
            [self.btnContent setBackgroundImage:nil forState:UIControlStateNormal];
            self.btnContent.promptLabel.hidden = NO;
            self.btnContent.promptLabel.text = message.promptContent;
        }
            break;
        default:
            break;
    }
    
    // 12、添加长按内容
    if (message.messageType != SHMessageBodyType_Note && message.messageType != SHMessageBodyType_RedPaperNote && message.messageType != SHMessageBodyType_ReCall) {
        self.btnHeadImage.hidden =  NO;
        //长按内容
        UILongPressGestureRecognizer *longContent = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longContent:)];
        longContent.minimumPressDuration = 0.4;
        [self addGestureRecognizer:longContent];
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

#pragma mark 点击头像
- (void)btnHeadImageClick:(id)button {
    if ([self.delegate respondsToSelector:@selector(headImageClick:message:clickType:)])  {
        [self.delegate headImageClick:self message:self.messageFrame.message clickType:SHMessageClickType_Click];
    }
}

#pragma mark 长按头像
- (void)btnHeadImageLongClick:(UILongPressGestureRecognizer *)button {
    if (button.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(headImageClick:message:clickType:)])  {
            [self.delegate headImageClick:self message:self.messageFrame.message clickType:SHMessageClickType_Long];
        }
    }
}

#pragma mark 点击消息体
- (void)btnContentClick {
    if ([_delegate respondsToSelector:@selector(contentClick:message:clickType:)]) {
        [_delegate contentClick:self message:self.messageFrame.message clickType:SHMessageClickType_Click];
    }
}

#pragma mark 长按消息体
- (void)longContent:(UILongPressGestureRecognizer *)button{
    if (button.state == UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(contentClick:message:clickType:)]) {
            [_delegate contentClick:self message:self.messageFrame.message clickType:SHMessageClickType_Long];
        }
    }
}

#pragma mark 点击重发
- (void)repeatClick:(id)button{
    if (self.messageFrame.message.messageState == SHSendMessageType_Failed) {
        UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重发此条消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [ale show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(repeatClick:message:)]) {
            [self.delegate repeatClick:self message:self.messageFrame.message];
        }
    }
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
