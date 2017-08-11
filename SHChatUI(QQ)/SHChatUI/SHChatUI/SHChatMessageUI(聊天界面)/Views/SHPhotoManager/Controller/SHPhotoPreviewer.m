//
//  SHPhotoPreviewPage.m
//  LazyWeather
//
//  Created by KevinSH on 15/12/8.
//  Copyright © 2015年 SHXiaoMing. All rights reserved.
//

#import "SHPhotoPreviewer.h"
#import "SHPhotoHeader.h"
#import "SHPhotoBrowserCell.h"

@interface SHPhotoPreviewer ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *sizeCount;
@property (weak, nonatomic) IBOutlet UIButton *isOriginalBtn; //原图按钮
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
//原图文字
@property (weak, nonatomic) IBOutlet UILabel *originalLabel;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) UIButton * selBtn;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation SHPhotoPreviewer

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    
    if (self.previewPhotos) {
        self.dataSource = self.previewPhotos.copy;
    }else if (self.isPreviewSelectedPhotos) {
        self.dataSource = [SHPhotoCenter shareCenter].selectedPhotos.copy;
    }else {
        self.dataSource = [SHPhotoCenter shareCenter].allPhotos.copy;
    }

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(SCREEN_W, SCREEN_H);
    layout.minimumLineSpacing = 40.0;
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-20, 0, SCREEN_W + 40, SCREEN_H) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SHPhotoBrowserCell" bundle:nil] forCellWithReuseIdentifier:@"headCell"];
    [self.view insertSubview:self.collectionView belowSubview:self.bottomView];
    
    self.originalLabel.text = @"原图";
    
    if (self.navigationController.viewControllers.count < 2) {
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithFrame:CGRectMake(0, 0, 22, 22) Target:self Selector:@selector(dismissPreviewer) Image:@"back.png" ImagePressed:@"back.png"]];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
    self.selBtn = [UIButton buttonWithFrame:CGRectMake(0, 0, 26, 26) Target:self Selector:@selector(selBtnAction:) Image:@"photo_circle" ImageSelected:@"photo_selected"];
    UIBarButtonItem * navSelItem = [[UIBarButtonItem alloc]initWithCustomView:self.selBtn];
    self.navigationItem.rightBarButtonItem = navSelItem;
    
    self.isOriginalBtn.selected = [SHPhotoCenter shareCenter].isOriginal;
    self.currentPage = [self.dataSource indexOfObject:self.selectedAsset];
    [self refreshSelBtnStatusWithCurrentPage:(int)self.currentPage];
    [self refreshCompleteBtnStatus];
    [self refreshTitle];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - UI状态
- (void)refreshBottomHiddenStatus {
    self.bottomView.hidden = !self.bottomView.hidden;
    self.navigationController.navigationBarHidden = self.bottomView.hidden;
    [UIApplication sharedApplication].statusBarHidden = self.bottomView.hidden;
}

- (void)refreshSelBtnStatusWithCurrentPage:(int)page {
    self.selBtn.selected = [[SHPhotoCenter shareCenter].selectedPhotos containsObject:self.dataSource[page]];
    self.currentPage = page;
}

- (void)refreshTitle {
    [self setNavigationTitle:[NSString stringWithFormat:@"%ld / %ld", (long)self.currentPage + 1, (long)self.dataSource.count]];
}

- (void)refreshCompleteBtnStatus {
    if ([SHPhotoCenter shareCenter].selectedPhotos.count) {
        [self.sendBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",@"完成",(long)[SHPhotoCenter shareCenter].selectedPhotos.count] forState:UIControlStateNormal];
    }else {
        [self.sendBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
}


#pragma mark - collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHPhotoBrowserCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
    [[SHPhotoManager manager]fetchImageInAsset:self.dataSource[indexPath.row] size:CGSizeMake(cell.width, cell.height) isResize:NO completeBlock:^(NSData *data, NSString *fileType) {
        cell.imageIV.contentMode = UIViewContentModeScaleAspectFit;
        cell.imageIV.image = [UIImage imageWithData:data];
    }];
    cell.selBtn.hidden = YES;
    __weak typeof(self) weakSelf = self;
    [cell setImgTapBlock:^{
        [weakSelf refreshBottomHiddenStatus];
    }];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = (int)scrollView.contentOffset.x / self.collectionView.width;
    [self refreshSelBtnStatusWithCurrentPage:currentPage];
    [self refreshTitle];
}


#pragma mark - 按钮
- (void)selBtnAction:(UIButton *)sender {
    if (sender.selected) {
        [[SHPhotoCenter shareCenter].selectedPhotos removeObject:self.dataSource[self.currentPage]];
    }else {
        if ([[SHPhotoCenter shareCenter] isReachMaxSelectedCount]) return;
        [sender startSelectedAnimation];
        [[SHPhotoCenter shareCenter].selectedPhotos addObject:self.dataSource[self.currentPage]];
    }
    sender.selected = !sender.selected;
    [self refreshCompleteBtnStatus];
}

//发送
- (IBAction)sendAction:(UIButton *)sender {
    //如果没有选中图片，则发送当前预览的图片
    if ([SHPhotoCenter shareCenter].selectedPhotos.count <= 0) [[SHPhotoCenter shareCenter].selectedPhotos addObject:self.dataSource[self.currentPage]];
    [[SHPhotoCenter shareCenter] endPick];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.doneBlock) self.doneBlock();
}

//原图
- (IBAction)changeSizeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [SHPhotoCenter shareCenter].isOriginal = sender.selected;
}

- (void)dismissPreviewer {
    if (self.backBlock) self.backBlock();
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
