//
//  SHChatMessageViewController.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHChatMessageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SHChatMessageTableViewCell.h"
#import "SHAudioPlayerHelper.h"
#import "SHChatMessageLocationViewController.h"
#import "SHMessageInputView.h"

#define kAnimateTime 0.25
#define kPageNum 20

@interface SHChatMessageViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate,
SHMessageInputViewDelegate,//输入框代理
SHShareMenuViewDelegate,//多媒体代理
SHCahtMessageCellDelegate,//cell代理
SHAudioPlayerHelperDelegate//播放音频代理
>
{
    //复制按钮
    UIMenuItem * _copyMenuItem;
    //删除按钮
    UIMenuItem * _deleteMenuItem;
    //转发按钮
    UIMenuItem * _forwardMenuItem;
    //撤回按钮
    UIMenuItem * _recallMenuItem;
}

//下方工具栏
@property (nonatomic, strong) SHMessageInputView *chatInputView;
//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

//点击的消息
@property (nonatomic, strong) SHMessage *selectMessage;

//聊天View
@property (nonatomic, strong) UITableView *chatTableView;
//未读控件
@property (nonatomic, strong) UIButton *unReadBtn;

//背景图
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation SHChatMessageViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化各个参数
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [[NSMutableArray alloc]init];
    
    //去除下划线
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.backgroundColor = [UIColor clearColor];

    //绘制UI
    [self setup];
}

#pragma mark - SET
- (void)setChatId:(NSString *)chatId{
    
    _chatId = [NSString stringWithFormat:@"%@",chatId];
}

#pragma mark - 绘制UI
- (void)setup{
    
    //添加键盘监听
    [self addKeyboardNote];
    //配置多媒体视图
    [self setShareMenuUI];
    //配置未读控件
    [self setUnRead];
    
    //添加下方输入框
    [self.view addSubview:self.chatInputView];
    
    //滑到最下方
    [self tableViewScrollToBottom];
}

#pragma mark - 设置界面属性
- (void)setUIProperty{

    self.title = self.chatId;
    self.bgImageView.image = [UIImage imageNamed:@"chatBg_3.jpg"];
}

