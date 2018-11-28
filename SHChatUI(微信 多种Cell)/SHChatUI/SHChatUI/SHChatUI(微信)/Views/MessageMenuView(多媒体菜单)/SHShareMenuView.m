//
//  SHShareMenuView.m
//  SHChatMessageUI
//
//  Created by CSH on 16/7/27.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHShareMenuView.h"
#import "SHMessageHeader.h"

@interface SHShareMenuItemView : UIView

/**
 *  第三方按钮
 */
@property (nonatomic, weak) UIButton *shareMenuItemButton;
/**
 *  第三方按钮的标题
 */
@property (nonatomic, weak) UILabel *shareMenuItemTitleLabel;

/**
 *  配置默认控件的方法
 */
- (void)setup;

@end

@implementation SHShareMenuItemView

- (void)setup {
    if (!_shareMenuItemButton) {
        UIButton *shareMenuItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareMenuItemButton.frame = CGRectMake(0, 0, kSHShareMenuItemWH, kSHShareMenuItemWH);
        shareMenuItemButton.layer.cornerRadius = 10;
        shareMenuItemButton.layer.borderColor = kRGB(218, 223, 225, 1).CGColor;
        shareMenuItemButton.layer.borderWidth = 1;
        shareMenuItemButton.backgroundColor = kRGB(255, 255, 255, 1);
        
        [self addSubview:shareMenuItemButton];
        
        self.shareMenuItemButton = shareMenuItemButton;
    }
    
    if (!_shareMenuItemTitleLabel) {
        UILabel *shareMenuItemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5, CGRectGetMaxY(self.shareMenuItemButton.frame), kSHShareMenuItemWH + 10, KSHShareMenuItemHeight - kSHShareMenuItemWH)];
        shareMenuItemTitleLabel.textAlignment = NSTextAlignmentCenter;
        shareMenuItemTitleLabel.textColor = kRGB(154, 155, 156, 1);
        
        [self addSubview:shareMenuItemTitleLabel];
        
        self.shareMenuItemTitleLabel = shareMenuItemTitleLabel;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

@end

@interface SHShareMenuView () <UIScrollViewDelegate>

/**
 *  背景滚动视图
 */
@property (nonatomic, weak) UIScrollView *shareMenuScrollView;

/**
 *  显示页码的视图
 */
@property (nonatomic, weak) UIPageControl *shareMenuPageControl;

/**
 *  第三方按钮点击的事件
 *
 *  @param sender 第三方按钮对象
 */
- (void)shareMenuItemButtonClicked:(UIButton *)sender;

/**
 *  配置默认控件
 */
- (void)setup;

@end


@implementation SHShareMenuView

- (void)shareMenuItemButtonClicked:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didSelecteShareMenuItem:index:)]) {
        NSInteger index = sender.tag;
        if (index < self.shareMenuItems.count) {
            [self.delegate didSelecteShareMenuItem:self.shareMenuItems[index] index:index];
        }
    }
}

