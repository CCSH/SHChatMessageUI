//
//  SHMessageInputView.m
//  SHChatUI
//
//  Created by CSH on 2018/6/5.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHMessageInputView.h"
#import <AVFoundation/AVFoundation.h>
#import "SHChatMessageLocationViewController.h"

@interface SHMessageInputView ()<
UITextViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
SHEmotionKeyboardDelegate,//表情键盘代理
SHShareMenuViewDelegate,//菜单代理
SHVoiceRecordHelperDelegate//录音代理
>

//改变输入状态按钮（语音、文字）
@property (nonatomic, strong) UIButton *changeBtn;
//语音输入按钮
@property (nonatomic, strong) UIButton *voiceBtn;
//文本输入框
@property (nonatomic, strong) UITextView *textView;
//表情按钮
@property (nonatomic, strong) UIButton *emojiBtn;
//菜单按钮
@property (nonatomic, strong) UIButton *menuBtn;

//其他输入控件
//表情控件
@property (nonatomic, strong) SHEmotionKeyboard *emojiView;
//菜单控件
@property (nonatomic, strong) SHShareMenuView *menuView;

//其他
@property (nonatomic, strong) SHVoiceRecordHelper *voiceRecordHelper;
@property (nonatomic, assign) CGFloat playTime;
@property (nonatomic, strong) NSTimer *playTimer;

@end

@implementation SHMessageInputView

static CGFloat start_maxy;

