//
//  VideoPlayViewController.m
//  iOSAPP
//
//  Created by xiaoxue on 2017/6/6.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "SHMessageMacroHeader.h"
#import "GUIPlayerView.h"

@interface VideoPlayViewController ()<GUIPlayerViewDelegate>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) GUIPlayerView *playerView;

@end

@implementation VideoPlayViewController

//隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self playVideo];
    
    self.backBtn.frame = CGRectMake(15, 20, 50, 50);
}

#pragma mark - 懒加载
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"red_close"] forState:0];
        [_backBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
    }
    return _backBtn;
}

- (void)leftClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 添加播放器
/**
 *  添加播放器
 */
- (void)playVideo{
    self.playerView = [[GUIPlayerView alloc]initWithFrame:self.view.bounds];
    [self.playerView setDelegate:self];
    [self.view addSubview:self.playerView];
    [self.playerView setVideoURL:self.videoURL];
    [self.playerView prepareAndPlayAutomatically:YES];
}


#pragma mark - GUI Player View Delegate Methods
- (void)playerWillEnterFullscreen
{
    self.backBtn.frame = CGRectMake(SHWidth - 15 - 50, 20, 50, 50);
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
}

- (void)playerWillLeaveFullscreen {
    self.backBtn.frame = CGRectMake(15, 20, 50, 50);
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - 播放完成
- (void)playerDidEndPlaying {
    
}

#pragma mark - 播放错误
- (void)playerFailedToPlayToEnd {
    NSLog(@"Error: could not play video");
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.playerView clean];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
