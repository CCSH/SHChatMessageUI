//
//  SHShortVideoViewController.m
//  SHShortVideoExmaple
//
//  Created by CSH on 2018/8/29.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHShortVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SHShortAVPlayer.h"
#import "UIView+SHExtension.h"

//弱引用
#define WeakSelf typeof(self) __weak weakSelf = self;

#define kSHDevice_Width  [[UIScreen mainScreen] bounds].size.width  //主屏幕的宽度
#define kSHDevice_Height [[UIScreen mainScreen] bounds].size.height //主屏幕的高度

//是否是 iPhoneX
#define  kSH_iPhoneX (kSHDevice_Width == 375.f && kSHDevice_Height == 812.f ? YES : NO)
//底部高度
#define  kSH_SafeBottom (kSH_iPhoneX ? 34.f : 0.f)
//状态栏高度
#define  kSH_StatusBarHeight  ([UIApplication sharedApplication].statusBarFrame.size.height)

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface SHShortVideoViewController ()<AVCaptureFileOutputRecordingDelegate,CAAnimationDelegate>

//背景
@property (nonatomic, strong) UIImageView *bgView;
//摄像头切换
@property (nonatomic, strong) UIButton *cameraBtn;
//返回
@property (nonatomic, strong) UIButton *backBtn;
//完成
@property (nonatomic, strong) UIButton *doneBtn;
//取消
@property (nonatomic, strong) UIButton *cancelBtn;
//拍照、录制
@property (nonatomic, strong) UIImageView *takeImage;
//轻触拍照，按住摄像
@property (nonatomic, strong) UILabel *tipLab;
//聚焦
@property (nonatomic, strong) UIImageView *focusImage;
//进度
@property (nonatomic, strong) CAShapeLayer *progressLayer;
//视频预览
@property (nonatomic, strong) SHShortAVPlayer *player;
//图像预览层，实时显示捕获的图像
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

//记录状态栏状态
@property (nonatomic, assign) BOOL isStatusHidden;
//下方控件的中心Y
@property (nonatomic, assign) CGFloat centerY;
//是否是摄像 YES 代表是录制  NO 表示拍照
@property (nonatomic, assign) BOOL isVideo;
//缓存视频的路径
@property (nonatomic, strong) NSString *tempPath;
//拖拽起始点
@property (nonatomic, assign) CGPoint startPoint;
//镜头当前变焦
@property (nonatomic, assign) CGFloat cameraZoom;

//负责输入和输出设备之间的数据传递
@property (nonatomic) AVCaptureSession *session;
//设备输入
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;
//视频输出流
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieOutPut;
//照片输出流
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutPut;

@end

@implementation SHShortVideoViewController

//时间大于这个就是视频，否则为拍照
#define TimeMax 1

#pragma mark - 懒加载
#pragma mark 背景
- (UIView *)bgView{
   if (!_bgView) {
      _bgView = [[UIImageView alloc]init];
      _bgView.userInteractionEnabled = YES;
      _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      
      //添加聚焦点击
      UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusAction:)];
      [_bgView addGestureRecognizer:tapGest];
      
      //添加镜头远近
      UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
      [_bgView addGestureRecognizer:panGest];
      
      [self.view addSubview:_bgView];
   }
   return _bgView;
}