#pragma mark - 公共方法
#pragma mark 刷新界面
- (void)reloadView{
    //设置背景颜色
    self.backgroundColor = kInPutViewColor;
    
    //分割线
    self.layer.cornerRadius = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
    self.layer.borderWidth = 0.4;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    start_maxy = self.maxY;
    
    //添加改变输入状态按钮（语音、文字）
    [self addSubview:self.changeBtn];
    //添加表情按钮
    [self addSubview:self.emojiBtn];
    //添加菜单按钮
    [self addSubview:self.menuBtn];
    //添加文本输入框
    [self addSubview:self.textView];
    //添加语音输入框
    [self addSubview:self.voiceBtn];
    
    //设置输入框类型
    self.inputType = SHInputViewType_default;
    
    //设置录音代理
    self.voiceRecordHelper = [[SHVoiceRecordHelper alloc]initWithDelegate:self];
    
    //添加监听
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - 懒加载
#pragma mark 改变输入状态按钮（语音、文字）
- (UIButton *)changeBtn{
    if (!_changeBtn) {
        ////改变输入状态按钮（语音、文字）
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.frame = CGRectMake(kSHInPutSpace, self.height - kSHInPutSpace - kSHInPutIcon_WH, kSHInPutIcon_WH, kSHInPutIcon_WH);
        
        [_changeBtn setBackgroundImage:[UIImage imageNamed:@"chat_voice.png"] forState:UIControlStateNormal];
        [_changeBtn setBackgroundImage:[UIImage imageNamed:@"chat_keyboard.png"] forState:UIControlStateSelected];
        
        [_changeBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _changeBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return _changeBtn;
}

#pragma mark 文本输入框
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.frame = CGRectMake(2*kSHInPutSpace + kSHInPutIcon_WH, self.height - kSHInPutIcon_WH - kSHInPutSpace, self.emojiBtn.x - self.changeBtn.maxX - 2*kSHInPutSpace, kSHInPutIcon_WH);
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //UITextView内部判断send按钮是否可以用
        _textView.enablesReturnKeyAutomatically = YES;
        
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _textView.layer.cornerRadius = 4;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        _textView.layer.borderWidth = 1;
    }
    return _textView;
}

#pragma mark 语音输入按钮
- (UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.frame = CGRectMake(self.textView.x, self.changeBtn.y, self.textView.width, kSHInPutIcon_WH);
        _voiceBtn.hidden = YES;
        //文字颜色
        [_voiceBtn setTitleColor:kRGB(76, 76, 76, 1) forState:UIControlStateNormal];
        [_voiceBtn setTitleColor:kRGB(76, 76, 76, 1) forState:UIControlStateHighlighted];
        //文字内容
        [_voiceBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [_voiceBtn setTitle:@"松开发送" forState:UIControlStateHighlighted];
        //点击方式
        [_voiceBtn addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [_voiceBtn addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceBtn addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [_voiceBtn addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_voiceBtn addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        
        _voiceBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _voiceBtn.layer.cornerRadius = 4;
        _voiceBtn.layer.masksToBounds = YES;
        _voiceBtn.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        _voiceBtn.layer.borderWidth = 1;
    }
    return _voiceBtn;
}

#pragma mark 菜单按钮
- (UIButton *)menuBtn{
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuBtn.frame = CGRectMake(self.width - kSHInPutSpace - kSHInPutIcon_WH, self.changeBtn.y, kSHInPutIcon_WH, kSHInPutIcon_WH);
        [_menuBtn setBackgroundImage:[UIImage imageNamed:@"chat_menu.png"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        _menuBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    return _menuBtn;
}

#pragma mark 表情按钮
- (UIButton *)emojiBtn{
    if (!_emojiBtn) {
        _emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _emojiBtn.frame = CGRectMake(self.width - 2*(kSHInPutIcon_WH + kSHInPutSpace), self.changeBtn.y, kSHInPutIcon_WH, kSHInPutIcon_WH);
        [_emojiBtn setBackgroundImage:[UIImage imageNamed:@"chat_face.png"] forState:UIControlStateNormal];
        [_emojiBtn setBackgroundImage:[UIImage imageNamed:@"chat_keyboard.png"] forState:UIControlStateSelected];
        [_menuBtn setBackgroundImage:[UIImage new] forState:UIControlStateHighlighted];
        [_emojiBtn addTarget:self action:@selector(emojiClick:) forControlEvents:UIControlEventTouchUpInside];
        _emojiBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    return _emojiBtn;
}

#pragma mark - 自定义输入视图加载
#pragma mark 自定义表情菜单
- (SHEmotionKeyboard *)emojiView{
    
    if (!_emojiView) {
        _emojiView = [[SHEmotionKeyboard alloc]init];
        _emojiView.frame = CGRectMake(0, 0, kSHWidth, kChatMessageInput_H);
        _emojiView.backgroundColor = kInPutViewColor;;
        _emojiView.hidden = YES;
        _emojiView.delegate = self;
        _emojiView.toolBarArr = @[@(SHEmoticonType_system),@(SHEmoticonType_gif),@(SHEmoticonType_custom),@(SHEmoticonType_recent)];
        [_emojiView reloadView];
        
        _emojiView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
//        [self.superview addSubview:_emojiView];
    }
    
    return _emojiView;
}

#pragma mark 自定义多媒体菜单
- (SHShareMenuView *)menuView {
    
    if (!_menuView) {
        
        CGFloat shareMenuView_H;
        //计算多媒体菜单高度
        if (self.shareMenuItems.count <= kSHShareMenuPerRowItemCount) {
            shareMenuView_H = 2*KSHShareMenuItemTop + KSHShareMenuItemHeight;
            
        }else if (self.shareMenuItems.count <= kSHShareMenuPerRowItemCount*kSHShareMenuPerColum){
            shareMenuView_H = (KSHShareMenuItemTop + KSHShareMenuItemHeight)*kSHShareMenuPerColum + KSHShareMenuItemTop;
            
        }else{
            shareMenuView_H = (KSHShareMenuItemTop + KSHShareMenuItemHeight)*kSHShareMenuPerColum + kSHShareMenuPageControlHeight;
        }
        
        _menuView = [[SHShareMenuView alloc] initWithFrame:CGRectMake(0, 0, kSHWidth, shareMenuView_H)];
        _menuView.backgroundColor = kInPutViewColor;
        _menuView.hidden = YES;
        _menuView.delegate = self;
        _menuView.shareMenuItems = self.shareMenuItems;
        [_menuView reloadData];
        
        [self.superview addSubview:_menuView];
    }
    
    return _menuView;
}

#pragma mark - 按钮点击
#pragma mark 状态点击
- (void)changeClick:(UIButton *)btn{
    
    NSLog(@"改变输入与录音状态");
    
    if (self.changeBtn.selected) {
        //文本输入
        self.inputType = SHInputViewType_text;
    }else{
        //语音输入
        self.inputType = SHInputViewType_voice;
    }
}

#pragma mark 菜单点击
- (void)menuClick:(UIButton *)btn{
    NSLog(@"点击菜单");
    
    if (self.menuBtn.selected) {
        //文本输入
        self.inputType = SHInputViewType_text;
    }else{
        //菜单输入
        self.inputType = SHInputViewType_menu;
    }
    
}

#pragma mark 表情点击
- (void)emojiClick:(UIButton *)btn{
    NSLog(@"点击表情");
    
    if (self.emojiBtn.selected) {
        //文本输入
        self.inputType = SHInputViewType_text;
    }else{
        //表情输入
        self.inputType = SHInputViewType_emotion;
    }
}

#pragma mark - 监听实现
#pragma mark 监听输入框的位置
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        //回调
        if ([self.delegate respondsToSelector:@selector(toolbarHeightChange)]) {
            [self.delegate toolbarHeightChange];
        }
    }
}

#pragma mark 监听输入框类型
- (void)setInputType:(SHInputViewType)inputType{
    
    if (_inputType == inputType) {
        return;
    }
    
    if (_inputType == SHInputViewType_voice && inputType == SHInputViewType_default) {
        _inputType = inputType;
        return;
    }
    
    _inputType = inputType;
    
    //初始化
    self.menuBtn.selected = NO;
    self.emojiBtn.selected = NO;
    self.changeBtn.selected = NO;
    
    self.textView.hidden  = YES;
    self.voiceBtn.hidden = YES;
    self.emojiView.hidden = YES;
    self.menuView.hidden = YES;
    
    self.textView.inputView = nil;
    
    [self.textView resignFirstResponder];
    
    switch (inputType) {
        case SHInputViewType_default://默认
        {
            self.textView.hidden  = NO;
            
            [UIView animateWithDuration:0.25 animations:^{
                self.y = start_maxy - self.height;
            }];
        }
            break;
        case SHInputViewType_text://文本
        {
            self.textView.hidden  = NO;
            
            [self.textView reloadInputViews];
            
            //弹出键盘
            [self.textView becomeFirstResponder];
        }
            break;
        case SHInputViewType_voice://语音
        {
            self.changeBtn.selected = YES;
            
            self.voiceBtn.hidden = NO;
            
            [UIView animateWithDuration:0.25 animations:^{
                self.y = start_maxy - self.height;
            }];
            [self remakesView];
        }
            break;
        case SHInputViewType_emotion://表情
        {
            self.emojiBtn.selected = YES;
            
            self.textView.hidden  = NO;
            self.emojiView.hidden = NO;
            
            self.textView.inputView = self.emojiView;
            [self.textView reloadInputViews];
            
            //弹出键盘
            [self.textView becomeFirstResponder];
            
            //位置变化
//            self.emojiView.y = self.superview.height;
//            [UIView animateWithDuration:0.25 animations:^{
//
//                self.y = start_maxy - self.height - self.emojiView.height;
//                self.emojiView.y = self.maxY;
//            }];
//
//            [self textViewDidChange:self.textView];
        }
            break;
        case SHInputViewType_menu://菜单
        {
            self.menuBtn.selected = YES;
            
            self.textView.hidden  = NO;
            self.menuView.hidden = NO;
            
            //位置变化
            self.menuView.y = self.superview.height;
            [UIView animateWithDuration:0.25 animations:^{
                
                self.y = start_maxy - self.height - self.menuView.height;
                self.menuView.y = self.maxY;
            }];
            [self textViewDidChange:self.textView];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 发送消息
#pragma mark 发送文字
- (void)sendMessageWithText:(NSString *)text {
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendText:)]) {
        [_delegate chatMessageWithSendText:text];
    }
    
    self.textView.text = @"";
    [self textViewDidChange:self.textView];
}

#pragma mark 发送语音
- (void)sendMessageWithVoice:(NSString *)voiceName duration:(NSString *)duration {
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendVoice:duration:)]) {
        [_delegate chatMessageWithSendVoice:voiceName duration:duration];
    }
}

#pragma mark 发送图片
- (void)sendMessageWithImage:(UIImage *)image{
    
    NSString *imageName = [SHFileHelper getFileNameWithContent:image type:SHMessageFileType_image];
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendImage:size:)]) {
        [_delegate chatMessageWithSendImage:imageName size:image.size];
    }
}

