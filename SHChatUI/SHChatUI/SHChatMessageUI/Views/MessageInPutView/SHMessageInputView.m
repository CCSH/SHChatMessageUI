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
#import "SHMessageMacroHeader.h"

@interface SHMessageInputView ()<
UITextViewDelegate,
SHVoiceRecordHelperDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
SHLocationDelegate
>
{
    SHVoiceRecordHelper *voiceRecordHelper;
    CGFloat playTime;
    NSTimer *playTimer;
    UILabel *placeHold;
    NSString *toolType;
}

//定位服务的管理对象。
@property (strong, nonatomic)CLLocationManager *locationManager;
//定位回调
@property (nonatomic, copy) DidGetGeolocationsCompledBlock didGetGeolocationsCompledBlock;

@end

@implementation SHMessageInputView

- (id)initWithFrame:(CGRect)frame SuperVC:(UIViewController *)superVC WithType:(NSString *)type
{
    self.superVC = superVC;
    toolType = type;
    
    self = [super initWithFrame:frame];
    if (self) {
        
        voiceRecordHelper = [[SHVoiceRecordHelper alloc]initWithDelegate:self];
        
        self.backgroundColor = RGB(228, 238, 244, 1);
        
        CGFloat View_X = kSHInPutSpace;
        CGFloat View_W = kSHInPutHeight - 2*kSHInPutTop;
        
        //先画最左边的
        //改变状态（语音、文字）
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnChangeVoiceState.frame = CGRectMake(View_X, kSHInPutTop, View_W, View_W);
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice.png"] forState:UIControlStateNormal];
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_HL.png"] forState:UIControlStateHighlighted];
        
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_keyboard.png"] forState:UIControlStateSelected];
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_keyboard_HL.png"] forState:UIControlStateHighlighted];
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnChangeVoiceState addTarget:self action:@selector(voiceRecordClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnChangeVoiceState];
        
        //再画最右边的
        //多媒体按钮
        View_X = frame.size.width - View_W - kSHInPutSpace;
        
        self.btnMultimedia = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnMultimedia.frame = CGRectMake(View_X, kSHInPutTop, View_W, View_W);
        [self.btnMultimedia setTitle:@"" forState:UIControlStateNormal];
        [self.btnMultimedia setBackgroundImage:[UIImage imageNamed:@"chat_multimedia.png"] forState:UIControlStateNormal];
        [self.btnMultimedia setBackgroundImage:[UIImage imageNamed:@"chat_multimedia_HL.png"] forState:UIControlStateHighlighted];
        self.btnMultimedia.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnMultimedia addTarget:self action:@selector(multimediaClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnMultimedia];
        
        //表情按钮
        View_X  = View_X - View_W - kSHInPutSpace;
        
        self.btnExpression = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnExpression.frame = CGRectMake(View_X, kSHInPutTop, View_W, View_W);
        [self.btnExpression setTitle:@"" forState:UIControlStateNormal];
        [self.btnExpression setBackgroundImage:[UIImage imageNamed:@"chat_face.png"] forState:UIControlStateNormal];
        [self.btnExpression setBackgroundImage:[UIImage imageNamed:@"chat_face_HL.png"] forState:UIControlStateHighlighted];
        self.btnExpression.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnExpression addTarget:self action:@selector(expressionClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnExpression];
        
        
        //语音录入键
        View_X = self.btnChangeVoiceState.frame.size.width + self.btnChangeVoiceState.frame.origin.x + kSHInPutSpace;
        View_W = self.btnExpression.frame.origin.x - kSHInPutSpace - View_X;
        
        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnVoiceRecord.frame = CGRectMake(View_X, kSHInPutTop, View_W, kSHInPutHeight - 2*kSHInPutTop);
        self.btnVoiceRecord.hidden = YES;
        self.btnVoiceRecord.layer.cornerRadius = 4;
        self.btnVoiceRecord.layer.masksToBounds = YES;
        self.btnVoiceRecord.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        self.btnVoiceRecord.layer.borderWidth = 1;
        
        [self.btnVoiceRecord setTitleColor:RGB(76, 76, 76, 1) forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:RGB(76, 76, 76, 1) forState:UIControlStateHighlighted];
        
        [self.btnVoiceRecord setTitle:@"按住 说话" forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        
        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [self addSubview:self.btnVoiceRecord];
        
        //输入框
        self.textViewInput = [[UITextView alloc]initWithFrame:self.btnVoiceRecord.frame];
        self.textViewInput.layer.cornerRadius = 4;
        self.textViewInput.layer.masksToBounds = YES;
        self.textViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        self.textViewInput.layer.borderWidth = 1;
        self.textViewInput.delegate = self;
        self.textViewInput.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        //按钮样子
        self.textViewInput.returnKeyType = UIReturnKeySend;
        //UITextView内部判断send按钮是否可以用
        self.textViewInput.enablesReturnKeyAutomatically = YES;
        [self addSubview:self.textViewInput];
        
//        //输入框的提示语
//        placeHold = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, View_W, kSHInPutHeight - 2*kSHInPutTop)];
//        placeHold.text = @"再此输入。。";
//        placeHold.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
//        [self.textViewInput addSubview:placeHold];
        
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - 输入框点击

#pragma mark 语音状态切换点击
//改变输入与录音状态
- (void)voiceRecordClick
{
    NSLog(@"改变输入与录音状态");
    
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.textViewInput.hidden  = !self.textViewInput.hidden;

    if (self.textViewInput.hidden) {
        //语音
        self.textViewInputViewType = SHInputViewType_Voice;
    }else{
        //文本
        self.textViewInputViewType = SHInputViewType_Text;
    }
    //语音点击回调
    if ([_delegate respondsToSelector:@selector(voiceRecordClick)]) {
        [_delegate voiceRecordClick];
    }
    
    
    
}

#pragma mark 表请点击
- (void)expressionClick
{
    NSLog(@"表情点击");
    self.textViewInputViewType = SHInputViewType_Emotion;
    if ([_delegate respondsToSelector:@selector(expressionClick)]) {
        [_delegate expressionClick];
    }
}

#pragma mark 多媒体点击事件
- (void)multimediaClick
{
    NSLog(@"多媒体点击");
    self.textViewInputViewType = SHInputViewType_ShareMenu;
    if ([_delegate respondsToSelector:@selector(multimediaClick)]) {
        [_delegate multimediaClick];
    }
    
}

#pragma mark - 录音touch事件
#pragma mark 开始录音
- (void)beginRecordVoice:(UIButton *)button
{
    button.backgroundColor = RGB(198, 199, 202, 1);
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            // 用户同意获取数据
            SHMessageVoiceHUD *hud = [SHMessageVoiceHUD shareInstance];
            [hud showVoiceWithMessage:@"手指上滑,取消发送"];

            [voiceRecordHelper startRecord];
            
            playTime = 0;
            playTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(countVoiceTest) userInfo:nil repeats:YES];
            
        } else {
            // 可以显示一个提示框告诉用户这个app没有得到允许？
            UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"提示" message:@"麦克风访问受限,请在设置-隐私中开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [ale show];
        }
    }];
}