#pragma mark 摄像头切换
- (UIButton *)cameraBtn{
   if (!_cameraBtn) {
      _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [_cameraBtn setBackgroundImage:[self getImageWithName:@"video_camera"] forState:UIControlStateNormal];
      [_cameraBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
      _cameraBtn.tag = 1;
      _cameraBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
      [self.view addSubview:_cameraBtn];
   }
   return _cameraBtn;
}

#pragma mark 返回
- (UIButton *)backBtn{
   if (!_backBtn) {
      _backBtn = [[UIButton alloc] init];
      [_backBtn setImage:[self getImageWithName:@"video_back"] forState:UIControlStateNormal];
      [_backBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
      _backBtn.tag = 2;
      [self.view addSubview:_backBtn];
   }
   return _backBtn;
}

#pragma mark 完成
- (UIButton *)doneBtn{
   if (!_doneBtn) {
      _doneBtn = [[UIButton alloc] init];
      [_doneBtn setImage:[self getImageWithName:@"video_done"] forState:UIControlStateNormal];
      [_doneBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
      _doneBtn.tag = 3;
      [self.view addSubview:_doneBtn];
   }
   return _doneBtn;
}

#pragma mark 取消
- (UIButton *)cancelBtn{
   if (!_cancelBtn) {
      _cancelBtn = [[UIButton alloc] init];
      [_cancelBtn setImage:[self getImageWithName:@"video_cancel"] forState:UIControlStateNormal];
      [_cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
      _cancelBtn.tag = 4;
      [self.view addSubview:_cancelBtn];
   }
   return _cancelBtn;
}

#pragma mark 拍照、录制
- (UIImageView *)takeImage{
   if (!_takeImage) {
      _takeImage = [[UIImageView alloc] init];
      _takeImage.userInteractionEnabled = NO;
      _takeImage.image = [self getImageWithName:@"video_take"];
      
      //长按(也需要判断一下录制时间)
      UILongPressGestureRecognizer *longGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
      longGest.minimumPressDuration = 0.3;
      [_takeImage addGestureRecognizer:longGest];
      
      //点击
      UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
      [_takeImage addGestureRecognizer:tapGest];
      
      [self.view addSubview:_takeImage];
   }
   return _takeImage;
}

#pragma mark 提示
- (UILabel *)tipLab{
   if (!_tipLab) {
      _tipLab = [[UILabel alloc] init];
      _tipLab.font = [UIFont systemFontOfSize:14];
      _tipLab.textColor = [UIColor whiteColor];
      _tipLab.textAlignment = NSTextAlignmentCenter;
      _tipLab.text = @"轻触拍照，按住摄像";
      [self.view addSubview:_tipLab];
   }
   return _tipLab;
}

#pragma mark 聚焦
- (UIImageView *)focusImage{
   if (!_focusImage) {
      _focusImage = [[UIImageView alloc] initWithImage:[self getImageWithName:@"video_focusing"]];
      [self.view addSubview:_focusImage];
   }
   return _focusImage;
}

#pragma mark 进度
- (CAShapeLayer *)progressLayer{
   if (!_progressLayer) {
      _progressLayer = [CAShapeLayer layer];
      _progressLayer.strokeColor = self.progressColor.CGColor;
      _progressLayer.fillColor = [UIColor clearColor].CGColor;
      _progressLayer.lineWidth = 5;
   }
   return _progressLayer;
}

#pragma mark 视频预览
- (SHShortAVPlayer *)player{
   if (!_player) {
      _player = [[SHShortAVPlayer alloc]init];
      _player.frame = CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame));
      _player.hidden = YES;
      [self.bgView addSubview:_player];
   }
   return _player;
}

#pragma mark 视频捕捉
- (AVCaptureVideoPreviewLayer *)previewLayer{
   if (!_previewLayer) {
      //创建视频预览层，用于实时展示摄像头状态
      _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
      _previewLayer.frame = self.view.layer.bounds;
      [self.view.layer setMasksToBounds:YES];
      //填充模式
      _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
   }
   return _previewLayer;
}

#pragma mark 视频输出
- (AVCaptureMovieFileOutput *)movieOutPut{
   if (!_movieOutPut) {
      _movieOutPut = [[AVCaptureMovieFileOutput alloc] init];
   }
   return _movieOutPut;
}

#pragma mark 图片输出
- (AVCaptureStillImageOutput *)imageOutPut{
   if (!_imageOutPut) {
      _imageOutPut = [[AVCaptureStillImageOutput alloc] init];
      _imageOutPut.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
   }
   return _imageOutPut;
}

#pragma mark 负责输入和输出设备之间的数据传递
- (AVCaptureSession *)session{
   if (!_session) {
      _session = [[AVCaptureSession alloc]init];
   }
   return _session;
}

#pragma mark - 初始化
- (void)viewDidLoad {
   [super viewDidLoad];
   // Do any additional setup after loading the view.
   
   self.view.backgroundColor = [UIColor blackColor];
   self.tempPath = [NSTemporaryDirectory() stringByAppendingString:@"video.mp4"];
   
   //时间不存在则默认 60
   if (!self.maxSeconds) {
      self.maxSeconds = 60;
   }
   
   //颜色不存在
   if (!self.progressColor) {
      self.progressColor = [UIColor orangeColor];
   }
   
   //配置UI
   [self configUI];
   //配置相机
   [self configCamera];
   //    [self setupCamera];
   //暂停其他音乐，
   [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
   [[AVAudioSession sharedInstance] setActive:YES error:nil];
   //隐藏提示文字
   [self performSelector:@selector(hiddenTip) withObject:nil afterDelay:3];
}

#pragma mark - 布局
#pragma mark 配置UI
- (void)configUI{
   
   self.centerY = self.view.height - 100 - kSH_SafeBottom;
   //背景
   self.bgView.frame = CGRectMake(0, kSH_iPhoneX?kSH_StatusBarHeight:0, self.view.width, self.view.height - kSH_SafeBottom);
   
   //摄像头切换
   self.cameraBtn.frame = CGRectMake(self.view.width - 15 - 40,(kSH_iPhoneX?kSH_StatusBarHeight:0) + 23, 40, 40);
   
   //录制
   self.takeImage.size = CGSizeMake(70, 70);
   self.takeImage.center = CGPointMake(self.view.centerX, self.centerY);
   
   //完成
   self.doneBtn.size = CGSizeMake(70, 70);
   self.doneBtn.center = CGPointMake(self.view.centerX, self.centerY);
   
   //取消
   self.cancelBtn.size = CGSizeMake(70, 70);
   self.cancelBtn.center = CGPointMake(self.view.centerX, self.centerY);
   
   //返回
   self.backBtn.size = CGSizeMake(70, 70);
   self.backBtn.center = CGPointMake(kSHDevice_Width/4, self.centerY);
   
   //提示
   self.tipLab.frame = CGRectMake(0, self.takeImage.y - 20 - 30, self.view.width, 20);
   
   //聚焦
   self.focusImage.size = CGSizeMake(60, 60);
   
   self.focusImage.alpha = 0;
   
   self.doneBtn.hidden = YES;
   self.cancelBtn.hidden = YES;
   
   self.cameraBtn.hidden = NO;
   self.backBtn.hidden = NO;
   self.takeImage.hidden = NO;
}

#pragma mark 配置相机
- (void)configCamera{
   
   //创建视频设备
   AVCaptureDevice *videoDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
   //创建音频设备
   AVCaptureDevice *audioDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio].firstObject;
   
   NSError *error;
   //添加视频输入设备
   if (videoDevice) {
      //根据设备创建输入信号
      self.deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:&error];
   }
   
   if (error) {
      NSLog(@"视频输入对象,错误原因：%@",error.localizedDescription);
      return;
   }
   
   error = nil;
   AVCaptureDeviceInput *audioInput;
   //添加音频输入设备
   if (audioDevice){
      audioInput = [[AVCaptureDeviceInput alloc]initWithDevice:audioDevice error:&error];
   }
   
   if (error) {
      NSLog(@"音频输入对象时出错，错误原因：%@",error.localizedDescription);
      return;
   }
   
   //设置分辨率 (设备支持的最高分辨率)
   if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
      self.session.sessionPreset = AVCaptureSessionPresetHigh;
   }
   
   //将设备输入添加到会话
   if ([self.session canAddInput:self.deviceInput]) {
      [self.session addInput:self.deviceInput];
      //处理成功按钮可以点击
      self.takeImage.userInteractionEnabled = YES;
   }
   
   //将声音输入添加到会话
   if ([self.session canAddInput:audioInput]) {
      [self.session addInput:audioInput];
   }
   
   //将照片输出添加到会话
   if ([self.session canAddOutput:self.imageOutPut]) {
      [self.session addOutput:self.imageOutPut];
   }
   
   //将视频输出添加到会话
   if ([self.session canAddOutput:self.movieOutPut]) {
      [self.session addOutput:self.movieOutPut];
      
      //设置视频防抖
      AVCaptureConnection *connection = [self.movieOutPut connectionWithMediaType:AVMediaTypeVideo];
      if ([connection isVideoStabilizationSupported]) {
         connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
      }
   }
   
   //添加视频预览层，用于实时展示摄像头状态
   [self.view.layer insertSublayer:self.previewLayer atIndex:0];
   
   //注意添加区域改变捕获通知必须首先设置设备允许捕获
   [self changeDeviceBlock:^(AVCaptureDevice *captureDevice) {
      captureDevice.subjectAreaChangeMonitoringEnabled = YES;
   }];
}

