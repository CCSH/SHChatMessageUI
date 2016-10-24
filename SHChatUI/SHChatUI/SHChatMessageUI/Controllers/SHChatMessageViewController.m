//
//  SHChatMessageViewController.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHChatMessageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "SHCahtMessageTableViewCell.h"
#import "SHMessage.h"
#import "SHFileHelper.h"
#import "SHMessageFrame.h"
#import "SHMessageInputView.h"
#import "SHMessageMacroHeader.h"
//时间帮助类
#import "SHMessageTimeHelper.h"
//语音播放
#import "SHAudioPlayerHelper.h"
//位置
#import "SHChatMessageLocationViewController.h"
//图片
#import "SHImageAvatarBrowser.h"

#define CustomNav 0
#define AnimateTime 0.25

@interface SHChatMessageViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate,
SHMessageInputViewDelegate,//输入框代理
SHShareMenuViewDelegate,//多媒体代理
SHCahtMessageCellDelegate,//cell代理
SHAudioPlayerHelperDelegate//播放音频代理
>{
    //下方工具栏
    SHMessageInputView *chatInputView;
    //菜单类型
    NSString *chatMenuType;
    
    //测试用
    BOOL isOpen;
    BOOL isInsertTop;

}

//键盘的多媒体功能控件
@property (nonatomic, weak) SHShareMenuView *shareMenuView;
//多媒体接入的功能，也包括系统自身的功能，比如拍照、发送地理位置
@property (nonatomic, strong) NSArray *shareMenuItems;

//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
//点击的Cell
@property (nonatomic, strong) SHCahtMessageTableViewCell *selectCell;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation SHChatMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"小红";
    //初始化各个参数
    self.dataSource = [[NSMutableArray alloc]init];
    
    //去除下划线
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.backgroundColor = [UIColor clearColor];
    
    //设置聊天背景
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"message_bg.jpeg"]];
    [self.view addSubview:image];
    [self.view sendSubviewToBack:image];
    
    //设置类型
    chatMenuType = @"1";
    chatInputView = [[SHMessageInputView alloc]initWithFrame:CGRectMake(0,  kSHHEIGHT - CustomNav - kSHInPutHeight, kSHWIDTH, kSHInPutHeight) SuperVC:self WithType:chatMenuType];
    chatInputView.delegate = self;
    [self.view addSubview:chatInputView];
    
    //配置多媒体视图
    [self setShareMenuUI];
    
    //添加提示信息
    [self SHMessageInputView:chatInputView sendPrompt:[NSString stringWithFormat:@"你已经与%@是好友了，开始聊天吧",self.title]];
    
    //添加键盘监听
    [self addKeyboardNote];
    
    //外部调用发送消息
    if (self.messageModel) {
        [self externalCallSendMessage:self.messageModel];
    }

}

#pragma mark - 外部调用发送消息
- (void)externalCallSendMessage:(SHMessage *)messageModel{
    //判断消息类型
    switch (messageModel.messageType) {
        case SHMessageBodyType_Text:
        {
           NSLog(@"发送文字");
        }
            break;
        case SHMessageBodyType_Image:
        {
            NSLog(@"发送图片");
        }
            break;
        case SHMessageBodyType_Voice:
        {
            NSLog(@"发送语音");
        }
            break;
        
        case SHMessageBodyType_Location:
        {
            NSLog(@"发送位置");
        }
            break;
        case SHMessageBodyType_Video:
        {
            NSLog(@"发送视频");
        }
            break;
        case SHMessageBodyType_Card:
        {
            NSLog(@"发送名片");
            UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认发送该名片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [ale show];
        }
            break;
        case SHMessageBodyType_File:
        {
            NSLog(@"发送文件");
        }
            break;
        case SHMessageBodyType_RedPaper:
        {
            NSLog(@"发送红包");
        }
            break;
        case SHMessageBodyType_Other:
        {
            NSLog(@"发送其他");
        }
            break;
        case SHMessageBodyType_Prompt:
        {
            NSLog(@"发送提示");
        }
            break;
            
        default:
            break;
    }

    
}