#pragma mark - 导航栏按钮
#pragma mark 左上角点击
- (void)leftClick {

    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 右上角点击


#pragma mark - 发送消息
#pragma mark 发送文本
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendMessage:(NSString *)message{

    SHMessage *model = [[SHMessage alloc]init];
    model.messageType = SHMessageBodyType_Text;
    model.text = message;
    
    //添加公共配置
    model = [SHMessageHelper addPublicParameterWidthSHMessage:model];
    
    //添加消息前的条件判断
    [self conditionMessageWithSHMessage:model isToBottom:YES];
}

#pragma mark 发送图片
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendPicture:(NSString *)imagePath imageSize:(CGSize)imageSize{
    
    SHMessage *model = [[SHMessage alloc]init];
    model.messageType = SHMessageBodyType_Image;
    model.imagePath = imagePath;
    model.imageWidth = imageSize.width;
    model.imageHeight = imageSize.height;
    //添加公共配置
    model = [SHMessageHelper addPublicParameterWidthSHMessage:model];
    
    //添加消息前的条件判断
    [self conditionMessageWithSHMessage:model isToBottom:YES];
}

#pragma mark 发送视频
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendVideo:(NSString *)videoPath{
    
    SHMessage *model = [[SHMessage alloc]init];
    model.messageType = SHMessageBodyType_Video;
    model.videoUrl = videoPath;

    //添加公共配置
    model = [SHMessageHelper addPublicParameterWidthSHMessage:model];
    
    //添加消息前的条件判断
    [self conditionMessageWithSHMessage:model isToBottom:YES];
}

#pragma mark 发送语音
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendVoice:(NSString *)wavPath AmrPath:(NSString *)amrPath RecordDuration:(NSString *)recordDuration{
    
    SHMessage *model = [[SHMessage alloc]init];
    model.messageType = SHMessageBodyType_Voice;
    model.voiceUrl = amrPath;
    model.voiceDuration = recordDuration;
    
    //添加公共配置
    model = [SHMessageHelper addPublicParameterWidthSHMessage:model];
    
    //添加消息前的条件判断
    [self conditionMessageWithSHMessage:model isToBottom:YES];
    
}

#pragma mark 发送位置
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendLocation:(NSString *)locationName Lon:(CGFloat)lon Lat:(CGFloat)lat{
    
    SHMessage *model = [[SHMessage alloc]init];
    model.messageType = SHMessageBodyType_Location;
    model.locationName = locationName;
    model.lon = lon;
    model.lat = lat;

    //添加公共配置
    model = [SHMessageHelper addPublicParameterWidthSHMessage:model];
    
    //添加消息前的条件判断
    [self conditionMessageWithSHMessage:model isToBottom:YES];
    
}

#pragma mark 发送名片信息
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendCard:(NSString *)card{
    
    SHMessage *model = [[SHMessage alloc]init];
    model.messageType = SHMessageBodyType_Card;
    model.card = card;
    
    //添加公共配置
    model = [SHMessageHelper addPublicParameterWidthSHMessage:model];
    
    //添加消息前的条件判断
    [self conditionMessageWithSHMessage:model isToBottom:YES];
}

#pragma mark 发送提示消息
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendPrompt:(NSString *)prompt{
    
    SHMessage *model = [[SHMessage alloc]init];
    model.messageType = SHMessageBodyType_Note;
    model.promptContent = prompt;

    //添加公共配置
    model = [SHMessageHelper addPublicParameterWidthSHMessage:model];
    
    //添加消息前的条件判断
    [self conditionMessageWithSHMessage:model isToBottom:YES];
    
}

#pragma mark 发送红包消息
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendRedPackage:(NSString *)redPackage{
    
    SHMessage *model = [[SHMessage alloc]init];
    model.messageType = SHMessageBodyType_RedPaper;
    model.redPackage = redPackage;
    
    //添加公共配置
    model = [SHMessageHelper addPublicParameterWidthSHMessage:model];
    
    //添加消息前的条件判断
    [self conditionMessageWithSHMessage:model isToBottom:YES];
}

#pragma mark 发送Gif消息
- (void)chatMessageInputView:(SHMessageInputView *)inputView sendGif:(NSString *)gifPath gifSize:(CGSize)gifSize{
    
    SHMessage *model = [[SHMessage alloc]init];
    model.messageType = SHMessageBodyType_Gif;
    model.gifWidth = gifSize.width;
    model.gifHeight = gifSize.height;
    model.gifUrl = gifPath;
    
    //添加公共配置
    model = [SHMessageHelper addPublicParameterWidthSHMessage:model];
    //添加消息前的条件判断
    [self conditionMessageWithSHMessage:model isToBottom:YES];
}

#pragma mark - 添加聊天消息消息
#pragma mark 条件判断
- (void)conditionMessageWithSHMessage:(SHMessage *)message isToBottom:(BOOL)isToBottom{

    //添加消息到聊天界面
    [self addMessageWithSHMessage:message isToBottom:isToBottom];
    
    if (message.messageState == SHSendMessageType_Delivering && message.bubbleMessageType == SHBubbleMessageType_Sending) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            message.messageState = SHSendMessageType_Failed;
            //添加消息到聊天界面
            [self addMessageWithSHMessage:message isToBottom:isToBottom];
        });
    }
}

#pragma mark 添加消息到聊天界面
- (void)addMessageWithSHMessage:(SHMessage *)message isToBottom:(BOOL)isToBottom{

    //设置发送类型
    message.chatType = self.chatType;
    
    //设置聊天ID
    message.chatId = self.chatId;
    
    //刷新数据
    dispatch_async(dispatch_get_main_queue(), ^{
            
        //聊天数据处理
        SHMessageFrame *messageFrame = [self getMessageFrameWirhMessage:message DataSoure:self.dataSource];
        
        if (messageFrame){
            
            [self.dataSource addObject:messageFrame];
        }
        
        [self.chatTableView reloadData];
        //更新界面
        [self refurbishTableViewUIisToBottom:isToBottom];
    });
}