#pragma mark 开始录制界面布局
- (void)startLayout{
   
   self.cancelBtn.hidden = YES;
   self.doneBtn.hidden = YES;
   
   self.takeImage.hidden = NO;
   self.cameraBtn.hidden = NO;
   self.backBtn.hidden = NO;
   
   if (self.isVideo) {
      self.isVideo = NO;
      [self.player stop];
      self.player.hidden = YES;
   }else{
      self.bgView.image = nil;
   }
   
   self.takeImage.image = [self getImageWithName:@"video_take"];
   //录制
   self.takeImage.size = CGSizeMake(70, 70);
   self.takeImage.center = CGPointMake(self.view.centerX, self.centerY);
   
   //镜头变焦
   self.cameraZoom = 1;
}

#pragma mark 录制结束界面布局
- (void)stopLayout{
   
   self.takeImage.hidden = YES;
   self.cameraBtn.hidden = YES;
   self.backBtn.hidden = YES;
   
   self.doneBtn.hidden = NO;
   self.cancelBtn.hidden = NO;
   
   [self.progressLayer removeFromSuperlayer];
   
   self.doneBtn.centerX = self.takeImage.centerX;
   self.cancelBtn.centerX = self.takeImage.centerX;
   
   CGFloat centerX = kSHDevice_Width/4;
   [UIView animateWithDuration:0.25 animations:^{
      //完成左边
      self.doneBtn.centerX = self.takeImage.centerX - centerX;
      //取消右边
      self.cancelBtn.centerX = self.takeImage.centerX + centerX;
   }];
}