#pragma mark 发送视频
- (void)sendMessageWithVideo:(NSString *)videoPath {
    
    NSString *videoName = [SHFileHelper getFileNameWithContent:videoPath type:SHMessageFileType_video];
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendVideo:)]) {
        [_delegate chatMessageWithSendVideo:videoName];
    }
}

#pragma mark 发送位置
- (void)sendMessageWithLocation:(NSString *)locationName lon:(CGFloat)lon lat:(CGFloat)lat{
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendLocation:lon:lat:)]) {
        [_delegate chatMessageWithSendLocation:locationName lon:lon lat:lat];
    }
}

#pragma mark 发送名片
- (void)sendMessageWithCard:(NSString *)card {
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendCard:)]) {
        [_delegate chatMessageWithSendCard:card];
    }
}

#pragma mark 发送红包
- (void)sendMessageWithRedPackage:(NSString *)message {
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendRedPackage:)]) {
        [_delegate chatMessageWithSendRedPackage:message];
    }
}

#pragma mark 发送Gif
- (void)sendMessageWithGif:(NSString *)gifName size:(CGSize)size{
    
    if ([_delegate respondsToSelector:@selector(chatMessageWithSendGif:size:)]) {
        [_delegate chatMessageWithSendGif:gifName size:size];
    }
}