#pragma mark - 删除聊天消息消息
- (void)deleteChatMessageWithMessageId:(NSString *)messageId{
    //删除此条消息
    [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop){
        
        if ([obj.message.messageId isEqual:messageId]) {
            
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
}

#pragma mark - 聊天数据处理
#pragma mark 聊天数据处理(同一条消息：同一个时间做刷新、不同则删除)
- (SHMessageFrame *)getMessageFrameWirhMessage:(SHMessage *)message DataSoure:(NSMutableArray *)dataSoure{
    
    SHMessageFrame *messageFrame = [[SHMessageFrame alloc]init];
    
    //是否显示用户名
    if (self.chatType == SHChatType_GroupChat){
        if (message.bubbleMessageType == SHBubbleMessageType_Receiving) {//群聊、接收方
            messageFrame.showName = YES;
        }
    }

    //是否需要添加
    __block BOOL isAdd = NO;
    [dataSoure enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([message.messageId isEqualToString:obj.message.messageId]) {//同一条消息
            if ([message.sendTime isEqualToString:obj.message.sendTime]) {//时间相同做刷新
                
                isAdd = YES;
                messageFrame.showTime = obj.showTime;
                [messageFrame setMessage:message];
                [dataSoure replaceObjectAtIndex:idx withObject:messageFrame];
            }else{//时间不同做添加
                
                [dataSoure removeObject:obj];
            }
            *stop = YES;
        }
    }];
    
    if (!isAdd) {
        //判断与上一个时间间隔
        SHMessageFrame *messageFrameOneMore = [dataSoure lastObject];

        messageFrame.showTime = [SHMessageTimeHelper isShowMessageTimeWithOnTime:messageFrameOneMore.message.sendTime ThisTime:message.sendTime];
        
        [messageFrame setMessage:message];
        
        return messageFrame;
    }else{
        return nil;
    }
}

#pragma mark - 配置视图
#pragma mark 配置未读控件
- (void)setUnRead{
    
    NSString *unRead = @"22";
    
    if ([unRead intValue] > kPageNum) {//只有大于一屏的时候才显示未读控件
    
        self.unReadBtn.tag = [unRead intValue] - kPageNum;
        if ([unRead intValue] > 99) {
            unRead = @"99+";
        }
        [self.unReadBtn setTitle:[NSString stringWithFormat:@"%@ 条新消息 ",unRead] forState:0];
        [self.view addSubview:self.unReadBtn];
    }
}
#pragma mark 配置多媒体视图
- (void)setShareMenuUI{
    
    if (!self.chatInputView.shareMenuItems.count) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            //配置多媒体按钮
            NSArray *shareMenuItem;
            //获取聊天消息
            switch (self.chatType) {
                case SHChatType_Chat://单聊
                {
                    shareMenuItem = @[
                                       @{ @"sharemore_location.png":@"位置"},
                                       @{ @"sharemore_card.png":@"名片"},
                                       @{ @"sharemore_graffiti.png":@"涂鸦"},
                                       @{ @"sharemore_redpackage.png":@"红包"},
                                    @{ @"sharemore_background.png":@"背景图"},
                                       @{ @"sharemore_tel.png":@"打电话"}];
                }
                    break;
                case SHChatType_GroupChat://群聊
                {
                    shareMenuItem = @[@{ @"sharemore_location.png":@"位置"},
                                       @{ @"sharemore_card.png":@"名片"},
                                       @{ @"sharemore_graffiti.png":@"涂鸦"},
                                       @{ @"sharemore_redpackage.png":@"红包"},
                                       @{ @"sharemore_background.png":@"背景图"}];
                }
                    break;
                case SHChatType_Public://公众号
                {
                    shareMenuItem = @[@{ @"sharemore_graffiti.png":@"涂鸦"}];
                }
                    break;
                default:
                    break;
            }
            
            // 添加第三方接入数据
            NSMutableArray *shareMenuItems = [NSMutableArray array];
            
            //配置Item按钮
            [shareMenuItem enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop)  {
                
                SHShareMenuItem *shareMenuItem = [[SHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:obj.allKeys[0]] title:obj.allValues[0]];
                shareMenuItem.titleFont = [UIFont systemFontOfSize:12];
                [shareMenuItems addObject:shareMenuItem];
            }];
            
            //配置视图
            self.chatInputView.shareMenuItems = shareMenuItems;
            //代理
            self.chatInputView.shareMenuView.delegate = self;
            //刷新界面
            [self.chatInputView.shareMenuView reloadData];
        });
    }
   
}