#pragma mark 录制中界面布局
- (void)recordingLayout{
   
   if ([self.movieOutPut isRecording]) {
      
      self.backBtn.hidden = YES;
      
      self.takeImage.image = [self getImageWithName:@"video_takeing"];
      self.takeImage.size = CGSizeMake(70, 70);
      self.takeImage.center = CGPointMake(self.view.centerX, self.centerY);
      
      [UIView animateWithDuration:0.1 animations:^{
         
         self.takeImage.size = CGSizeMake(120, 120);
         self.takeImage.center = CGPointMake(self.view.centerX, self.centerY);
      }completion:^(BOOL finished) {
         
         CABasicAnimation *animation = [[CABasicAnimation alloc]init];
         animation.keyPath = @"strokeEnd";
         animation.fromValue = @(0);
         animation.toValue = @(1);
         animation.duration = self.maxSeconds;
         animation.delegate = self;
         
         CGFloat width = CGRectGetWidth(self.takeImage.frame) - self.progressLayer.lineWidth;
         UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.progressLayer.lineWidth/2, self.progressLayer.lineWidth/2, width, width) cornerRadius:width/2];
         self.progressLayer.path = path.CGPath;
         [self.progressLayer addAnimation:animation forKey:nil];
         [self.takeImage.layer addSublayer:self.progressLayer];
      }];
   }
}

#pragma mark - 录制处理
#pragma mark 拍照
- (void)takePic{
   
   self.isVideo = NO;
   
   //展示
   AVCaptureConnection *connection = [self.imageOutPut connectionWithMediaType:AVMediaTypeVideo];
   connection.videoOrientation = [self.previewLayer connection].videoOrientation;
   
   WeakSelf;
   [self.imageOutPut captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
      
      if (!imageDataSampleBuffer) {
         NSLog(@"获取图片错误：%@",error.description);
         return ;
      }
      NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
      weakSelf.bgView.image = [UIImage imageWithData:data];
      [weakSelf.session stopRunning];
   }];
}

#pragma mark 视频
- (void)takeVideo{
   
   self.isVideo = YES;
   
   //展示
   self.player.hidden = NO;
   self.player.videoUrl = [NSURL fileURLWithPath:self.tempPath];
   [self.player play];
   
   [self.session stopRunning];
}