- (void)reloadData {
    
    if (!_shareMenuItems.count)
        return;
    
    [self.shareMenuScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat paddingX = (kSHWidth - kSHShareMenuPerRowItemCount*kSHShareMenuItemWH)/(kSHShareMenuPerRowItemCount + 1);
    CGFloat paddingY = KSHShareMenuItemTop;
    
    for (SHShareMenuItem *shareMenuItem in self.shareMenuItems) {
        NSInteger index = [self.shareMenuItems indexOfObject:shareMenuItem];
        NSInteger page = index / (kSHShareMenuPerRowItemCount * kSHShareMenuPerColum);
        CGRect shareMenuItemViewFrame = [self getFrameWithPerRowItemCount:kSHShareMenuPerRowItemCount perColumItemCount:kSHShareMenuPerColum itemWidth:kSHShareMenuItemWH itemHeight:KSHShareMenuItemHeight paddingX:paddingX paddingY:paddingY atIndex:index onPage:page];
        SHShareMenuItemView *shareMenuItemView = [[SHShareMenuItemView alloc] initWithFrame:shareMenuItemViewFrame];
        

        shareMenuItemView.shareMenuItemTitleLabel.textColor = shareMenuItem.titleColor?:[UIColor lightGrayColor];
        shareMenuItemView.shareMenuItemTitleLabel.font = shareMenuItem.titleFont?:[UIFont systemFontOfSize:11];
        
        shareMenuItemView.shareMenuItemButton.tag = index;
        [shareMenuItemView.shareMenuItemButton addTarget:self action:@selector(shareMenuItemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [shareMenuItemView.shareMenuItemButton setImage:shareMenuItem.icon forState:UIControlStateNormal];
        
        shareMenuItemView.shareMenuItemTitleLabel.text = shareMenuItem.title;
        
        [self.shareMenuScrollView addSubview:shareMenuItemView];
    }
    
    self.shareMenuPageControl.numberOfPages = (self.shareMenuItems.count / (kSHShareMenuPerRowItemCount * kSHShareMenuPerColum) + (self.shareMenuItems.count % (kSHShareMenuPerRowItemCount * kSHShareMenuPerColum) ? 1 : 0));
    [self.shareMenuScrollView setContentSize:CGSizeMake(((self.shareMenuItems.count / (kSHShareMenuPerRowItemCount * kSHShareMenuPerColum) + (self.shareMenuItems.count % (kSHShareMenuPerRowItemCount * kSHShareMenuPerColum) ? 1 : 0)) * CGRectGetWidth(self.bounds)), CGRectGetHeight(self.shareMenuScrollView.bounds))];
}

/**
 *  通过目标的参数，获取一个grid布局
 *
 *  @param perRowItemCount   每行有多少列
 *  @param perColumItemCount 每列有多少行
 *  @param itemWidth         gridItem的宽度
 *  @param itemHeight        gridItem的高度
 *  @param paddingX          gridItem之间的X轴间隔
 *  @param paddingY          gridItem之间的Y轴间隔
 *  @param index             某个gridItem所在的index序号
 *  @param page              某个gridItem所在的页码
 *
 *  @return 返回一个已经处理好的gridItem frame
 */
- (CGRect)getFrameWithPerRowItemCount:(NSInteger)perRowItemCount
                    perColumItemCount:(NSInteger)perColumItemCount
                            itemWidth:(CGFloat)itemWidth
                           itemHeight:(NSInteger)itemHeight
                             paddingX:(CGFloat)paddingX
                             paddingY:(CGFloat)paddingY
                              atIndex:(NSInteger)index
                               onPage:(NSInteger)page {
    CGRect itemFrame = CGRectMake((index % perRowItemCount) * (itemWidth + paddingX) + paddingX + (page * CGRectGetWidth(self.bounds)), ((index / perRowItemCount) - perColumItemCount * page) * (itemHeight + paddingY) + paddingY, itemWidth, itemHeight);
    return itemFrame;
}

#pragma mark - Life cycle

- (void)setup {
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    if (!_shareMenuScrollView) {
        UIScrollView *shareMenuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        shareMenuScrollView.delegate = self;
        shareMenuScrollView.canCancelContentTouches = NO;
        shareMenuScrollView.delaysContentTouches = YES;
        shareMenuScrollView.backgroundColor = self.backgroundColor;
        shareMenuScrollView.showsHorizontalScrollIndicator = NO;
        shareMenuScrollView.showsVerticalScrollIndicator = NO;
        [shareMenuScrollView setScrollsToTop:NO];
        shareMenuScrollView.pagingEnabled = YES;
        [self addSubview:shareMenuScrollView];
        
        self.shareMenuScrollView = shareMenuScrollView;
    }
    
    if (!_shareMenuPageControl) {
        UIPageControl *shareMenuPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.shareMenuScrollView.frame) - kSHShareMenuPageControlHeight, CGRectGetWidth(self.bounds), kSHShareMenuPageControlHeight)];
        shareMenuPageControl.backgroundColor = self.backgroundColor;
        shareMenuPageControl.hidesForSinglePage = YES;
        shareMenuPageControl.defersCurrentPageDisplay = YES;
        shareMenuPageControl.currentPageIndicatorTintColor = kRGB(138, 138, 138, 1);
        shareMenuPageControl.pageIndicatorTintColor = kRGB(186, 186, 186, 1);
        [self addSubview:shareMenuPageControl];
        
        self.shareMenuPageControl = shareMenuPageControl;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    _shareMenuItems = nil;
    _shareMenuScrollView.delegate = nil;
    _shareMenuScrollView = nil;
    _shareMenuPageControl = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reloadData];
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.shareMenuPageControl setCurrentPage:currentPage];
}


@end