#pragma mark - SHCahtMessageCellDelegate
#pragma mark 消息体点击
- (void)contentClick:(SHChatMessageTableViewCell *)cell message:(SHMessage *)message clickType:(SHMessageClickType)clickType{
    
    //收起工具栏
    [self hiddenToolInput];
    
    UIViewController *view;
    
    //进行赋值
    self.selectMessage = message;
    
    switch (clickType) {
        case SHMessageClickType_Click:
        {
            NSLog(@"点击消息");
            //判断消息类型
            switch (message.messageType) {
                case SHMessageBodyType_Image://图片
                {
                    message.messageRead = YES;
                    if (cell.btnContent.imageMessageView) {
                        
 
                    }
                }
                    break;
                case SHMessageBodyType_Voice://语音
                {
                    SHAudioPlayerHelper *audio = [SHAudioPlayerHelper shareInstance];
                    audio.delegate = self;
                    
                    if (cell.btnContent.isPlaying) {
                        //正在播放
                        cell.btnContent.isPlaying = NO;
                        [audio stopAudio];//停止
                    }else{
                        //未播放
                        cell.btnContent.isPlaying = YES;
                        
                        NSMutableArray *arr = [[NSMutableArray alloc]init];
                        
                        if (!message.messageRead) {//点击的消息为未读、则开始进行队列播放（需要判断开关）
                            
                            __block NSInteger index = -1;
                            
                            [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                
                                if (message.messageType == SHMessageBodyType_Voice) {//语音消息
                                    if ([obj.message.messageId isEqualToString:message.messageId]) {//找到此条信息
                                        index = idx;
                                    }
                                    
                                    if (idx >= index) {//去查找下方数据
                                        
                                        if (!obj.message.messageRead) {//未读
                                            [arr addObject:obj.message];
                                        }
                                    }
                                }
                            }];
                            
                        }else{//否则只读一条
                            
                            [arr addObject:message];
                        }
                        
                        [audio managerAudioWithFileArr:arr isClear:YES];
                    }
                }
                    break;
                case SHMessageBodyType_Location://位置
                {
                    message.messageRead = YES;
                    //跳转地图界面
                    SHChatMessageLocationViewController *location = [[SHChatMessageLocationViewController alloc]init];
                    location.message = message;
                    location.locationType = SHMessageLocationType_Look;
                    
                    view = location;
                }
                    break;
                case SHMessageBodyType_Video://视频
                {
                    message.messageRead = YES;
                    
                    //本地路径
                    NSString *videoPath = [NSString stringWithFormat:@"%@/%@",kSHVideoPath,message.videoUrl.lastPathComponent];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {//如果本地路径存在
                        
                        [SHMessageVideoHelper playVideoWithVideoUrl:[NSURL fileURLWithPath:videoPath] SupVc:self];
                    }else {//进行下载
              
                    }
                }
                    break;
                case SHMessageBodyType_Card://名片
                {
                    message.messageRead = YES;
                
                }
                    break;
                case SHMessageBodyType_RedPaper://红包
                {
                    message.messageRead = YES;

                }
                    break;
                case SHMessageBodyType_Burn://阅后即焚
                {

                }
                    break;
                case SHMessageBodyType_Phone://通话
                {
       
                }
                    break;
                case SHMessageBodyType_VoiceEmail://语音信箱
                {
                    SHAudioPlayerHelper *audio = [SHAudioPlayerHelper shareInstance];
                    audio.delegate = self;
                    
                    if (cell.btnContent.voiceEmailIsPlaying) {
                        //正在播放
                        cell.btnContent.voiceEmailIsPlaying = NO;
                        [audio stopAudio];//停止
                    }else{
                        //未播放
                        cell.btnContent.voiceEmailIsPlaying = YES;
                        
                        [audio managerAudioWithFileArr:@[message] isClear:YES];
                    }
                }
                    break;
                case SHMessageBodyType_Gif://Gif
                {

                }
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
            break;
        default:
            break;
    }
    
    if (view) {
        [self.navigationController pushViewController:view animated:YES];
    }
}

#pragma mark 头像点击
- (void)headImageClick:(SHChatMessageTableViewCell *)cell message:(SHMessage *)message clickType:(SHMessageClickType )clickType{
    
    if (clickType == SHMessageClickType_Click) {
        
        NSLog(@"点击头像");
        
    }else if (clickType == SHMessageClickType_Long){
        
        NSLog(@"长按头像");
        if (self.chatType == SHChatType_GroupChat) {
            
            if (message.bubbleMessageType == SHBubbleMessageType_Receiving) {//群聊、接收方存在@功能
                
                self.chatInputView.textViewInput.text = [NSString stringWithFormat:@"%@@%@ ",self.chatInputView.textViewInput.text,message.userName];
            }
        }
    }
}

#pragma mark 重发点击
- (void)repeatClick:(SHChatMessageTableViewCell *)cell message:(SHMessage *)message{
    
    [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.message.messageId isEqualToString:message.messageId]) {
            
            [self.dataSource removeObject:obj];
            
            if (obj.showTime && self.dataSource.count > idx) {//如果删除的这一个是有时间的则操作下一个显示时间
                
                SHMessageFrame *frame = self.dataSource[idx];
                frame.showTime = YES;
                //重新计算高度
                [frame setMessage:frame.message];
                [self.dataSource replaceObjectAtIndex:idx withObject:frame];
            }
            
            //添加公共配置
            SHMessage *model = [SHMessageHelper addPublicParameterWidthSHMessage:message];
            
            //重发将状态修改
            self.chatInputView.isBurn = NO;
            
            //模拟数据
            model.messageState = SHSendMessageType_Delivering;
            model.bubbleMessageType = SHBubbleMessageType_Sending;
            
            //添加消息到聊天界面
            [self addMessageWithSHMessage:message isToBottom:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //模拟数据
                model.messageState = SHSendMessageType_Successed;
                
                //添加消息到聊天界面
                [self addMessageWithSHMessage:message isToBottom:YES];
            });
        }
    }];

}