#pragma mark - 发送消息
#pragma mark 发送文本
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendMessage:(NSString *)message{
    
    SHMessage *model = [[SHMessage alloc]init];
    model.userName = @"12345678";
    model.avatarImage = [UIImage imageNamed:@"headImage.jpeg"];
    model.messageState = SHSendMessageType_Delivering;
    model.bubbleMessageType = SHBubbleMessageType_Sending;
    model.isRead = YES;
    model.chatType = SHChatType_Chat;
    model.sendTime = [SHFileHelper getCurrentTimeString];
    model.messageID = [self uuid];
    
    model.messageType = SHMessageBodyType_Text;
    model.text = message;
    
    //设置收发
    if (!isOpen) {
        model.bubbleMessageType = SHBubbleMessageType_Sending;
        model.isRead = YES;
        //模拟真实环境
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            model.messageState = SHSendMessageType_Failed;
            [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.message.messageID isEqualToString:model.messageID]) {
                    [self addMessageWithSHMessage:model];
                }
            }];
        });
    }else{
        model.bubbleMessageType = SHBubbleMessageType_Receiving;
        model.isRead = NO;
    }
    isOpen = !isOpen;

    //添加到界面
    [self addMessageWithSHMessage:model];
    
    //更新界面
    [self refurbishTableViewUIisToBottom:YES];
    

}

#pragma mark 发送图片
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendPicture:(UIImage *)image{
    SHMessage *model = [[SHMessage alloc]init];
    model.userName = @"123456";
    model.avatarImage = [UIImage imageNamed:@"headImage.jpeg"];
    model.messageState = SHSendMessageType_Delivering;
    model.bubbleMessageType = SHBubbleMessageType_Sending;
    model.isRead = YES;
    model.chatType = SHChatType_Chat;
    model.sendTime = [SHFileHelper getCurrentTimeString];
    model.messageID = [self uuid];
    
    model.messageType = SHMessageBodyType_Image;
    model.photo = image;
    
    //设置收发
    if (isOpen) {
        model.bubbleMessageType = SHBubbleMessageType_Sending;
        model.isRead = YES;
        //模拟真实环境
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            model.messageState = SHSendMessageType_Failed;
            [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.message.messageID isEqualToString:model.messageID]) {
                    [self addMessageWithSHMessage:model];
                }
            }];
        });
    }else{
        model.bubbleMessageType = SHBubbleMessageType_Receiving;
        model.isRead = NO;
    }
    isOpen = !isOpen;
    
    //添加到界面
    [self addMessageWithSHMessage:model];
    
    //更新界面
    [self refurbishTableViewUIisToBottom:YES];
    
}

#pragma mark 发送视频
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendVideoPath:(NSString *)videoPath videoImage:(UIImage *)videoImage{
    SHMessage *model = [[SHMessage alloc]init];
    model.userName = @"12345";
    model.avatarImage = [UIImage imageNamed:@"headImage.jpeg"];
    model.messageState = SHSendMessageType_Delivering;
    model.bubbleMessageType = SHBubbleMessageType_Sending;
    model.isRead = YES;
    model.chatType = SHChatType_Chat;
    model.sendTime = [SHFileHelper getCurrentTimeString];
    model.messageID = [self uuid];
    
    model.messageType = SHMessageBodyType_Video;
    model.videoPath = videoPath;
    model.videoImage = videoImage;
    
    //设置收发
    if (isOpen) {
        model.bubbleMessageType = SHBubbleMessageType_Sending;
        model.isRead = YES;
        //模拟真实环境
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            model.messageState = SHSendMessageType_Failed;
            [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.message.messageID isEqualToString:model.messageID]) {
                    [self addMessageWithSHMessage:model];
                }
            }];
        });
    }else{
        model.bubbleMessageType = SHBubbleMessageType_Receiving;
        model.isRead = NO;
    }
    isOpen = !isOpen;
    
    //添加到界面
    [self addMessageWithSHMessage:model];
    
    //更新界面
    [self refurbishTableViewUIisToBottom:YES];

}