#pragma mark - Action
#pragma mark 按钮点击
- (void)btnAction:(UIButton *)btn{
   switch (btn.tag) {
      case 1://摄像头切换
      {
         //切换摄像头
         [self cameraSwitch];
      }
         break;
      case 2://返回
      {
         [self dismissViewControllerAnimated:YES completion:nil];
      }
         break;
      case 3://完成
      {
         //完成录制
         [self finishVideo];
      }
         break;
      case 4://取消
      {
         //开始录制界面布局
         [self startLayout];
         //开始捕获
         [self.session startRunning];
      }
         break;
      default:
         break;
   }
}

#pragma mark 长按录制
- (void)longAction:(UIGestureRecognizer *)gest{
   
   switch (gest.state) {
      case UIGestureRecognizerStateBegan://开始
      {
         [self startVideo];
      }
         break;
      case UIGestureRecognizerStateEnded://结束
      {
         [self stopVideo];
      }
         break;
      default:
         break;
   }
}

#pragma mark 点击拍照
- (void)tapAction:(UIGestureRecognizer *)gest{
   
   [self stopLayout];
   [self takePic];
}

#pragma mark 聚焦点击
- (void)focusAction:(UITapGestureRecognizer *)gest{
   
   //捕捉中可以调整焦距
   if ([self.session isRunning]) {
      //对焦
      CGPoint point = [gest locationInView:self.bgView];
      
      if (point.y < CGRectGetMinY(self.takeImage.frame) - 20) {
         
         [self setFocusCursorWithPoint:point];
         //设置焦点
         [self setFocusWithPoint:point];
      }
   }
}

#pragma mark 拖动镜头变焦
- (void)panAction:(UITapGestureRecognizer *)gest{
   
   //录制中可以拉远近
   if ([self.movieOutPut isRecording]) {
      
      CGPoint point = [gest locationInView:self.view];
      
      switch (gest.state) {
         case UIGestureRecognizerStateBegan://开始拖动
         {
            self.startPoint = point;
         }
            break;
         case UIGestureRecognizerStateChanged://拖动中
         {
            CGFloat zoom = self.cameraZoom + (self.startPoint.y - point.y)/1000;
            self.cameraZoom = zoom;
         }
            break;
         case UIGestureRecognizerStateEnded://结束拖动
         {
            self.startPoint = CGPointZero;
         }
            break;
         default:
            break;
      }
   }
}

#pragma mark - 录制操作
#pragma mark 开始录制
- (void)startVideo{
   
   //根据设备输出获得连接
   AVCaptureConnection *connection = [self.movieOutPut connectionWithMediaType:AVMediaTypeAudio];
   
   //如果开始那么停止
   if ([self.movieOutPut isRecording]) {
      //结束录制
      [self stopVideo];
   }
   
   //预览图层和视频方向保持一致
   connection.videoOrientation = [self.previewLayer connection].videoOrientation;
   
   //删除上次的临时文件
   if ([[NSFileManager defaultManager] fileExistsAtPath:self.tempPath]) {
      [[NSFileManager defaultManager] removeItemAtPath:self.tempPath error:nil];
   }
   
   //开始录制
   [self.movieOutPut startRecordingToOutputFileURL:[NSURL fileURLWithPath:self.tempPath] recordingDelegate:self];
}

#pragma mark 结束录制
- (void)stopVideo{
   
   [self.movieOutPut stopRecording];
}

#pragma mark 完成录制
- (void)finishVideo{
   
   WeakSelf;
   if (self.isVideo) {
      
      [self.player stop];
      self.player.hidden = YES;
      
      if (self.isSave) {//保存到系统
         
         [[ALAssetsLibrary new] writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:self.tempPath] completionBlock:^(NSURL *assetURL, NSError *error) {
            
            if (error) {
               NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
            }else{
               //处理视频
               [weakSelf dealVideoWithPath:weakSelf.tempPath];
            }
         }];
      }else{
         //处理视频
         [self dealVideoWithPath:self.tempPath];
      }
      
   } else {
      
      if (self.isSave) {//保存到系统
         //保存照片
         [[ALAssetsLibrary new] writeImageToSavedPhotosAlbum:[self.bgView.image CGImage] orientation:(ALAssetOrientation)self.bgView.image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
               NSLog(@"保存图片到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
            }else{
               //回调
               if (weakSelf.finishBlock) {
                  weakSelf.finishBlock(weakSelf.bgView.image);
               }
               //返回
               [weakSelf btnAction:weakSelf.backBtn];
            }
         }];
      }else{
         //回调
         if (self.finishBlock) {
            self.finishBlock(self.bgView.image);
         }
         //返回
         [self btnAction:self.backBtn];
      }
   }
}