#pragma mark - 菜单内容
#pragma mark 打开照片
- (void)openPhoto{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.view.backgroundColor = [UIColor whiteColor];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.supVC presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark 打开相机
- (void)openCarema{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted|| authStatus == AVAuthorizationStatusDenied) {
        
        UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"提示" message:@"摄像头访问受限,请在设置-隐私中开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [ale show];
    }else{

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            [self.supVC presentViewController:picker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            }];
        }else{
            //如果没有提示用户
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的设备没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

#pragma mark 打开定位
- (void)openLocation{
    
    SHChatMessageLocationViewController *view = [[SHChatMessageLocationViewController alloc]init];
    view.locType = SHMessageLocationType_Location;
    @kSHWeak(self);
    view.block = ^(SHMessage *message) {
        @kSHStrong(self);
        [self sendMessageWithLocation:message.locationName lon:message.lon lat:message.lat];
    };
    
    [self.supVC.navigationController pushViewController:view animated:YES];
}

#pragma mark 打开名片
- (void)openCard{
    
    [self sendMessageWithCard:@"哈哈"];
}

#pragma mark 打开红包
- (void)openRedPaper{
    
    [self sendMessageWithRedPackage:@"恭喜发财，大吉大利"];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.movie"]) {//如果是视频
        
        //视频路径
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        
        //发送视频
        [self sendMessageWithVideo:url.path];
        
        //发送视频
        [self.supVC dismissViewControllerAnimated:YES completion:nil];
        
    }else if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage *image = nil;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (picker.allowsEditing) {
            
            image = [info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            
            image = [info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        //发送图片与照片
        [self sendMessageWithImage:image];
        
        [self.supVC dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITextViewDelegate
#pragma mark 键盘上功能点击
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {//点击了发送
        //发送文字
        [self sendMessageWithText:textView.text];
        return NO;
    }
    return YES;
}

#pragma mark 开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (self.inputType == SHInputViewType_default) {
        //输入文本
        self.inputType = SHInputViewType_text;
    }
    
    [self textViewDidChange:textView];
}

#pragma mark 文字改变
- (void)textViewDidChange:(UITextView *)textView{
    
    CGFloat padding = textView.textContainer.lineFragmentPadding;
    
    CGFloat maxH = ceil(textView.font.lineHeight*3 + 2*padding);
    
    CGFloat textH = [textView.text boundingRectWithSize:CGSizeMake(textView.width - 2*padding, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textView.font} context:nil].size.height;
    textH = ceil(MIN(maxH, textH));
    textH = ceil(MAX(textH, kSHInPutIcon_WH));
    
    if (self.textView.height != textH) {
        self.y += (self.textView.height - textH);
        self.height = textH + 2*kSHInPutSpace;
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
    }
}

#pragma mark 重制视图
- (void)remakesView{
    
//    self.voiceBtn.height = kSHInPutIcon_WH;
    self.height = kSHInPutIcon_WH + 2*kSHInPutSpace;
    self.y = start_maxy - self.height;
}

#pragma mark - SHEmotionKeyboardDelegate
- (void)emoticonInputWithText:(NSString *)text Model:(SHEmotionModel *)model isSend:(BOOL)isSend{
    
    if (isSend) {//直接进行发送
        
        switch (model.type) {
            case SHEmoticonType_collect://收藏(可用Url、也可以用路径)
            {
//                NSData *data = [NSData dataWithContentsOfFile:model.path];
            }
                break;
            case SHEmoticonType_gif://Gif(默认路径为静态的)
            {
                [self sendMessageWithGif:model.gif size:CGSizeMake(100, 100)];
            }
                break;
            default:
                break;
        }
    }else{
        
        
        NSInteger selectIndex = self.textView.selectedRange.location;
        NSMutableString *str = [[NSMutableString alloc]initWithString:self.textView.text];

        [str insertString:text atIndex:selectIndex];
        //放到文本框
        self.textView.text = str;
        [self textViewDidChange:self.textView];
        
        self.textView.selectedRange = NSMakeRange(selectIndex + text.length,0);
    }
}

- (void)emoticonInputSend
{
    //发送文字
    [self sendMessageWithText:self.textView.text];
}

#pragma mark - SHShareMenuViewDelegate
- (void)didSelecteShareMenuItem:(SHShareMenuItem *)menuItem index:(NSInteger)index{
    
    if ([_delegate respondsToSelector:@selector(didSelecteMenuItem:index:)]) {
        [_delegate didSelecteMenuItem:menuItem index:index];
    }
}

#pragma mark - SHVoiceRecordHelperDelegate
- (void)voiceRecordFinishWithVoicename:(NSString *)voiceName duration:(NSString *)duration{
    
    //发送语音
    [self sendMessageWithVoice:voiceName duration:duration];
}

#pragma mark 时间太短
- (void)voiceRecordTimeShort
{
    //提示框
    [SHMessageVoiceHUD shareInstance].hudType = 3;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SHMessageVoiceHUD shareInstance].hudType = 0;
    });
}