#pragma mark 发送语音
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendVoiceWithWavPath:(NSString *)wavPath AmrPath:(NSString *)amrPath RecordDuration:(NSString *)recordDuration{
    SHMessage *model = [[SHMessage alloc]init];
    model.userName = @"1234";
    model.avatarImage = [UIImage imageNamed:@"headImage.jpeg"];
    model.messageState = SHSendMessageType_Delivering;
    model.bubbleMessageType = SHBubbleMessageType_Sending;
    model.isRead = YES;
    model.chatType = SHChatType_Chat;
    model.sendTime = [SHFileHelper getCurrentTimeString];
    model.messageID = [self uuid];
    
    model.messageType = SHMessageBodyType_Voice;
    model.voicePath = wavPath;
    model.voiceDuration = recordDuration;
    
    //设置收发
    if (isOpen) {
        model.bubbleMessageType = SHBubbleMessageType_Sending;
        model.isRead = YES;
        //模拟真实环境
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            model.messageState = SHSendMessageType_Failed;
            [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.message.messageID isEqualToString:model.messageID]) {
                    [self addMessageWithSHMessage:model];
                }
            }];
        });
    }else{
        model.bubbleMessageType = SHBubbleMessageType_Receiving;
        model.isRead = NO;
    }
    isOpen = !isOpen;
    
    //添加到界面
    [self addMessageWithSHMessage:model];
    
    //更新界面
    [self refurbishTableViewUIisToBottom:YES];
    
}

#pragma mark 发送位置
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendCLLocation:(CLLocation *)location LocationName:(NSString *)locationName{
    SHMessage *model = [[SHMessage alloc]init];
    model.userName = @"123";
    model.messageState = SHSendMessageType_Delivering;
    model.bubbleMessageType = SHBubbleMessageType_Sending;
    model.isRead = YES;
    model.chatType = SHChatType_Chat;
    model.sendTime = [SHFileHelper getCurrentTimeString];
    model.avatarImage = [UIImage imageNamed:@"headImage.jpeg"];
    model.messageID = [self uuid];
    
    model.messageType = SHMessageBodyType_Location;
    model.locationImage = [UIImage imageNamed:@"chat_location.png"];
    model.locationName = locationName;
    model.location = location;
    
    //设置收发
    if (isOpen) {
        model.bubbleMessageType = SHBubbleMessageType_Sending;
        model.isRead = YES;
        //模拟真实环境
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            model.messageState = SHSendMessageType_Failed;
            [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.message.messageID isEqualToString:model.messageID]) {
                    [self addMessageWithSHMessage:model];
                }
            }];
            
        });
    }else{
        model.bubbleMessageType = SHBubbleMessageType_Receiving;
        model.isRead = NO;
    }
    isOpen = !isOpen;
    
    //添加到界面
    [self addMessageWithSHMessage:model];
    //更新界面
    [self refurbishTableViewUIisToBottom:YES];
    
}

#pragma mark 发送提示消息
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendPrompt:(NSString *)Prompt{
    
    SHMessage *model = [[SHMessage alloc]init];
    model.sendTime = [SHFileHelper getCurrentTimeString];
    
    model.messageType = SHMessageBodyType_Prompt;
    model.messageState = SHSendMessageType_Successed;
    model.promptContent = Prompt;
    model.messageID = [self uuid];
    model.sendTime = [SHFileHelper getCurrentTimeString];
    //添加到界面
    [self addMessageWithSHMessage:model];
    
    //更新界面
    [self refurbishTableViewUIisToBottom:YES];
    
}

#pragma mark 发送名片信息
- (void)SHMessageInputView:(SHMessageInputView *)inputView sendCard:(NSString *)card{
    
    SHMessage *model = [[SHMessage alloc]init];
    model.userName = @"123";
    model.messageState = SHSendMessageType_Delivering;
    model.bubbleMessageType = SHBubbleMessageType_Sending;
    model.isRead = YES;
    model.chatType = SHChatType_Chat;
    model.sendTime = [SHFileHelper getCurrentTimeString];
    model.avatarImage = [UIImage imageNamed:@"headImage.jpeg"];
    model.messageID = [self uuid];
    
    model.messageType = SHMessageBodyType_Card;
    model.userInfo = card;
    
    //设置收发
    if (isOpen) {
        model.bubbleMessageType = SHBubbleMessageType_Sending;
        model.isRead = YES;
        //模拟真实环境
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            model.messageState = SHSendMessageType_Failed;
            [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.message.messageID isEqualToString:model.messageID]) {
                    [self addMessageWithSHMessage:model];
                }
            }];
            
        });
    }else{
        model.bubbleMessageType = SHBubbleMessageType_Receiving;
        model.isRead = NO;
    }
    isOpen = !isOpen;
    
    //添加到界面
    [self addMessageWithSHMessage:model];
    //更新界面
    [self refurbishTableViewUIisToBottom:YES];
    
}