#pragma mark - 私有方法
#pragma mark 摄像头切换
- (void)cameraSwitch{
   
   AVCaptureDevice *currentDevice = [self.deviceInput device];
   AVCaptureDevicePosition currentPosition = [currentDevice position];
   
   //前
   AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
   if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront){
      //后
      toChangePosition = AVCaptureDevicePositionBack;
   }
   
   AVCaptureDevice *toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
   
   //注意添加区域改变捕获通知必须首先设置设备允许捕获
   [self changeDeviceBlock:^(AVCaptureDevice *captureDevice) {
      captureDevice.subjectAreaChangeMonitoringEnabled = YES;
   }];
   
   //获得要调整的设备输入对象
   AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
   
   //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
   [self.session beginConfiguration];
   
   //移除原有输入对象
   [self.session removeInput:self.deviceInput];
   
   //添加新的输入对象
   if ([self.session canAddInput:newVideoInput]) {
      [self.session addInput:newVideoInput];
      self.deviceInput = newVideoInput;
   }
   //提交会话配置
   [self.session commitConfiguration];
}

#pragma mark 处理视频(压缩、分辨率)
- (void)dealVideoWithPath:(NSString *)path{
   
   NSURL *url = [NSURL fileURLWithPath:path];
   
   //获取文件资源
   AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
   //导出预设参数
   NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
   //是否包含中分辨率，如果是低分辨率AVAssetExportPresetLowQuality则不清晰
   if ([presets containsObject:AVAssetExportPresetMediumQuality]) {
      
      //重定义资源属性（画质设置成中等）
      AVAssetExportSession *dealSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
      
      //压缩后的文件路径
      NSString *dealPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"video.mp4"];
      
      //存在的话就删除
      if ([[NSFileManager defaultManager] fileExistsAtPath:dealPath]) {
         [[NSFileManager defaultManager] removeItemAtPath:dealPath error:nil];
      }
      
      //导出路径
      dealSession.outputURL = [NSURL fileURLWithPath:dealPath];
      //导出类型
      dealSession.outputFileType = AVFileTypeMPEG4;
      //是否对网络进行优化
      dealSession.shouldOptimizeForNetworkUse = YES;
      
      WeakSelf;
      //导出
      [dealSession exportAsynchronouslyWithCompletionHandler:^{
         
         switch ([dealSession status]) {
            case AVAssetExportSessionStatusFailed://失败
            {
               NSLog(@"failed, error:%@.", dealSession.error);
            }
               break;
            case AVAssetExportSessionStatusCancelled://转换中
               break;
            case AVAssetExportSessionStatusCompleted://完成
            {
               dispatch_async(dispatch_get_main_queue(), ^{
                  
                  NSLog(@"\n原始文件大小：%f M\n压缩后视频大小：%f M",[weakSelf getVideoSizeWithPath:weakSelf.tempPath],[weakSelf getVideoSizeWithPath:dealPath]);
                  //回调
                  if (weakSelf.finishBlock) {
                     weakSelf.finishBlock(dealPath);
                  }
                  //返回
                  [weakSelf btnAction:weakSelf.backBtn];
               });
            }
               break;
            default:
               break;
         }
      }];
   }
}

#pragma mark 设置聚焦光标位置
- (void)setFocusCursorWithPoint:(CGPoint)point{
   
   if (!self.focusImage.alpha) {
      
      self.focusImage.alpha = 1;
      self.focusImage.center = point;
      self.focusImage.transform = CGAffineTransformMakeScale(1.5, 1.5);
      
      [UIView animateWithDuration:0.5 animations:^{
         
         self.focusImage.transform = CGAffineTransformIdentity;
      } completion:^(BOOL finished) {
         
         self.focusImage.alpha = 0;
      }];
   }
}

#pragma mark 取得指定位置的摄像头
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position{
   
   NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
   for (AVCaptureDevice *camera in cameras) {
      if ([camera position] == position) {
         return camera;
      }
   }
   return nil;
}