#pragma mark 显示长按菜单
- (void)showMenuControllerWithMessage:(SHMessage *)message messageCell:(SHChatMessageTableViewCell *)cell{
    
    self.selectMessage = message;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:NO];
    }
    //菜单箭头方向(默认会自动判定)
    menu.arrowDirection = UIMenuControllerArrowDefault;
    //设置位置
    CGFloat menuX = 0;
    if (message.bubbleMessageType == SHBubbleMessageType_Sending) {
        menuX = cell.btnContent.frame.origin.x + cell.btnContent.frame.size.width/2 - 5;
    }else if (message.bubbleMessageType == SHBubbleMessageType_Receiving){
        menuX = cell.btnContent.frame.size.width/2 + 70;
    }
    [menu setTargetRect:CGRectMake(menuX, cell.btnContent.frame.origin.y, 0, 0) inView:cell];
    
    //设置菜单内容
    //初始化列表
    if (!_copyMenuItem) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyItem:)];
    }
    if (!_deleteMenuItem) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItem:)];
    }
    if (!_forwardMenuItem) {
        _forwardMenuItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardItem:)];
    }
    if (!_recallMenuItem) {
        _recallMenuItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(recallItem:)];
    }
    NSMutableArray *menuItemArr = [[NSMutableArray alloc]init];
    //添加删除
    [menuItemArr addObject:_deleteMenuItem];
    
    //复制
    if (message.messageType == SHMessageBodyType_Text) {//文本有复制
        //添加复制
        [menuItemArr addObject:_copyMenuItem];
    }
    
    //转发
    if (message.messageType != SHMessageBodyType_RedPaper && message.messageType != SHMessageBodyType_Burn) {//红包、阅后即焚没有转发
        //添加转发
        [menuItemArr addObject:_forwardMenuItem];
    }
    
    //添加内容
    [menu setMenuItems:menuItemArr];
    
    //显示菜单并且带动画
    [menu setMenuVisible:YES animated:YES];
    //为了保证下一次出现重新配置
    [menu setMenuItems:nil];
}

#pragma mark 添加第一响应
- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - 菜单点击
#pragma mark 复制
- (void)copyItem:(id)btn{
    NSLog(@"复制");
    [UIPasteboard generalPasteboard].string = self.selectMessage.text;
}

#pragma mark 删除
- (void)deleteItem:(id)btn{
    NSLog(@"删除");
    
    //删除消息
    [self deleteChatMessageWithMessageId:self.selectMessage.messageId];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatTableView reloadData];
    });
}

#pragma mark 转发
- (void)forwardItem:(id)btn{
    NSLog(@"转发");
}

#pragma mark 撤回
- (void)recallItem:(id)btn{
    NSLog(@"撤回");
}