#pragma mark - 添加消息
- (void)addMessageWithSHMessage:(SHMessage *)message{
    
    //聊天数据处理
    SHMessageFrame *messageFrame = [self getMessageFrameWirhMessage:message];
    if (messageFrame){
        if (isInsertTop) {
            [self.dataSource insertObject:messageFrame atIndex:0];
        }else{
            [self.dataSource addObject:messageFrame];
        }
        isInsertTop = NO;
    }
   
    
    //刷新数据
    [self.chatTableView reloadData];

}

#pragma mark 聊天数据处理
- (SHMessageFrame *)getMessageFrameWirhMessage:(SHMessage *)message{
    SHMessageFrame *messageFrame = [[SHMessageFrame alloc]init];
    
    //是否显示用户名
    if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
        messageFrame.showName = NO;
    }else{
        messageFrame.showName = YES;
    }
    
    //是否需要添加
    __block BOOL isAdd = NO;
    [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([message.messageID isEqualToString:obj.message.messageID]) {//同一条消息
            if ([message.sendTime isEqualToString:obj.message.sendTime]) {//时间相同做刷新
                isAdd = YES;
                messageFrame.showTime = obj.showTime;
                [messageFrame setMessage:message];
                [self.dataSource replaceObjectAtIndex:idx withObject:messageFrame];
            }else{//时间不同做添加
                [self.dataSource removeObject:obj];
            }
            
            *stop = YES;
        }
    }];
    
    if (!isAdd) {
        //判断与上一个时间间隔
        SHMessageFrame *messageFrameOneMore = [self.dataSource lastObject];
        messageFrame.showTime = [SHMessageTimeHelper isShowMessageTimeWithOnTime:messageFrameOneMore.message.sendTime ThisTime:message.sendTime];
        
        [messageFrame setMessage:message];
        
        return messageFrame;
    }else{
        return nil;
    }
}


#pragma mark 获取消息ID
-(NSString*) uuid {
    return [[NSUUID UUID] UUIDString];
}

#pragma mark - 输入框控件点击

#pragma mark 语音点击
- (void)voiceRecordClick{
    
    [self refurbishInputViewUI];
    
}

#pragma mark 多媒体点击
- (void)multimediaClick{
    
    [self refurbishInputViewUI];
    
}

#pragma mark 表情点击
- (void)expressionClick{
    //收起键盘
    [chatInputView.textViewInput resignFirstResponder];
    if ([chatMenuType isEqualToString:@"1"]) {
        chatMenuType = @"2";
    }else if ([chatMenuType isEqualToString:@"2"]){
        chatMenuType = @"3";
    }else{
        chatMenuType = @"1";
    }
    //配置多媒体界面
    [self setShareMenuUI];
    
    [self refurbishInputViewUI];

}


#pragma mark - 配置视图
#pragma mark 配置多媒体视图
- (void)setShareMenuUI{
    
    [self.shareMenuView removeFromSuperview];
    _shareMenuView = nil;
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    //图标
    NSArray *plugIcons;
    //标题
    NSArray *plugTitle;
    if ([chatMenuType isEqualToString:@"1"]) {
        plugIcons = @[@"sharemore_pic", @"sharemore_video", @"sharemore_location", @"sharemore_friendcard", @"sharemore_myfav", @"sharemore_wxtalk", @"sharemore_videovoip", @"sharemore_voiceinput", @"sharemore_voipvoice"];
        plugTitle = @[@"照片", @"拍摄", @"位置", @"名片", @"我的收藏", @"对讲机", @"视频聊天", @"语音输入", @"语音通话"];
       
    }else if([chatMenuType isEqualToString:@"2"]){
        plugIcons = @[@"sharemore_pic", @"sharemore_video", @"sharemore_location", @"sharemore_friendcard", @"sharemore_myfav"];
        plugTitle = @[@"照片", @"拍摄", @"位置", @"名片", @"我的收藏"];
        
    }else{
        plugIcons = @[@"sharemore_pic", @"sharemore_video"];
        plugTitle = @[@"照片", @"拍摄", @"位置"];
    }
    //配置Item按钮
    [plugIcons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *plugIcon = obj;
        SHShareMenuItem *shareMenuItem = [[SHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:idx]];
        [shareMenuItems addObject:shareMenuItem];
    }];
    
    self.shareMenuItems = shareMenuItems;
    //刷新界面
    [self.shareMenuView reloadData];
    
    [self tableViewScrollToBottom];
}

