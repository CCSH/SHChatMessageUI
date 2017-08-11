//
//  GUISlider.m
//  GUIPlayerView
//
//  Created by Guilherme Araújo on 08/12/14.
//  Copyright (c) 2014 Guilherme Araújo. All rights reserved.
//

#import "GUISlider.h"

@interface GUISlider ()

@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation GUISlider

@synthesize progressView;

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
    //进度条滑过的颜色
    self.minimumTrackTintColor = [UIColor whiteColor];
    //滑块图片与点击图片
    [self setThumbImage:[UIImage imageNamed:@"video_ progress_normal"] forState:UIControlStateNormal];
    [self setThumbImage:[UIImage imageNamed:@"video_ progress_selector"] forState:UIControlStateHighlighted];

  [self setup];
  return self;
}

- (void)setup {
  [self setMaximumTrackTintColor:[UIColor clearColor]];
  
  progressView = [UIProgressView new];
  [progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [progressView setClipsToBounds:YES];
  [[progressView layer] setCornerRadius:1.0f];
  
  CGFloat hue, sat, bri;
  [[self tintColor] getHue:&hue saturation:&sat brightness:&bri alpha:nil];
  //进度条缓冲的颜色
  [progressView setTintColor:[UIColor clearColor]];
  //进度条背景颜色
  progressView.trackTintColor = [UIColor grayColor];
  
  [self addSubview:progressView];
  
  NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[PV]|"options:0 metrics:nil views:@{@"PV" : progressView}];
  
  [self addConstraints:constraints];
  
  constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[PV]" options:0 metrics:nil views:@{@"PV" : progressView}];
  
  [self addConstraints:constraints];  
}

- (void)setSecondaryValue:(float)value {
  [progressView setProgress:value];
}

- (void)setTintColor:(UIColor *)tintColor {
  [super setTintColor:tintColor];
  
  CGFloat hue, sat, bri;
  [[self tintColor] getHue:&hue saturation:&sat brightness:&bri alpha:nil];
  [progressView setTintColor:[UIColor colorWithHue:hue saturation:(sat * 0.6f) brightness:bri alpha:1]];
}

- (void)setSecondaryTintColor:(UIColor *)tintColor {
  [progressView setTintColor:tintColor];
}

@end
