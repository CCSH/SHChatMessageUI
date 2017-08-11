//
//  SHPhotoBrowser.m
//  LazyWeather
//
//  Created by KevinSH on 15/12/6.
//  Copyright © 2015年 SHXiaoMing. All rights reserved.
//

#import "SHPhotoBrowser.h"
#import "SHPhotoHeader.h"
#import "SHPhotoBrowserCell.h"
#import "SHMessageMacroHeader.h"

@interface SHPhotoBrowser ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView; //底部面板
@property (weak, nonatomic) IBOutlet UILabel *originalLabel;
@property (weak, nonatomic) IBOutlet UIButton *isOriginalBtn; //原图按钮
@property (weak, nonatomic) IBOutlet UIView *bottomViewCover; //底部面板遮罩层
@property (weak, nonatomic) IBOutlet UILabel *comBtn; //完成按钮

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSArray * dataSource;

@end

@implementation SHPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:self.collectionTitle ? self.collectionTitle :@"相册"];
    [self setupUI];
    [self loadAssetData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshBottomView];
    [self.collectionView reloadData];
}

#pragma mark - UI
- (void)setupUI {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREEN_W - 5 * 3) / 4, (SCREEN_W - 5 * 3) / 4);
    layout.minimumInteritemSpacing = 5.0;
    layout.minimumLineSpacing = 5.0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H - 40 - 64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SHPhotoBrowserCell" bundle:nil] forCellWithReuseIdentifier:@"browserCell"];
    [self.view insertSubview:self.collectionView belowSubview:self.bottomView];
    
    self.originalLabel.text = @"原图";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnAction)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)cancelBtnAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ([SHPhotoCenter shareCenter].handle) {
            [SHPhotoCenter shareCenter].handle(nil,YES);
        }
    }];
}

- (void)refreshBottomView {
    if ([SHPhotoCenter shareCenter].selectedPhotos.count > 0) {
        self.bottomViewCover.hidden = YES;
        self.isOriginalBtn.selected = [SHPhotoCenter shareCenter].isOriginal;
        self.comBtn.text = [NSString stringWithFormat:@"%@(%d)",@"完成",(int)[SHPhotoCenter shareCenter].selectedPhotos.count];
    }else {
        self.bottomViewCover.hidden = NO;
        self.isOriginalBtn.selected = NO;
        self.comBtn.text = @"完成";
    }
}

#pragma mark - 数据
- (void)loadAssetData {
    self.dataSource = [[SHPhotoManager manager]fetchAssetsInCollection:self.assetCollection asending:NO];
}

#pragma mark - collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SHPhotoBrowserCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"browserCell" forIndexPath:indexPath];
    [[SHPhotoManager manager]fetchImageInAsset:self.dataSource[indexPath.row] size:CGSizeMake(cell.width * 2, cell.height * 2) isResize:NO completeBlock:^(NSData *data, NSString *fileType) {
        cell.imageIV.image = [UIImage imageWithData:data];
    }];
    cell.selBtn.selected = [[SHPhotoCenter shareCenter].selectedPhotos containsObject:self.dataSource[indexPath.row]];
    
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    [cell setSelectedBlock:^(BOOL isSelected) {
        if (isSelected) {
            if ([[SHPhotoCenter shareCenter] isReachMaxSelectedCount]) {
                weakCell.selBtn.selected = NO;
                return;
            }
            [weakCell.selBtn startSelectedAnimation];
            [[SHPhotoCenter shareCenter].selectedPhotos addObject:weakSelf.dataSource[indexPath.row]];
        }else {
            [[SHPhotoCenter shareCenter].selectedPhotos removeObject:weakSelf.dataSource[indexPath.row]];
        }
        [weakSelf refreshBottomView];
    }];
    [cell setImgTapBlock:^{
        SHPhotoPreviewer * previewer = [[SHPhotoPreviewer alloc]init];
        if (weakCell.selBtn.selected) {
            previewer.isPreviewSelectedPhotos = YES;
        }
        previewer.selectedAsset = weakSelf.dataSource[indexPath.row];
        [previewer setBackBlock:^(){
            [collectionView reloadData];
            [weakSelf refreshBottomView];
        }];
        [weakSelf.navigationController pushViewController:previewer animated:YES];
    }];
    return cell;
}


#pragma mark - 按钮
- (IBAction)senBtnAction:(UIButton *)sender {
    [[SHPhotoCenter shareCenter] endPick];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeSizeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [SHPhotoCenter shareCenter].isOriginal = sender.selected;
}

@end