#pragma mark 多媒体菜单
- (SHShareMenuView *)shareMenuView {
    CGFloat shareMenuView_H;
    //计算多媒体菜单高度
    if (self.shareMenuItems.count <= kSHShareMenuPerRowItemCount) {
        shareMenuView_H = 2*KXHShareMenuItemTop + KXHShareMenuItemHeight;
        
    }else if (self.shareMenuItems.count <= kSHShareMenuPerRowItemCount*kSHShareMenuPerColum){
        shareMenuView_H = (KXHShareMenuItemTop + KXHShareMenuItemHeight)*kSHShareMenuPerColum + KXHShareMenuItemTop;
        
    }else{
        shareMenuView_H = (KXHShareMenuItemTop + KXHShareMenuItemHeight)*kSHShareMenuPerColum + kSHShareMenuPageControlHeight;
    }
    
    if (!_shareMenuView) {
        
        SHShareMenuView *shareMenuView = [[SHShareMenuView alloc] initWithFrame:CGRectMake(0, kSHHEIGHT - shareMenuView_H - CustomNav, CGRectGetWidth(self.view.bounds), shareMenuView_H)];
        shareMenuView.delegate = self;
        shareMenuView.shareMenuItems = self.shareMenuItems;
        [self.view addSubview:shareMenuView];
        _shareMenuView = shareMenuView;
    }
    
    return _shareMenuView;
}

#pragma mark 配置表情视图
- (void)setExpressionUI{
    
}

#pragma mark - SHCahtMessageCellDelegate
#pragma mark 消息体点击
- (void)contentClick:(SHCahtMessageTableViewCell *)cell message:(SHMessage *)message clickType:(SHMessageClickType)clickType{
    //收起工具栏
    [self stopToolInput];
    
    switch (clickType) {
        case SHMessageClickType_Click:
        {
            NSLog(@"点击消息");
            message.isRead = YES;
            
            //判断消息类型
            switch (message.messageType) {
                case SHMessageBodyType_Text:
                    NSLog(@"点击文字");
                    break;
                case SHMessageBodyType_Image:{
                    NSLog(@"点击图片");
                    if (cell.btnContent.imageMessageView) {
                        [SHImageAvatarBrowser showImage:cell.btnContent.imageMessageView];
                    }
                    if ([cell.delegate isKindOfClass:[UIViewController class]]) {
                        [[(UIViewController *)cell.delegate view] endEditing:YES];
                    }
                }
                    break;
                case SHMessageBodyType_Voice:{
                    NSLog(@"点击语音");
                    
                    SHAudioPlayerHelper *audio = [SHAudioPlayerHelper shareInstance];
                    audio.delegate = self;
                    switch (cell.btnContent.isPlaying) {
                        case 0:{
                            //未播放
                            cell.btnContent.isPlaying = 1;
                            NSMutableArray *arr = [[NSMutableArray alloc]init];
                            [arr addObject:message.voicePath];
                            
                            [audio managerAudioWithFileArr:arr isClear:YES];
                            
                            
                            break;
                        }
                        case 1://播放中
                            cell.btnContent.isPlaying = 2;
                            [audio pauseAudio];//暂停
                            break;
                        case 2://暂停
                            cell.btnContent.isPlaying = 1;
                            [audio playAudio];//播放
                            break;
                            
                        default:
                            break;
                    }
                    
                    break;
                }
                case SHMessageBodyType_Location:
                {
                    NSLog(@"点击位置");
                    //跳转地图界面
                    SHChatMessageLocationViewController *location = [[SHChatMessageLocationViewController alloc]init];
                    location.message = message;
                    location.locationType = SHMessageLocationType_Look;
                    [self.navigationController pushViewController:location animated:YES];
                    
                    break;
                }
                case SHMessageBodyType_Video:
                {
                    NSLog(@"点击视频");
                    AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:message.videoPath]];
                    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
                    playerViewController.player = player;
                    [self.navigationController pushViewController:playerViewController animated:YES];
                    [playerViewController.player play];
                }
                    break;
                case SHMessageBodyType_Card:
                {
                    NSLog(@"点击名片");
                
                }
                    break;
                case SHMessageBodyType_File:
                    NSLog(@"点击文件");
                    break;
                case SHMessageBodyType_RedPaper:
                    NSLog(@"点击红包");
                    break;
                case SHMessageBodyType_Other:
                    NSLog(@"点击其他");
                    break;
                case SHMessageBodyType_Prompt:
                    NSLog(@"点击提示");
                    break;
                    
                default:
                    break;
            }

        }
           
            break;
        case SHMessageClickType_Long:
        {
            NSLog(@"长按消息");
            [self showMenuControllerWithMessage:message messageCell:cell];
        }
            
        default:
            break;
    }
    
}