#pragma mark - SHShareMenuViewDelegate
#pragma mark 多媒体内容点击
- (void)didSelecteShareMenuItem:(SHShareMenuItem *)shareMenuItem atIndex:(NSInteger)index{
    
    NSLog(@"%@===%ld",shareMenuItem.title,(long)index);

    //收起工具栏
    [self hiddenToolInput];
    
    if ([shareMenuItem.title isEqualToString:@"打电话"]){

        return;
    }
    
    if ([shareMenuItem.title isEqualToString:@"位置"]) {
        //打开位置
        [self.chatInputView openLocation];
    }else if ([shareMenuItem.title isEqualToString:@"名片"]){
        //打开名片
        [self.chatInputView openCard];
    }else if ([shareMenuItem.title isEqualToString:@"涂鸦"]){
        //打开涂鸦
        [self.chatInputView openGraffiti];
    }else if ([shareMenuItem.title isEqualToString:@"红包"]){
        //打开红包
        [self.chatInputView openRedPaper];
    }else if ([shareMenuItem.title isEqualToString:@"背景图"]){
        //打开背景图
        [self.chatInputView openBackground];
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
    
    SHChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        
        cell = [[SHChatMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.delegate = self;
    }
    
    //设置数据
    cell.messageFrame = self.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SHMessageFrame *messageFrame = self.dataSource[indexPath.row];
    return messageFrame.cellHeight;
}

#pragma mark SCrollVIewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //收起工具栏
    [self hiddenToolInput];
    
}

#pragma mark - SHAudioPlayerHelperDelegate
#pragma mark 语音开始播放
- (void)didAudioPlayerBeginPlay:(NSString *)playerName{
    
    __block SHChatMessageTableViewCell *cell;
    
    [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
 
        cell = [self.chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        
        if ([obj.message.messageId isEqualToString:playerName]) {//找到此条数据
            
            [cell.btnContent playVoiceAnimation];
            self.selectMessage = obj.message;
            
            cell.btnContent.readMarker.hidden = YES;
            
            if (!obj.message.messageRead) {
                cell.messageFrame.message.messageRead = YES;
                obj.message.messageRead = YES;
            }
        }else{
        
            switch (obj.message.messageType) {
                case SHMessageBodyType_VoiceEmail://语音信箱
                {
                    cell.btnContent.voiceEmailIsPlaying = NO;
                    [cell.btnContent stopVoiceAnimation];
                }
                    break;
                case SHMessageBodyType_Voice://语音
                {
                    cell.btnContent.isPlaying = NO;
                    [cell.btnContent stopVoiceAnimation];
                }
                    break;
                default:
                    break;
            }
        }
    }];
}

#pragma mark 语音结束播放
- (void)didAudioPlayerStopPlay:(NSString *)playerName error:(NSString *)error{
    
    for (SHChatMessageTableViewCell *cell in self.chatTableView.visibleCells) {
        
        if ([cell.messageFrame.message.messageId isEqualToString:playerName]) {
            
            [cell.btnContent stopVoiceAnimation];
            cell.btnContent.readMarker.hidden = YES;
            
            switch (cell.messageFrame.message.messageType) {
                case SHMessageBodyType_VoiceEmail://语音信箱
                {
                    cell.btnContent.voiceEmailIsPlaying = NO;
                }
                    break;
                case SHMessageBodyType_Voice://语音
                {
                    cell.btnContent.isPlaying = NO;
                }
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark 语音暂停播放
- (void)didAudioPlayerPausePlay:(NSString *)playerName{
    
    for (SHChatMessageTableViewCell *cell in self.chatTableView.visibleCells) {

        if ([cell.btnContent.message.messageId isEqualToString:playerName]) {
            [cell.btnContent stopVoiceAnimation];
        }
    }
}

#pragma mark - 下方工具栏的出现与消失
- (void)toolbarWithIsShow:(BOOL)isShow{
    [self refurbishTableViewUIisToBottom:isShow];
}

#pragma mark - 懒加载
#pragma mark 背景图片
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        //设置背景
        _bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _bgImageView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bgImageView];
        [self.view sendSubviewToBack:_bgImageView];
    }
    return _bgImageView;
}

#pragma mark 下方输入框
- (SHMessageInputView *)chatInputView{
    
    if (!_chatInputView) {
        _chatInputView = [[SHMessageInputView alloc]initWithFrame:CGRectMake(0,kSHHEIGHT - kSHInPutHeight, kSHWIDTH, kSHInPutHeight) ChatId:self.chatId SuperVC:self Type:self.chatType];
        _chatInputView.delegate = self;
    }
    return _chatInputView;
    
}

#pragma mark 聊天界面
- (UITableView *)chatTableView{
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SHWidth, SHHeight - 64 - kSHInPutHeight) style:UITableViewStylePlain];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        [self.view addSubview:_chatTableView];
    }
    return _chatTableView;
}

