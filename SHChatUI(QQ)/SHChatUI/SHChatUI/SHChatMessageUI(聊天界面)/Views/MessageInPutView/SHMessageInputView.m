//
//  SHMessageInputView.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHMessageInputView.h"
#import <AVFoundation/AVFoundation.h>
#import "SHMessageMacroHeader.h"
#import "SHVoiceRecordHelper.h"
#import "SHMessageVoiceHUD.h"
#import "SHChatMessageLocationViewController.h"
#import "SHMessageVideoHelper.h"

#define kCustomNav 0
#define kAnimateTime 0.25

@interface SHMessageInputView ()<
UITextViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
SHVoiceRecordHelperDelegate,//音频代理
SHEmotionKeyboardDelegate,//表情代理
SHLocationDelegate//定位代理
> {
    SHVoiceRecordHelper *voiceRecordHelper;
    CGFloat playTime;
    NSTimer *playTimer;
    SHChatType _type;
    //下方工具栏
    UIView *inputToolView;
}

//下方Btn按钮数组
@property (nonatomic, strong) NSMutableArray *btnArr;
//当前的工具类型
@property (nonatomic, assign) SHInputViewType inputViewType;

//输入框改变高度
@property (nonatomic, assign) CGFloat textHeight;

//当前跟视图
@property (nonatomic, assign) UIViewController *superVC;
//当前聊天用户ID
@property (nonatomic, retain) NSString *chatId;

@end

@implementation SHMessageInputView

- (SHMessageInputView *)initWithFrame:(CGRect)frame ChatId:(NSString *)chatId SuperVC:(UIViewController *)superVC Type:(SHChatType )type {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.superVC = superVC;
        self.chatId = chatId;
        _type = type;
        
        //绘制界面
        [self setup];
    }
    return self;
}


#pragma mark -  SET
- (void)setIsBurn:(BOOL)isBurn{
    _isBurn = isBurn;
    
    //阅后即焚处理
    for (int i = 0; i < self.btnArr.count; i++) {
        
        UIButton *obj = (UIButton *)self.btnArr[i];
        
        if (obj.tag == 11) {//阅后即焚
            obj.selected = isBurn;
            inputToolView.layer.borderColor = isBurn?[UIColor redColor].CGColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
        }else if (obj.tag == 15){
            obj.selected = isBurn;
        }
        
        [self.btnArr replaceObjectAtIndex:i withObject:obj];
    }
}