#pragma mark 头像点击
- (void)headImageClick:(SHCahtMessageTableViewCell *)cell message:(SHMessage *)message clickType:(SHMessageClickType )clickType{
    if (clickType == SHMessageClickType_Click) {
        NSLog(@"点击头像");
    }else if (clickType == SHMessageClickType_Long){
        NSLog(@"长按头像");
    }
    
}

#pragma mark 重发点击
- (void)repeatClick:(SHCahtMessageTableViewCell *)cell message:(SHMessage *)message{
    [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.message.messageID isEqualToString:message.messageID]) {
            
            [self.dataSource removeObject:obj];
            
            if (obj.showTime && self.dataSource.count > idx) {//如果删除的这一个是有时间的则操作下一个显示时间
                SHMessageFrame *frame = self.dataSource[idx];
                frame.showTime = YES;
                //重新计算高度
                [frame setMessage:frame.message];
                [self.dataSource replaceObjectAtIndex:idx withObject:frame];
                
            }
            
            message.sendTime = [SHFileHelper getCurrentTimeString];
            message.messageState = SHSendMessageType_Delivering;
            [self addMessageWithSHMessage:message];
            
            //模拟环境
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                message.messageState = SHSendMessageType_Successed;
                //添加消息
                [self addMessageWithSHMessage:message];
                //更新界面
                [self refurbishTableViewUIisToBottom:NO];
            });
            
        }
    }];

    

}

#pragma mark 显示长按菜单
- (void)showMenuControllerWithMessage:(SHMessage *)message messageCell:(SHCahtMessageTableViewCell *)cell{
    
    self.selectCell = cell;
    
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyItem:)];
    UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItem:)];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:NO];
    }
    //菜单箭头方向(默认会自动判定)
    menu.arrowDirection = UIMenuControllerArrowDefault;
    //设置位置
    CGFloat menuX;
    if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
        menuX = cell.btnContent.frame.origin.x + cell.btnContent.frame.size.width/2 - 5;
    }else if (message.bubbleMessageType == SHBubbleMessageType_Receiving){
        menuX = cell.btnContent.frame.size.width/2 + 70;
    }
    [menu setTargetRect:CGRectMake(menuX, cell.btnContent.frame.origin.y, 0, 0) inView:cell];
    
    
    switch (message.messageType) {
        case SHMessageBodyType_Text:
            //添加内容
            [menu setMenuItems:[NSArray arrayWithObjects:copyItem, deleteItem, nil]];
            break;
        default:
            //添加内容
            [menu setMenuItems:[NSArray arrayWithObjects:deleteItem, nil]];
            break;
    }
    //显示菜单并且带动画
    [menu setMenuVisible:YES animated:YES];
    //为了保证下一次出现重新配置
    [menu setMenuItems:nil];
    
}

#pragma mark 添加第一响应
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark 复制
- (void)copyItem:(id)btn{
    NSLog(@"复制");
    [UIPasteboard generalPasteboard].string = self.selectCell.messageFrame.message.text;
}

#pragma mark 删除
- (void)deleteItem:(id)btn{
    NSLog(@"删除");
    
    [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop){
        if ([obj.message.messageID isEqual:self.selectCell.messageFrame.message.messageID]) {
            
            //删除数据源
            [self.dataSource removeObject:obj];
            
            if (obj.showTime && self.dataSource.count > idx) {//如果删除的这一个是有时间的、则操作下一个显示时间
                
                SHMessageFrame *frame = self.dataSource[idx];
                frame.showTime = YES;
                //重新计算高度
                [frame setMessage:frame.message];
                [self.dataSource replaceObjectAtIndex:idx withObject:frame];
            }
            *stop = YES;
        }
        
    }];
    
    [self.chatTableView reloadData];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        //发送名片
        [self SHMessageInputView:chatInputView sendCard:self.messageModel.userInfo];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - SHShareMenuViewDelegate