#pragma mark 未读按钮
- (UIButton *)unReadBtn{
    if (!_unReadBtn) {
        _unReadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _unReadBtn.frame = CGRectMake(SHWidth - 135, 20 + 64, 135, 35);
        
        _unReadBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_unReadBtn setTitleColor:[UIColor redColor] forState:0];
        [_unReadBtn setBackgroundImage:[UIImage imageNamed:@"unread_bg.png"] forState:0];
        [_unReadBtn addTarget:self action:@selector(unReadClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _unReadBtn;
}

#pragma mark 未读按钮点击
- (void)unReadClick:(UIButton *)btn{
    
    //界面滚动到指定位置
    [self tableViewScrollToIndex:0];
    
    [self.unReadBtn removeFromSuperview];
  
}

#pragma mark - 界面UI更新
#pragma mark TableView界面刷新
- (void)refurbishTableViewUIisToBottom:(BOOL)isToBottom{
    
    self.chatTableView.height = self.chatInputView.frame.origin.y - 64;
    
    [self.view layoutIfNeeded];
    
    if (isToBottom) {
        //滚到最后一行
        [self tableViewScrollToBottom];
    }
}


#pragma mark 收起工具栏
- (void)hiddenToolInput{
    
   __block CGRect inputViewFrame = self.chatInputView.frame;
    
    self.chatInputView.photoPicker.alpha = 0;
    self.chatInputView.shareMenuView.alpha = 0;
    self.chatInputView.emotionKeyboard.alpha = 0;
    
    [UIView animateWithDuration:kAnimateTime animations:^{
        
        //键盘控制
        [self.chatInputView.textViewInput resignFirstResponder];
        //键盘控件高度
        inputViewFrame.origin.y = kSHHEIGHT - kSHInPutHeight - kCustomNav;
        
        self.chatInputView.frame = inputViewFrame;
 
    }];
    [self refurbishTableViewUIisToBottom:NO];
}


#pragma mark 滚动最后一行
- (void)tableViewScrollToBottom{
    
    @synchronized (self.dataSource) {
        if (self.dataSource.count) {
            //界面滚动到指定位置
            [self tableViewScrollToIndex:self.dataSource.count - 1];
        }
    }
}

#pragma mark 界面滚动到指定位置
- (void)tableViewScrollToIndex:(NSInteger)index{
    
    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - 键盘通知
#pragma mark 添加键盘通知
- (void)addKeyboardNote {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // 1.显示键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    
    // 2.隐藏键盘
    [center addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘通知执行
- (void)keyboardChange:(NSNotification *)notification {
    
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
    
    CGRect newFrame = self.chatInputView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - kCustomNav;
    
    self.chatInputView.frame = newFrame;
    
    [self refurbishTableViewUIisToBottom:YES];
    
    [UIView commitAnimations];
}

#pragma mark - VC界面周期函数
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //设置界面属性
    [self setUIProperty];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.unReadBtn removeFromSuperview];
    //音频销毁
    [[SHAudioPlayerHelper shareInstance] deallocAudio];
    
    //停止播放动画
    if (self.selectMessage.messageType == SHMessageBodyType_Voice) {
        
        [self.dataSource enumerateObjectsUsingBlock:^(SHMessageFrame *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.message.messageType == SHMessageBodyType_Voice) {//语音消息
                
                SHChatMessageTableViewCell *cell = [self.chatTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                
                if ([obj.message.messageId isEqualToString:self.selectMessage.messageId]) {//找到此条数据
                    cell.btnContent.isPlaying = NO;
                    [cell.btnContent stopVoiceAnimation];
                    
                    *stop = YES;
                }
            }
        }];

    }
    
    self.selectMessage = nil;
}

#pragma mark 移除通知
- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