#pragma mark - 绘制界面
- (void)setup{
    
    self.backgroundColor = InPutViewColor;
    //分割线
    self.layer.cornerRadius = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
    self.layer.borderWidth = 0.4;
    
    //设置代理
    voiceRecordHelper = [[SHVoiceRecordHelper alloc]initWithDelegate:self];
    
    self.emotionKeyboard = nil;
    
    //上方输入栏
    inputToolView = [[UIView alloc]initWithFrame:CGRectMake(kSHInPut_X, kSHInPutSpace, SHWidth - 2*kSHInPut_X, kSHInPutTextHeight)];
    
    inputToolView.layer.cornerRadius = 4;
    inputToolView.layer.masksToBounds = YES;
    inputToolView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    inputToolView.layer.borderWidth = 1;
    [self addSubview:inputToolView];
    
    //输入框
    self.textViewInput = [[UITextView alloc]initWithFrame:inputToolView.bounds];
    self.textViewInput.delegate = self;
    self.textViewInput.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    //按钮样子
    self.textViewInput.returnKeyType = UIReturnKeySend;
    //UITextView内部判断send按钮是否可以用
    self.textViewInput.enablesReturnKeyAutomatically = YES;
    [inputToolView addSubview:self.textViewInput];
    
    //语音按钮
    self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnVoiceRecord.frame = self.textViewInput.frame;
    self.btnVoiceRecord.hidden = YES;
    //文字颜色
    [self.btnVoiceRecord setTitleColor:RGB(76, 76, 76, 1) forState:UIControlStateNormal];
    [self.btnVoiceRecord setTitleColor:RGB(76, 76, 76, 1) forState:UIControlStateHighlighted];
    //文字内容
    [self.btnVoiceRecord setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.btnVoiceRecord setTitle:@"松开发送" forState:UIControlStateHighlighted];
    //点击方式
    [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
    [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [inputToolView addSubview:self.btnVoiceRecord];
    
    //初始化
    self.btnArr = [[NSMutableArray alloc]init];
    //设置下方按钮
    CGFloat View_X = (SHWidth/6 - kSHInPutItemWH)/2;
    int num = 5;
    if (_type == SHChatType_Chat) {//单聊
        num = 6;
    }
    
    //输入框下方多媒体按钮
    for (int i = 0; i < num; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 10 + i;
        
        btn.frame = CGRectMake(View_X, self.textViewInput.maxY + 2*kSHInPutSpace + 3, kSHInPutItemWH, kSHInPutItemWH);
        View_X = View_X + SHWidth/num;
        
        NSString *imageName;
        
        //设置工具栏样式
        switch (_type) {
            case SHChatType_Chat://单聊
            {
                //设置按钮图片
                switch (i) {
                    case 0://语音
                    {
                        imageName = @"chat_voice.png";
                        //改变状态（语音、文字）
                        [btn setImage:[UIImage imageNamed:@"chat_keyboard.png"] forState:UIControlStateSelected];;
                        View_X = View_X - 5;
                    }
                        break;
                    case 1://阅后即焚
                    {
                        imageName = @"chat_burn.png";
                        [btn setImage:[UIImage imageNamed:@"chat_burn_HL.png"] forState:UIControlStateSelected];
                    }
                        break;
                    case 2://图片
                        imageName = @"chat_picture.png";
                        
                        View_X = View_X + 5;
                        break;
                    case 3://相机
                        imageName = @"chat_camera.png";
                        View_X = View_X + 5;
                        break;
                    case 4://表情
                        imageName = @"chat_face.png";
                        View_X = View_X - 5;
                        break;
                    case 5://多媒体更多
                    {
                        imageName = @"chat_more.png";
                        [btn setImage:[UIImage imageNamed:@"chat_more_HL.png"] forState:UIControlStateSelected];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case SHChatType_GroupChat://群聊
            {
                //设置按钮图片
                switch (i) {
                    case 0://语音
                    {
                        imageName = @"chat_voice.png";
                        //改变状态（语音、文字）
                        [btn setImage:[UIImage imageNamed:@"chat_keyboard.png"] forState:UIControlStateSelected];;
                    }
                        break;
                    case 1://图片
                        imageName = @"chat_picture.png";
                        break;
                    case 2://相机
                        imageName = @"chat_camera.png";
                        break;
                    case 3://表情
                        imageName = @"chat_face.png";
                        break;
                    case 4://多媒体更多
                    {
                        imageName = @"chat_more.png";
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case SHChatType_Public://公众号
            {
                //设置按钮图片
                switch (i) {
                    case 0://语音
                    {
                        imageName = @"chat_voice.png";
                        //改变状态（语音、文字）
                        [btn setImage:[UIImage imageNamed:@"chat_keyboard.png"] forState:UIControlStateSelected];;
                    }
                        break;
                    case 1://图片
                        imageName = @"chat_picture.png";
                        break;
                    case 2://相机
                        imageName = @"chat_camera.png";
                        break;
                    case 3://表情
                        imageName = @"chat_face.png";
                        break;
                    case 4://多媒体更多
                    {
                        imageName = @"chat_more.png";
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
        
        [btn setImage:[UIImage imageNamed:imageName] forState:0];
        
        //添加点击方法
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = NO;
        
        [self addSubview:btn];
        //添加到数组
        [self.btnArr addObject:btn];
    }
}

//#pragma mark - SET
//- (void)setTextViewWithHeight:(CGFloat)height{
//    
//    CGFloat offSize = kSHInPutToolH + 2*kSHInPutSpace + height - self.height;
//    self.height = kSHInPutToolH + 2*kSHInPutSpace + height;
//    self.y = self.y - offSize;
//}
//
//- (void)setFrame:(CGRect)frame{
//    [super setFrame:frame];
//    
//    inputToolView.height = frame.size.height - 2*kSHInPutSpace - kSHInPutTextHeight;
//    self.textViewInput .height = inputToolView.height;
//    
//    for (UIButton *btn in self.btnArr) {
//        btn.y =  self.textViewInput.maxY + 2*kSHInPutSpace + 3;
//    }
//}

#pragma mark 自定义多媒体菜单
- (SHShareMenuView *)shareMenuView {
    CGFloat shareMenuView_H;
    //计算多媒体菜单高度
    if (self.shareMenuItems.count <= kSHShareMenuPerRowItemCount) {
        shareMenuView_H = 2*KSHShareMenuItemTop + KSHShareMenuItemHeight;
        
    }else if (self.shareMenuItems.count <= kSHShareMenuPerRowItemCount*kSHShareMenuPerColum){
        shareMenuView_H = (KSHShareMenuItemTop + KSHShareMenuItemHeight)*kSHShareMenuPerColum + KSHShareMenuItemTop;
        
    }else{
        shareMenuView_H = (KSHShareMenuItemTop + KSHShareMenuItemHeight)*kSHShareMenuPerColum + kSHShareMenuPageControlHeight;
    }
    
    if (!_shareMenuView) {
        
        SHShareMenuView *shareMenuView = [[SHShareMenuView alloc] initWithFrame:CGRectMake(0, kSHHEIGHT - shareMenuView_H - kCustomNav, CGRectGetWidth(self.superVC.view.bounds), shareMenuView_H)];
        shareMenuView.alpha = 0;
        [self.superVC.view addSubview:shareMenuView];
        _shareMenuView = shareMenuView;
        
    }
    
    return _shareMenuView;
}

- (void)setShareMenuItems:(NSArray *)shareMenuItems{
    _shareMenuItems = shareMenuItems;
    self.shareMenuView.shareMenuItems = self.shareMenuItems;
}

#pragma mark 自定义表情菜单
- (SHEmotionKeyboard *)emotionKeyboard{
    
    if (!_emotionKeyboard) {
        _emotionKeyboard = [[SHEmotionKeyboard alloc]init];
        _emotionKeyboard.frame = CGRectMake(0, kSHHEIGHT - 205 - kCustomNav, CGRectGetWidth(self.superVC.view.bounds), 205);
        _emotionKeyboard.backgroundColor = InPutViewColor;
        _emotionKeyboard.alpha = 0;
        _emotionKeyboard.delegate = self;
        _emotionKeyboard.toolBarArr = @[[NSString stringWithFormat:@"%lu",(unsigned long)SHEmoticonType_system]];
        
        [_emotionKeyboard reloadView];
        [self.superVC.view addSubview:_emotionKeyboard];
    }
    
    return _emotionKeyboard;
}

#pragma mark 自定义相册菜单
- (SHPhotoPicker *)photoPicker{
    if (!_photoPicker) {
        _photoPicker = [[SHPhotoPicker alloc]initWithFrame:CGRectMake(0, kSHHEIGHT - 205 - kCustomNav, CGRectGetWidth(self.superVC.view.bounds), 205)];
        _photoPicker.selectedCount = 9;
        _photoPicker.alpha = 0;
    }
    return _photoPicker;
}

#pragma mark - 输入框点击
#pragma mark 下方按钮点击
- (void)btnClick:(UIButton *)btn{
    
    if (_type == SHChatType_Chat) {//单聊
        
        switch (btn.tag) {//点击
            case 10://语音
            {
                btn.selected = !btn.selected;
                self.inputViewType = SHInputViewType_Voice;
                [self voiceRecordClick];
            }
                break;
            case 11://阅后即焚
            {
                self.inputViewType = SHInputViewType_Burn;
            }
                break;
            case 12://图片
            {
                self.inputViewType = SHInputViewType_Picture;
            }
                break;
            case 13://相机
            {
               self.inputViewType = SHInputViewType_Camera;
            }
                break;
            case 14://表情
            {
                self.inputViewType = ((self.inputViewType == SHInputViewType_Emotion)?SHInputViewType_Text:SHInputViewType_Emotion);
            }
                break;
            case 15://多媒体更多
            {
                self.inputViewType = SHInputViewType_ShareMenu;
                [self multimediaClick];
            }
                break;
            default:
                break;
        }
        
    }else{//群聊
        
        switch (btn.tag) {//点击
            case 10://语音
                btn.selected = !btn.selected;
                self.inputViewType = SHInputViewType_Voice;
                [self voiceRecordClick];
                break;
            case 11://图片
            {
                self.inputViewType = SHInputViewType_Picture;
            }
                break;
            case 12://相机
                self.inputViewType = SHInputViewType_Camera;
                break;
            case 13://表情
            {
                self.inputViewType = (self.inputViewType == SHInputViewType_Emotion)?SHInputViewType_Text:SHInputViewType_Emotion;
            }
                break;
            case 14://多媒体更多
            {
                self.inputViewType = SHInputViewType_ShareMenu;
                [self multimediaClick];
            }
                break;
            default:
                break;
        }
    }
    
    if (!(self.inputViewType == SHInputViewType_ShareMenu || self.inputViewType == SHInputViewType_Voice)) {
        [self toolbarClick];
    }
}

#pragma mark - InputView输入框控件点击
- (void)toolbarClick{
    
    //判断输入框类型
    switch (self.inputViewType) {
        case SHInputViewType_Text://文本
        case SHInputViewType_Voice://语音
        case SHInputViewType_Normal://默认
        {
            //收起工具栏
            [self hiddenToolInput];
        }
            break;
        case SHInputViewType_Burn://阅后即焚
        {
            [self burnClick];
        }
            break;
        case SHInputViewType_ShareMenu://多媒体
        {
            self.emotionKeyboard.alpha = 0;
            self.photoPicker.alpha = 0;
            self.shareMenuView.alpha = !self.shareMenuView.alpha;
            if (self.shareMenuView.alpha) {
                [self.shareMenuView showFromBottom];
                //展示工具栏
                [self showToolInput];
            }else{
                //隐藏工具栏
                [self hiddenToolInput];
            }
            
        }
            break;
        case SHInputViewType_Emotion://表情
        {
            self.shareMenuView.alpha = 0;
            self.photoPicker.alpha = 0;
            self.emotionKeyboard.alpha = 1;
            
            if (self.emotionKeyboard.alpha) {
                [self.shareMenuView showFromBottom];
                //展示工具栏
                [self showToolInput];
            }
        }
            break;
        case SHInputViewType_Picture://照片
        {
            self.shareMenuView.alpha = 0;
            self.emotionKeyboard.alpha = 0;
            
            self.photoPicker.alpha = !self.photoPicker.alpha;
            
            if (self.photoPicker.alpha) {
                
                [self openPicLibrary];
                //展示工具栏
                [self showToolInput];
                
            }else{
                //隐藏工具栏
                [self hiddenToolInput];
                
                [self.photoPicker dismissPhotoPicker];
                self.photoPicker = nil;
            }
        }
            break;
        case SHInputViewType_Camera://相机
        {
            [self openCarema];
            
            //收起工具栏
            [self hiddenToolInput];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark 收起工具栏
- (void)hiddenToolInput{
    
    self.shareMenuView.alpha = 0;
    self.emotionKeyboard.alpha = 0;
    self.photoPicker.alpha = 0;
    
    __block CGRect inputViewFrame = self.frame;
    
    [UIView animateWithDuration:kAnimateTime animations:^{
        
        switch (self.inputViewType) {
            case SHInputViewType_Text://文本
            {
                //键盘控制
                [self.textViewInput becomeFirstResponder];
            }
                break;
            default:
            {
                //键盘控制
                [self.textViewInput resignFirstResponder];
                //键盘控件高度
                inputViewFrame.origin.y = kSHHEIGHT - kSHInPutHeight - kCustomNav;
                self.frame = inputViewFrame;
            }
                break;
        }
        
        
    }];
    
    if ([_delegate respondsToSelector:@selector(toolbarWithIsShow:)]) {
        [_delegate toolbarWithIsShow:NO];
    }
    
}

#pragma mark 显示工具栏
- (void)showToolInput{
    
    __block CGRect inputViewFrame = self.frame;
    //键盘控制
    [self.textViewInput resignFirstResponder];
    
    //其他控件
    if (self.textViewInput.hidden) {
        self.textViewInput.hidden = NO;
        self.btnVoiceRecord.hidden = YES;
    }
    
    switch (self.inputViewType) {
        case SHInputViewType_Emotion://表情
        {
            //键盘控件高度
            inputViewFrame.origin.y = kSHHEIGHT - kSHInPutHeight - kCustomNav - self.emotionKeyboard.frame.size.height;
        }
            break;
        case SHInputViewType_ShareMenu://多媒体
        {
            //键盘控件高度
            inputViewFrame.origin.y = kSHHEIGHT - kSHInPutHeight - kCustomNav - self.shareMenuView.frame.size.height;
        }
            break;
        case SHInputViewType_Picture://相册
        {
            //键盘控件高度
            inputViewFrame.origin.y = kSHHEIGHT - kSHInPutHeight - kCustomNav - self.photoPicker.frame.size.height;
        }
            break;
            
        default:
            break;
    }
    self.frame = inputViewFrame;
    
    //改变切换按钮图片
    UIButton *btn = [self viewWithTag:10];
    btn.selected = NO;
    
    if ([_delegate respondsToSelector:@selector(toolbarWithIsShow:)]) {
        [_delegate toolbarWithIsShow:YES];
    }
}

#pragma mark 语音状态切换点击
//改变输入与录音状态
- (void)voiceRecordClick{
    NSLog(@"改变输入与录音状态");
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.textViewInput.hidden  = !self.textViewInput.hidden;
    if (self.textViewInput.hidden) {
        //语音
        self.inputViewType = SHInputViewType_Voice;
//        [self setTextViewWithHeight:kSHInPutTextHeight];
    }else{
        //文本
        self.inputViewType = SHInputViewType_Text;
//        [self setTextViewWithHeight:self.textHeight];
    }
    
    [self toolbarClick];
}

#pragma mark 多媒体点击
- (void)multimediaClick{
    
    if (_type == SHChatType_Chat) {
        UIButton *multimediaBtn = (UIButton *)self.btnArr[5];
        if (multimediaBtn.selected) {
            [self burnClick];
        }else{
            self.inputViewType = SHInputViewType_ShareMenu;
            [self toolbarClick];
        }
    }else{
        self.inputViewType = SHInputViewType_ShareMenu;
        [self toolbarClick];
    }
}

#pragma mark 阅后即焚点击
- (void)burnClick{
    
    self.isBurn = !self.isBurn;

    if (self.shareMenuView.alpha) {
        [self hiddenToolInput];
    }
}

#pragma mark - 录音touch事件
#pragma mark 开始录音
- (void)beginRecordVoice:(UIButton *)button {
    button.backgroundColor = RGB(198, 199, 202, 1);
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
        if (granted) {
            
            if ([button.backgroundColor isEqual:RGB(198, 199, 202, 1)]) {
                
                SHMessageVoiceHUD *hud = [SHMessageVoiceHUD shareInstance];
                // 用户同意获取数据
                [hud showVoiceWithMessage:@"上滑取消"];
                
                [voiceRecordHelper startRecord];
                
                playTime = 0;
                playTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(countVoiceTest) userInfo:nil repeats:YES];
            }
            
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"提示" message:@"开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [ale show];
            });
            
        }
    }];
}

#pragma mark 停止录音
- (void)endRecordVoice:(UIButton *)button {
    button.backgroundColor = [UIColor clearColor];
    
    SHMessageVoiceHUD *hud = [SHMessageVoiceHUD shareInstance];
    [hud dissmissVoiceHUD];
    
    if (playTimer) {
        [voiceRecordHelper stopRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
}

#pragma mark 取消录音
- (void)cancelRecordVoice:(UIButton *)button {
    button.backgroundColor = [UIColor clearColor];
    SHMessageVoiceHUD *hud = [SHMessageVoiceHUD shareInstance];
    [hud dissmissVoiceHUD];
    
    if (playTimer) {
        [voiceRecordHelper cancelRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
}

#pragma mark 离开提示
- (void)RemindDragExit:(UIButton *)button {
    SHMessageVoiceHUD *hud = [SHMessageVoiceHUD shareInstance];
    [hud showVoiceWithMessage:@"松开手指,取消发送"];
}

#pragma mark 按住提示
- (void)RemindDragEnter:(UIButton *)button {
    SHMessageVoiceHUD *hud = [SHMessageVoiceHUD shareInstance];
    [hud showVoiceWithMessage:@"上滑取消"];
}

#pragma mark 声音检测
- (void)countVoiceTest {
    playTime += 0.05;
    
    SHMessageVoiceHUD *hud = [SHMessageVoiceHUD shareInstance];
    [hud showVoiceMeters:[voiceRecordHelper peekRecorderVoiceMetersWithMax:7]];
    
    if (playTime >= kSHMaxRecordTime) {//超过最大时间停止
        
        playTime = 0;
        [playTimer invalidate];
        
        [hud showVoiceWithMessage:[NSString stringWithFormat:@"最长时间 %dS",kSHMaxRecordTime]];
        
        //停止录音
        [self endRecordVoice:self.btnVoiceRecord];
    }
    
}

#pragma mark - 发送消息
#pragma mark 发送文字
- (void)sendMessageText:(NSString *)text {
    if ([_delegate respondsToSelector:@selector(chatMessageInputView:sendMessage:)]) {
        [_delegate chatMessageInputView:self sendMessage:text];
    }
}

#pragma mark 发送语音
- (void)sendMessageVoiceWithWavPath:(NSString *)wavPath AmrPath:(NSString *)amrPath RecordDuration:(NSString *)recordDuration {
    
    if ([_delegate respondsToSelector:@selector(chatMessageInputView:sendVoice:AmrPath:RecordDuration:)]) {
        [_delegate chatMessageInputView:self sendVoice:wavPath.lastPathComponent AmrPath:amrPath.lastPathComponent RecordDuration:recordDuration];
    }
}

#pragma mark 发送图片
- (void)sendMessageImage:(NSString *)imagePath imageSize:(CGSize)imageSize{
    if ([_delegate respondsToSelector:@selector(chatMessageInputView:sendPicture:imageSize:)]) {
        [_delegate chatMessageInputView:self sendPicture:imagePath.lastPathComponent imageSize:imageSize];
    }
}

#pragma mark 发送视频
- (void)sendMessageVideo:(NSString *)videoPath {
    if ([_delegate respondsToSelector:@selector(chatMessageInputView:sendVideo:)]) {
        [_delegate chatMessageInputView:self sendVideo:videoPath.lastPathComponent];
    }
}

#pragma mark 发送位置
- (void)sendMessageLocationMessage:(SHMessage *)message {
    if ([_delegate respondsToSelector:@selector(chatMessageInputView:sendLocation:Lon:Lat:)]) {
        [_delegate chatMessageInputView:self sendLocation:message.locationName Lon:message.lon Lat:message.lat];
    }
}

#pragma mark 发送名片
- (void)sendCard:(NSString *)card {
    if ([_delegate respondsToSelector:@selector(chatMessageInputView:sendCard:)]) {
        [_delegate chatMessageInputView:self sendCard:card];
    }
}

#pragma mark 发送红包
- (void)sendRedPackageMessage:(NSString *)message {
    if ([_delegate respondsToSelector:@selector(chatMessageInputView:sendRedPackage:)]) {
        [_delegate chatMessageInputView:self sendRedPackage:message];
    }
}

#pragma mark 发送Gif
- (void)sendGifMessageWithGifPath:(NSString *)gifPath gifSize:(CGSize)gifSize{
    if ([_delegate respondsToSelector:@selector(chatMessageInputView:sendGif:gifSize:)]) {
        [_delegate chatMessageInputView:self sendGif:gifPath.lastPathComponent gifSize:gifSize];
    }
}

#pragma mark - 多媒体调用
#pragma mark 打开相册
- (void)openPicLibrary {
    __weak typeof(self) weakSelf = self;
    [self.photoPicker showPhotoPickerInSender:self.superVC block:^(NSArray <NSArray *>*images, BOOL isHide) {
        
        if (isHide){
            weakSelf.photoPicker = nil;
            weakSelf.inputViewType = SHInputViewType_Normal;
            [weakSelf toolbarClick];
        }
        
        for (NSArray *obj in images) {
            
            NSData *data = obj[0];
            
            NSString *file;
            //其他格式的图片
            UIImage *image = [UIImage imageWithData:data];
            
            if (self.isBurn) {//是阅后即焚
                
                file = [SHFileHelper saveDataWithLocalData:data fileType:nil];
                //发送图片
                [weakSelf sendMessageImage:file imageSize:image.size];
            }else{
                
                file = [SHFileHelper saveDataWithLocalData:data fileType:obj[1]];
                if ([obj[1] containsString:@"gif"]) {//图片判断
                    //发送Gif
                    [weakSelf sendGifMessageWithGifPath:file gifSize:image.size];
                }else{
                    //发送图片
                    [weakSelf sendMessageImage:file imageSize:image.size];
                }
            }
        }
    }];
}

#pragma mark 打开相机
- (void)openCarema {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted|| authStatus == AVAuthorizationStatusDenied) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"提示" message:@"开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [ale show];
        });
        
    }else{
        NSLog(@"成功获取摄像头");
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            
            if (!self.isBurn) {//不为阅后即焚 可以拍照与录像
                //相机类型
                picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                //最大时长
                picker.videoMaximumDuration = 10;
                //视频质量
                picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
            }

            [self.superVC presentViewController:picker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            }];
        }else{
            //如果没有提示用户
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

#pragma mark 打开定位
- (void)openLocation {
    
    SHChatMessageLocationViewController *view = [[SHChatMessageLocationViewController alloc] init];
    view.delegate = self;
    view.locationType = SHMessageLocationType_Location;
    [self.superVC.navigationController pushViewController:view animated:YES];
}

#pragma mark 打开名片
- (void)openCard{
    
    [self sendCard:@"呵呵"];
}

#pragma mark 打开红包
- (void)openRedPaper{
    
    [self sendRedPackageMessage:@"123"];
}

#pragma mark 打开涂鸦
- (void)openGraffiti{

}

#pragma mark 打开背景图
- (void)openBackground {
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.movie"]) {//视频
        
        //文件路径
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        
        //把视频保存在本地路径中,进行发送
        [self sendMessageVideo:[SHMessageVideoHelper getVideoLocalWithUrl:url]];
        
        [self.superVC dismissViewControllerAnimated:YES completion:nil];
        
    }else if ([mediaType isEqualToString:@"public.image"]){//图片
        
        UIImage *image = nil;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (picker.allowsEditing) {
            image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        
        //当image从相机中获取的时候存入相册中
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSaveWithError:contextInfo:), NULL);
        }
        
        [self.superVC dismissViewControllerAnimated:YES completion:^{
            
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//相机图片
                NSString *path = [SHFileHelper saveDataWithLocalData:[SHDataConversion imageToData:image CompressionNum:1] fileType:@"jpg"];
                //发送图片
                [self sendMessageImage:path imageSize:image.size];
            }else{
                //进行涂鸦
                [self goToGraffitiEditorControllerWithImage:image];
            }
        }];
    }
}

#pragma mark  保存照片到系统相册回调
- (void)image:(UIImage *)image didFinishSaveWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error) {
        NSLog(@"照片保存失败");
    }else{
        NSLog(@"照片保存成功");
    }
}

#pragma mark 图片进行涂鸦
- (void)goToGraffitiEditorControllerWithImage:(UIImage *)image{
    
    
    [self sendMessageImage:[SHFileHelper saveDataWithLocalData:[SHDataConversion imageToData:image CompressionNum:1] fileType:@"jpg"] imageSize:image.size];
    
}

#pragma mark - SHVoiceRecordHelperDelegate
- (void)voiceRecordFinishWithWavPath:(NSString *)wavPath AmrPath:(NSString *)amrPath RecordDuration:(NSString *)recordDuration {
    //发送语音
    [self sendMessageVoiceWithWavPath:wavPath AmrPath:amrPath RecordDuration:recordDuration];
}

#pragma mark 规定时间以外
- (void)voiceRecordTimeWithRuleTime:(int)ruleTime {
    //提示框
    SHMessageVoiceHUD *hud = [SHMessageVoiceHUD shareInstance];
    
    if (ruleTime > kSHMaxRecordTime) {
        [hud showVoiceWithMessage:@"时间太长"];
    }else{
        [hud showVoiceWithMessage:@"时间太短"];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud dissmissVoiceHUD];
    });
}

#pragma mark - SHLocationDelegate
- (void)sendCLLocationWithMessage:(SHMessage *)message {
    //发送位置
    [self sendMessageLocationMessage:message];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {//点击了发送
        
        if (self.textViewInput.text.length) {
            //发送文字
            [self sendMessageText:self.textViewInput.text];
            self.textViewInput.text = nil;
        }
         return NO;
    }
    return YES;
}

#pragma mark 开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.inputViewType = SHInputViewType_Text;
    [self toolbarClick];
}

#pragma mark 文字改变
- (void)textViewDidChange:(UITextView *)textView{
    //适配输入框高度
    [self setTextViewHeight];
}


#pragma mark - 适配输入框高度
- (void)setTextViewHeight{
    
    [self.textViewInput scrollRangeToVisible:NSMakeRange(self.textViewInput.text.length, 1)];
    self.textViewInput.layoutManager.allowsNonContiguousLayout = NO;
}

#pragma mark - SHEmotionKeyboardDelegate
#pragma mark 发送表情
- (void)emoticonInputSend
{
    if (self.textViewInput.text.length) {
        //发送文字
        [self sendMessageText:self.textViewInput.text];
        self.textViewInput.text = nil;
    }
}

#pragma mark 获取表情对应字符
- (void)emoticonInputWithText:(NSString *)text Model:(SHEmotionModel *)model isSend:(BOOL)isSend{
    if (isSend) {
        [self sendGifMessageWithGifPath:model.gif gifSize:CGSizeMake(ChatGifWH, ChatGifWH)];
    }else{
        [self.textViewInput insertText:text];
    }
}

#pragma mark - 销毁
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