#pragma mark 多媒体内容点击
- (void)didSelecteShareMenuItem:(SHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    NSLog(@"%@===%ld",shareMenuItem.title,(long)index);
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    //设置背景
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"]
                forBarPosition:UIBarPositionAny
                    barMetrics:UIBarMetricsDefault];
    
    switch (index) {
        case 0:
        {
            //打开相册
            [chatInputView openPicLibrary];
        }
            break;
        case 1:
        {
            //打开相机
            [chatInputView openCarema];
        }
            break;
        case 2:
        {
            //打开位置
            [chatInputView openLocation];
        }
            break;
            case 3:
        {
            //打开名片
            [chatInputView openCard];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SHCahtMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[SHCahtMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.delegate = self;
    //设置数据
    [cell setMessageFrame:self.dataSource[indexPath.row]];
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SHMessageFrame *messageFrame = self.dataSource[indexPath.row];
    return messageFrame.cellHeight;
}

#pragma mark SCrollVIewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //收起工具栏
    [self stopToolInput];
    
}

#pragma mark - SHAudioPlayerHelperDelegate

/**
 *  开始播放
 *
 *  @param playerName 播放路径
 */
- (void)didAudioPlayerBeginPlay:(NSString *)playerName{
    for (SHCahtMessageTableViewCell *cell in self.chatTableView.visibleCells) {
        if ([cell.btnContent.message.voicePath isEqualToString:playerName]) {
            [cell.btnContent playVoiceAnimation];
            cell.btnContent.readMarker.hidden = YES;
        }else{
            cell.btnContent.isPlaying = 0;
            [cell.btnContent stopVoiceAnimation];
        }
    }
    
}
/**
 *  结束播放
 *
 *  @param playerName 播放路径
 *  @param error      错误
 */
- (void)didAudioPlayerStopPlay:(NSString *)playerName error:(NSString *)error{
    for (SHCahtMessageTableViewCell *cell in self.chatTableView.visibleCells) {
        if ([cell.btnContent.message.voicePath isEqualToString:playerName]) {
            [cell.btnContent stopVoiceAnimation];
            cell.btnContent.isPlaying = 0;
            cell.btnContent.readMarker.hidden = YES;
        }
    }
    
}
/**
 *  暂停播放
 *
 *  @param playerName 播放路径
 */
- (void)didAudioPlayerPausePlay:(NSString *)playerName{
    for (SHCahtMessageTableViewCell *cell in self.chatTableView.visibleCells) {
        if ([cell.btnContent.message.voicePath isEqualToString:playerName]) {
            [cell.btnContent stopVoiceAnimation];
        }
    }
}

#pragma mark - 界面UI更新
#pragma mark 刷新界面
- (void)refreshData{
    NSLog(@"刷新界面");

}

#pragma mark 添加假数据
- (void)loadMessageData{
    for (int i = 0; i < 1; i++) {
        isInsertTop = YES;
        switch (arc4random() % 4) {
            case 0:
                [self SHMessageInputView:nil sendMessage:@"我是陈胜辉，欢迎来到SHChatMessageUI聊天界面"];
                break;
            case 1:
                [self SHMessageInputView:nil sendPicture:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"]]];
                break;
            case 2:
                [self SHMessageInputView:nil sendPrompt:[NSString stringWithFormat:@"%@抢了你的红包",self.title]];
                break;
            case 3:
                [self SHMessageInputView:nil sendVoiceWithWavPath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"wav"] AmrPath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"amr"] RecordDuration:@"2"];
                break;
            default:
                break;
        }
    }
    
    
}

#pragma mark TableView界面刷新
- (void)refurbishTableViewUIisToBottom:(BOOL)isToBottom{
    
    self.bottomConstraint.constant = kSHHEIGHT - chatInputView.frame.origin.y - CustomNav;
    
    [self.view layoutIfNeeded];
    
    if (isToBottom) {
        //滚到最后一行
        [self tableViewScrollToBottom];
    }

}