#pragma mark 停止录音
- (void)endRecordVoice:(UIButton *)button
{
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
- (void)cancelRecordVoice:(UIButton *)button
{
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
- (void)RemindDragExit:(UIButton *)button
{
    SHMessageVoiceHUD *hud = [SHMessageVoiceHUD shareInstance];
    [hud showVoiceWithMessage:@"松开手指,取消发送"];
}

#pragma mark 按住提示
- (void)RemindDragEnter:(UIButton *)button
{
    SHMessageVoiceHUD *hud = [SHMessageVoiceHUD shareInstance];
    [hud showVoiceWithMessage:@"手指上滑,取消发送"];
}

#pragma mark 声音检测
- (void)countVoiceTest
{
    playTime += 0.05;

    SHMessageVoiceHUD *hud = [SHMessageVoiceHUD shareInstance];
    [hud showVoiceMeters:[voiceRecordHelper peekRecorderVoiceMeters]];
    if (playTime >= kSHMaxRecordTime) {
        [hud showVoiceWithMessage:[NSString stringWithFormat:@"最大时间%dS",kSHMaxRecordTime]];
    }
    
}

#pragma mark - 发送消息
#pragma mark 发送文字
- (void)sendMessageText:(NSString *)text
{
    if (text.length) {
        if ([_delegate respondsToSelector:@selector(SHMessageInputView:sendMessage:)]) {
            [self.delegate SHMessageInputView:self sendMessage:text];
        }
        self.textViewInput.text = @"";
    }
    
}

#pragma mark 发送语音
- (void)sendMessageVoiceWithWavPath:(NSString *)wavPath AmrPath:(NSString *)amrPath RecordDuration:(NSString *)recordDuration
{
    if ([_delegate respondsToSelector:@selector(SHMessageInputView:sendVoiceWithWavPath:AmrPath:RecordDuration:)]) {
        [_delegate SHMessageInputView:self sendVoiceWithWavPath:wavPath AmrPath:amrPath RecordDuration:recordDuration];
    }
}

#pragma mark 发送图片
- (void)sendMessageImage:(UIImage *)image
{
    if ([_delegate respondsToSelector:@selector(SHMessageInputView:sendPicture:)]) {
        [_delegate SHMessageInputView:self sendPicture:image];
    }
}

#pragma mark 发送视频
- (void)sendMessageVideo:(NSString *)videoPath
{
    if ([_delegate respondsToSelector:@selector(SHMessageInputView:sendVideoPath:videoImage:)]) {
        [_delegate SHMessageInputView:self sendVideoPath:videoPath videoImage:[SHMessageVideoHelper videoConverPhotoWithVideoPath:videoPath]];
    }
}

#pragma mark 发送位置
- (void)sendLocation:(CLLocation *)location LocationName:(NSString *)locationName
{
    if ([_delegate respondsToSelector:@selector(SHMessageInputView:sendCLLocation:LocationName:)]) {
        [_delegate SHMessageInputView:self sendCLLocation:location LocationName:locationName];
    }
}

#pragma mark 发送名片
- (void)sendCard:(NSString *)card
{
    if ([_delegate respondsToSelector:@selector(SHMessageInputView:sendCard:)]) {
        [_delegate SHMessageInputView:self sendCard:card];
    }
}

#pragma mark - 多媒体调用
#pragma mark 打开相册
-(void)openPicLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.view.backgroundColor = ControllerColor;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.superVC presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark 打开相机
-(void)openCarema
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted|| authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"提示" message:@"摄像头访问受限,请在设置-隐私中开启权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [ale show];
    }else{
        NSLog(@"成功获取摄像头");
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            [self.superVC presentViewController:picker animated:YES completion:^{
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
- (void)openLocation
{

    SHChatMessageLocationViewController *view = [[SHChatMessageLocationViewController alloc]
                                                 init];
    view.delegate = self;
    view.locationType = SHMessageLocationType_Location;
    [self.superVC.navigationController pushViewController:view animated:YES];

}
#pragma mark 打开名片
- (void)openCard{

    [self sendCard:@"123456"];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.movie"]) {//如果是视频
        
        //视频路径
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];
        
        //发送视频
        [self.superVC dismissViewControllerAnimated:YES completion:^{
            //发送视频
            [self sendMessageVideo:[url path]];
        }];
        
    }else if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage *image = nil;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (picker.allowsEditing) {
            image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        [self.superVC dismissViewControllerAnimated:YES completion:^{
            //发送图片与照片
            [self sendMessageImage:image];
        }];
    }
}

#pragma mark - SHVoiceRecordHelperDelegate
- (void)voiceRecordFinishWithWavPath:(NSString *)wavPath AmrPath:(NSString *)amrPath RecordDuration:(NSString *)recordDuration
{
    //发送语音
    [self sendMessageVoiceWithWavPath:wavPath AmrPath:amrPath RecordDuration:recordDuration];
}

#pragma mark 规定时间以外
- (void)voiceRecordTimeWithRuleTime:(int)ruleTime
{
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
- (void)sendCLLocation:(CLLocation *)location LocationName:(NSString *)locationName{
    //发送位置
    [self sendLocation:location LocationName:locationName];
}



#pragma mark - TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeHold.hidden = self.textViewInput.text.length > 0;
}

- (void)textViewDidChange:(UITextView *)textView
{
    placeHold.hidden = self.textViewInput.text.length>0;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    placeHold.hidden = self.textViewInput.text.length > 0;
}

#pragma mark 键盘上功能点击
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//点击了发送
        //发送文字
        [self sendMessageText:self.textViewInput.text];
        return NO;
    }
    if (text.length == 0) {//点击了删除
        
    }
    
    return YES;
}



#pragma mark 销毁
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