#pragma mark 改变设备属性的统一操作方法
- (void)changeDeviceBlock:(PropertyChangeBlock)block{
   
   AVCaptureDevice *captureDevice = [self.deviceInput device];
   NSError *error;
   //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
   if ([captureDevice lockForConfiguration:&error]) {
      //自动白平衡
      if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
         [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
      }
      //自动根据环境条件开启闪光灯
      if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
         [captureDevice setFlashMode:AVCaptureFlashModeAuto];
      }
      
      if (block) {
         block(captureDevice);
      }
      
      [captureDevice unlockForConfiguration];
   }else{
      NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
   }
}

#pragma mark 设置聚焦点
- (void)setFocusWithPoint:(CGPoint)point{
   
   [self changeDeviceBlock:^(AVCaptureDevice *captureDevice) {
      
      //自动对焦
      if ([captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
         [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
      }
      
      //自动连续对焦
      if ([captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
         [captureDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
      }
      
      //曝光点
      if ([captureDevice isExposurePointOfInterestSupported]) {
         [captureDevice setExposurePointOfInterest:point];
      }
      
      //聚焦点
      if ([captureDevice isFocusPointOfInterestSupported]) {
         [captureDevice setFocusPointOfInterest:point];
      }
   }];
}

#pragma mark 设置镜头变焦
- (void)setCameraZoom:(CGFloat)cameraZoom{
   
   //最大6 最小1
   cameraZoom = MIN(MAX(cameraZoom, 1), 6);
   _cameraZoom = cameraZoom;
   
   AVCaptureDevice *captureDevice = [self.deviceInput device];
   NSError *error;
   [captureDevice lockForConfiguration:&error];
   
   if (error){
      return;
   }
   captureDevice.videoZoomFactor = cameraZoom;
   [captureDevice unlockForConfiguration];
}

#pragma mark 获取Bundle路径
- (UIImage *)getImageWithName:(NSString *)name{
   
   NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"SHShortVideo" ofType:@"bundle"];
   NSString *imagePath = [NSString stringWithFormat:@"%@/%@@2x",path,name];
   return [UIImage imageWithContentsOfFile:imagePath];
}

#pragma mark 获取视频size
- (CGFloat)getVideoSizeWithPath:(NSString *)path{
   
   NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
   return [dic fileSize]/1024.0/1024.0;
}

#pragma mark 校验权限
- (void)checkPermissions{
   
   //验证权限
   WeakSelf;
   [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
      if (granted) {
         [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
               //开始捕捉内容
               [weakSelf.session startRunning];
            }else{
               [weakSelf btnAction:weakSelf.backBtn];
            }
         }];
      }else{
         [weakSelf btnAction:weakSelf.backBtn];
      }
   }];
}

#pragma mark 隐藏提示文字
- (void)hiddenTip{
   
   [self.tipLab removeFromSuperview];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
#pragma mark 开始录制
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
   
   //录制中界面布局
   [self recordingLayout];
}

#pragma mark 录制完成
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
   
   //结束界面布局
   [self stopLayout];
   //判断录制时间
   if (CMTimeGetSeconds(captureOutput.recordedDuration) < 1) {//拍照
      
      [self takePic];
   }else{//视频
      
      [self takeVideo];
   }
}

#pragma mark - CAAnimationDelegate
#pragma mark 动画完成
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
   
   if ([self.movieOutPut isRecording]) {
      [self stopVideo];
   }
}

#pragma mark - 界面周期
- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
   //更改状态栏
   self.isStatusHidden = [UIApplication sharedApplication].statusBarHidden;
   [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
   [super viewDidAppear:animated];
   
   //校验权限
   [self checkPermissions];
   //对焦
   self.focusImage.alpha = 0;
   [self setFocusCursorWithPoint:self.bgView.center];
}

- (void)viewDidDisappear:(BOOL)animated{
   [super viewDidDisappear:animated];
   //停止捕捉内容
   [self.session stopRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
   [super viewWillDisappear:animated];
   //还原状态栏
   [[UIApplication sharedApplication] setStatusBarHidden:self.isStatusHidden];
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

- (void)dealloc{
   
   [self.player stop];
   [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

@end