#pragma mark InputView界面刷新
- (void)refurbishInputViewUI{
    
    __block CGRect inputViewFrame = chatInputView.frame;
    __block CGRect shareMenuViewFrame = self.shareMenuView.frame;
    
    //判断输入框类型
    switch (chatInputView.textViewInputViewType) {
        case SHInputViewType_Text:{
            //键盘控制
            [chatInputView.textViewInput becomeFirstResponder];
            chatInputView.btnChangeVoiceState.selected = NO;
            //输入框
            [UIView animateWithDuration:AnimateTime animations:^{
                //多媒体菜单
                self.shareMenuView.alpha = 0;
            }];
        }
            break;
        case SHInputViewType_Voice:{
            //键盘控制
            [chatInputView.textViewInput resignFirstResponder];
            chatInputView.btnChangeVoiceState.selected = YES;
            //输入框
            [UIView animateWithDuration:AnimateTime animations:^{
                //多媒体菜单
                self.shareMenuView.alpha = 0;
                //键盘控件高度
                inputViewFrame.origin.y = kSHHEIGHT - kSHInPutHeight - CustomNav;
                chatInputView.frame = inputViewFrame;
            }];
        }
            break;
        case SHInputViewType_Emotion:{
            //键盘控制
            [chatInputView.textViewInput resignFirstResponder];
            //输入框
            [UIView animateWithDuration:AnimateTime animations:^{
                //其他控件
                if (chatInputView.textViewInput.hidden) {
                    chatInputView.textViewInput.hidden = NO;
                    chatInputView.btnVoiceRecord.hidden = YES;
                    chatInputView.btnChangeVoiceState.selected = NO;
                }
                //多媒体菜单
                self.shareMenuView.alpha = !self.shareMenuView.alpha;
                //键盘控件高度
                inputViewFrame.origin.y = kSHHEIGHT - kSHInPutHeight - (self.shareMenuView.alpha?(shareMenuViewFrame.size.height):0) - CustomNav;
                chatInputView.frame = inputViewFrame;
            }];
        }
            break;
        case SHInputViewType_ShareMenu:{
            //键盘控制
            [chatInputView.textViewInput resignFirstResponder];
            
            //输入框
            [UIView animateWithDuration:AnimateTime animations:^{
                //其他控件
                if (chatInputView.textViewInput.hidden) {
                    chatInputView.textViewInput.hidden = NO;
                    chatInputView.btnVoiceRecord.hidden = YES;
                    chatInputView.btnChangeVoiceState.selected = NO;
                }
                
                //多媒体菜单
                self.shareMenuView.alpha = !self.shareMenuView.alpha;
                //键盘控件高度
                inputViewFrame.origin.y = kSHHEIGHT - kSHInPutHeight - (self.shareMenuView.alpha?(shareMenuViewFrame.size.height):0) - CustomNav;
                chatInputView.frame = inputViewFrame;
            }];
        }
            break;
            
        default:
            break;
    }
    //刷新Tableview界面
    [self refurbishTableViewUIisToBottom:YES];
}

#pragma mark 收起工具栏
- (void)stopToolInput{
    
    [chatInputView.textViewInput resignFirstResponder];
    [UIView animateWithDuration:AnimateTime animations:^{
        self.shareMenuView.alpha = 0;
        
        CGRect inputViewFrame = chatInputView.frame;
        //键盘控件高度
        inputViewFrame.origin.y = kSHHEIGHT - kSHInPutHeight - CustomNav;
        chatInputView.frame = inputViewFrame;
        
    }];
    [self refurbishTableViewUIisToBottom:NO];
}

#pragma mark 滚动最后一行
- (void)tableViewScrollToBottom{
    
    if (self.dataSource.count == 0)
        return;
    
    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

#pragma mark - 添加键盘通知
- (void)addKeyboardNote
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 1.显示键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    
    // 2.隐藏键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 键盘通知执行
-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //隐藏多媒体
    self.shareMenuView.alpha = 0;
    
    CGRect newFrame = chatInputView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - CustomNav;
    chatInputView.frame = newFrame;
    
    [self refurbishTableViewUIisToBottom:YES];
    
    [UIView commitAnimations];
    
}

#pragma mark 移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