#pragma mark - 录音touch事件
#pragma mark 开始录音
- (void)beginRecordVoice:(UIButton *)button {
    
    //录音的时候停止播放
    [[SHAudioPlayerHelper shareInstance] stopAudio];
    
    //检查权限
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {

        if (granted) {//获取权限

            //用户同意获取数据
            [SHMessageVoiceHUD shareInstance].hudType = 1;

            //开始录音
            [self.voiceRecordHelper startRecord];

            if (self.playTimer) {
                [self.playTimer invalidate];
                self.playTimer = nil;
            }
            
            self.playTime = 0;
            self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(countVoiceTest) userInfo:nil repeats:YES];
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"提示" message:@"开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [ale show];
            });
        }
    }];
}

#pragma mark 停止录音
- (void)endRecordVoice:(UIButton *)button {
    //隐藏提示框
    [SHMessageVoiceHUD shareInstance].hudType = 0;

    if (self.playTimer) {
        [self.voiceRecordHelper stopRecord];
        
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

#pragma mark 取消录音
- (void)cancelRecordVoice:(UIButton *)button {
    //隐藏提示框
    [SHMessageVoiceHUD shareInstance].hudType = 0;

    if (self.playTimer) {
        [self.voiceRecordHelper cancelRecord];
        
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

#pragma mark 离开提示
- (void)RemindDragExit:(UIButton *)button {
    
    [SHMessageVoiceHUD shareInstance].hudType = 2;
}

#pragma mark 按住提示
- (void)RemindDragEnter:(UIButton *)button {
    
    [SHMessageVoiceHUD shareInstance].hudType = 1;
}

#pragma mark 声音检测
- (void)countVoiceTest {
    
    self.playTime += 0.05;
    
    int meters = [self.voiceRecordHelper peekRecorderVoiceMetersWithMax:7];
    //声波显示
    [[SHMessageVoiceHUD shareInstance] showVoiceMeters:meters];
    
    if (self.playTime >= kSHMaxRecordTime) {//超过最大时间停止
        
        self.playTime = 0;
        [self.playTimer invalidate];
        
        [SHMessageVoiceHUD shareInstance].hudType = 4;
        
        //停止录音
        [self endRecordVoice:self.voiceBtn];
    }
    
}

@end
