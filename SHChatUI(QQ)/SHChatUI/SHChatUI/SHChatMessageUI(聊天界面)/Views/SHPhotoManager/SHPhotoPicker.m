//
//  SHPhotoPicker.m
//  LazyWeather
//
//  Created by KevinSH on 15/12/6.
//  Copyright (c) 2015年 SHXiaoMing. All rights reserved.
//

#import "SHPhotoPicker.h"
#import "SHPhotoHeader.h"
#import "SHPhotoBrowserCell.h"
#import "SHMessageMacroHeader.h"

@interface SHPhotoPicker ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIGestureRecognizerDelegate>

//图片列表
@property (nonatomic, strong) UICollectionView * collectionView;
//原图按钮
@property (nonatomic, strong) UIButton * originalBtn;
//编辑按钮
@property (nonatomic, strong) UIButton * editBtn;
//发送按钮
@property (nonatomic, strong) UIButton * doneBtn;

//collectionView数据源
@property (nonatomic, strong) NSArray * dataSource;
//显示选择器的控制器
@property (nonatomic, weak) UIViewController * sender;

//开始拖拽的中心点
@property (nonatomic, assign) CGPoint panCenter;
//拖动的视图
@property (nonatomic, strong) UIImageView *dragView;
//拖动的蒙板
@property (nonatomic, strong) UIView *becloudView;
//是否显示蒙板
@property (nonatomic, assign) BOOL isBecloud;

@end

@implementation SHPhotoPicker

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

#pragma mark - 注销
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - SET
- (void)setSelectedCount:(NSInteger)selectedCount {
    [SHPhotoCenter shareCenter].selectedCount = selectedCount;
    _selectedCount = selectedCount;
}

#pragma mark - 设置数据
- (void)configData {
    
    if (self.selectedCount <= 0) {
       [self setSelectedCount:20]; 
    }
    if (self.preViewCount <= 0) self.preViewCount = 20;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllPhotos) name:PhotoLibraryChangeNotification object:nil];
    //获取图片
    [[SHPhotoCenter shareCenter] fetchAllAsset];
}

#pragma mark - 设置界面
- (void)configUI {
    
    self.backgroundColor = BGCOLOR;
    self.isBecloud = YES;
    
    //图片浏览展示
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = Space;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 30) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SHPhotoBrowserCell" bundle:nil] forCellWithReuseIdentifier:@"headCell"];
    [self addSubview:self.collectionView];
    
    //下方按钮
    CGFloat View_X = 5;
    CGFloat View_Y = CGRectGetHeight(self.frame) - 30 + 5;
//    //相机
//    UIButton * cameraBtn = [UIButton buttonWithFrame:CGRectMake(View_X, View_Y, 40, 20) title:@"相机" target:self selector:@selector(takePhoto)];
//    [self addSubview:cameraBtn];
//    View_X += 50;
    
    //相册
    UIButton *albumBtn = [UIButton buttonWithFrame:CGRectMake(View_X, View_Y, 50, 20) title:@"相册" target:self selector:@selector(albumBrowser)];
    [self addSubview:albumBtn];
    
    //编辑
    View_X = albumBtn.maxX + 5;
    self.editBtn = [UIButton buttonWithFrame:CGRectMake(View_X, View_Y, 50, 20) title:@"编辑" target:self selector:@selector(editClick)];
    [self addSubview:self.editBtn];
    
    //原图
    View_X = self.editBtn.maxX;
    self.originalBtn = [UIButton buttonWithFrame:CGRectMake(View_X, View_Y, 90, 20) Target:self Selector:@selector(originalSwitch:) Image:@"photo_unselected.png" ImageSelected:@"photo_selected.png" title:@"原图"];
    [self addSubview:self.originalBtn];
    
    //完成
    self.doneBtn = [UIButton buttonWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 85, View_Y, 80, 20) title:@"完成" target:self selector:@selector(endPick)];
    [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.doneBtn.layer.cornerRadius = self.doneBtn.height/2;
    self.doneBtn.layer.masksToBounds = YES;
    [self addSubview:self.doneBtn];
}

#pragma mark - 拖拽手势
- (void)handlePanGestures:(UIPanGestureRecognizer *)panGestures{
    
    @synchronized (self) {
        
        if (panGestures.state == UIGestureRecognizerStateBegan) {
            
            //添加蒙板
            if (self.isBecloud) {
                self.becloudView = [[UIView alloc]init];
                self.becloudView.frame = CGRectMake(0, 0, SHWidth, SHHeight);
                self.becloudView.backgroundColor = [UIColor clearColor];
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window addSubview:self.becloudView];
                self.isBecloud = NO;

                SHPhotoBrowserCell *cell = (SHPhotoBrowserCell *)panGestures.view;
                cell.alpha = 0;
 
                CGRect frame = CGRectMake(0, 0, 0, 0);
            
                CGRect rectInSuperview = [self.collectionView convertRect:cell.frame toView:[self.collectionView superview]];
                frame.origin.x = rectInSuperview.origin.x;
                frame.size = cell.imageIV.size;
            
                rectInSuperview = [self convertRect:self.collectionView.frame toView:[self superview]];
            
                frame.origin.y = rectInSuperview.origin.y;
            
                self.dragView = [[UIImageView alloc]initWithFrame:frame];
                self.dragView.image = cell.imageIV.image;
                [self addSubview:self.dragView];
            }
            
        }else if (panGestures.state != UIGestureRecognizerStateEnded && panGestures.state != UIGestureRecognizerStateFailed){
            
            //通过使用 locationInView 这个方法,来获取到手势的坐标
            CGPoint location = [panGestures locationInView:panGestures.view.superview];
            
            self.dragView.center = CGPointMake(self.dragView.center.x, location.y);
//
//            if (location.y <= -self.panCenter.y) {
//                [SHToast showWithText:@"松手发图" duration:1];
//            }
            
        }else if (panGestures.state == UIGestureRecognizerStateEnded){

            [self.dragView removeFromSuperview];
            
            CGPoint location = [panGestures locationInView:panGestures.view.superview];
            SHPhotoBrowserCell *cell = (SHPhotoBrowserCell *)panGestures.view;
            cell.alpha = 1;
            
            if (!self.isBecloud) {
                self.isBecloud = YES;
                [self.becloudView removeFromSuperview];
                if (location.y <= -self.panCenter.y) {
                    
                    CGSize size = [[SHPhotoManager manager] getImageCompressionWithAsset:cell.asset isOriginal:NO];
                    //进行图片处理发送
                    [[SHPhotoManager manager] fetchImageInAsset:cell.asset size:size isResize:YES completeBlock:^(NSData *data, NSString *fileType) {
                        
                        if ([SHPhotoCenter shareCenter].handle) {
                            [SHPhotoCenter shareCenter].handle(@[@[data,fileType?:@"jpg"]],NO);
                        }
                    }];
                }
            }
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.y) > fabs(translation.x);
    }
    return YES;
}

- (void)refreshDoneStatus {
    
    //设置完成
    if ([SHPhotoCenter shareCenter].selectedPhotos.count > 0) {
        [self.doneBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",@"完成",(unsigned long)[SHPhotoCenter shareCenter].selectedPhotos.count] forState:UIControlStateNormal];
        [self.doneBtn setBackgroundColor:BTNCOLOR];
        self.doneBtn.enabled = YES;
    }else {
        [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.doneBtn setBackgroundColor:[UIColor grayColor]];
        self.doneBtn.enabled = NO;
        
    }
    
    //设置编辑
    if ([SHPhotoCenter shareCenter].selectedPhotos.count == 1) {
        self.editBtn.enabled = YES;
        [self.editBtn setTitleColor:BTNCOLOR forState:UIControlStateNormal];
    }else{
        self.editBtn.enabled = NO;
        [self.editBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - 通知处理
- (void)reloadAllPhotos {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataSource = [SHPhotoCenter shareCenter].allPhotos;
        [self.collectionView reloadData];
    });
}

#pragma mark - 出现和消失
- (void)showPhotoPickerInSender:(UIViewController *)sender block:(void (^)(NSArray <NSArray *>*, BOOL))block {
    self.sender = sender;

    [self removeFromSuperview];
    [sender.view addSubview:self];
    [self configData];
    [SHPhotoCenter shareCenter].handle = block;
    [self refreshDoneStatus];
    //动画底部出现
    [self showFromBottom];
}

- (void)dismissPhotoPicker {
    //动画底部消失
    [self dismissToBottomWithCompleteBlock:^{
        [self removeFromSuperview];
        if ([SHPhotoCenter shareCenter].handle) {
            [SHPhotoCenter shareCenter].handle(nil,YES);
        }
    }];
}

- (void)dismissPhotoPickerWithoutAni {
    [self removeFromSuperview];
}

#pragma mark - collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count > self.preViewCount ? self.preViewCount : self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SHPhotoBrowserCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
    cell.asset = self.dataSource[indexPath.row];
    [self fetchImageFromAsset:self.dataSource[indexPath.row] completeBlock:^(NSData *data, NSString *fileType) {
        cell.imageIV.image = [UIImage imageWithData:data];
        [self changeCellSelBtnPosition];
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
            //调整位置
            NSInteger photoCount = weakSelf.dataSource.count > weakSelf.preViewCount ? weakSelf.preViewCount : weakSelf.dataSource.count;
            //取得当前cell的位置
            CGRect rect = [collectionView convertRect:weakCell.frame fromView:collectionView];
            CGPoint point = collectionView.contentOffset;
            float cellEndX = rect.origin.x + rect.size.width - point.x;
            //滚动到屏幕三分之二处
            if (cellEndX > SCREEN_W * 2 / 3) {
                float forwardLen;
                if (indexPath.item == photoCount - 1) {
                    forwardLen = cellEndX - SCREEN_W + Space;
                }else {
                    forwardLen = cellEndX - SCREEN_W * 2 / 3;
                }
                point.x += forwardLen;
                [collectionView setContentOffset:point animated:YES];
            }
        }else {
            [[SHPhotoCenter shareCenter].selectedPhotos removeObject:weakSelf.dataSource[indexPath.row]];
        }
        [weakSelf refreshDoneStatus];
    }];
    
    //图片点击
    [cell setImgTapBlock:^{
        [self.becloudView removeFromSuperview];
        SHPhotoPreviewer *previewer = [[SHPhotoPreviewer alloc]init];
        if (weakCell.selBtn.selected) {
            previewer.isPreviewSelectedPhotos = YES;
        }
        previewer.selectedAsset = weakSelf.dataSource[indexPath.row];
        [previewer setBackBlock:^(){
            [collectionView reloadData];
            [weakSelf refreshDoneStatus];
        }];
        [previewer setDoneBlock:^{
            [weakSelf dismissPhotoPickerWithoutAni];
        }];
        UINavigationController * NVC = [[UINavigationController alloc]initWithRootViewController:previewer];
        [weakSelf.sender presentViewController:NVC animated:YES completion:nil];
    }];
    
    //添加上滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGestures:)];
    pan.delegate = self;
    [cell addGestureRecognizer:pan];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateCellSizeFromAsset:self.dataSource[indexPath.row]];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, Space, 0, Space);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeCellSelBtnPosition];
}

#pragma mark - cell相关处理
- (void)changeCellSelBtnPosition {
    for (SHPhotoBrowserCell * cell in self.collectionView.visibleCells) {
        //获取每个cell在当前屏幕上的位置
        CGRect rect = [self convertRect:cell.frame fromView:_collectionView];
        //获取最右边的cell, 停在屏幕的边上
        if (rect.origin.x > SCREEN_W - cell.width) {
            //获取cell里的选择按钮在当前屏幕上的位置
            CGRect cellRect = [self convertRect:cell.selBtn.frame fromView:cell];
            //选择按钮在屏幕上固定的位置
            cellRect.origin.x = SCREEN_W - 25.0 - 1.0 - 5.0;
            //转化成在cell内的位置
            cellRect = [self convertRect:cellRect toView:cell];
            //如果在cell外则固定在左侧，如果在cell里则移动到相应的位置
            if (cellRect.origin.x < 1.0) {
                cellRect.origin.x = 1.0;
            }
            cell.selBtn.x = cellRect.origin.x;
        }
        //如果不是最右边, 则停在cell的右上角
        else {
            cell.selBtn.x = cell.width - Space - cell.selBtn.width;
        }
    }
}

#pragma mark - 图片Size
- (CGSize)calculateImgSizeFromAsset:(PHAsset *)asset {
    CGFloat scale = asset.pixelWidth / (CGFloat)asset.pixelHeight;
    CGFloat imgW = (self.collectionView.height - Space * 2) * scale;
    CGFloat imgH = self.collectionView.height - Space * 2;
    return CGSizeMake(imgW * 2, imgH * 2);
}

- (CGSize)calculateCellSizeFromAsset:(PHAsset *)asset {
    CGSize size = [self calculateImgSizeFromAsset:asset];
    return CGSizeMake(size.width / 2, size.height / 2);
}

- (void)fetchImageFromAsset:(PHAsset *)asset completeBlock:(void(^)(NSData *data, NSString *fileType))completeBlock {
    CGSize size = [self calculateImgSizeFromAsset:asset];
    [[SHPhotoManager manager]fetchImageInAsset:asset size:size isResize:NO completeBlock:^(NSData *data, NSString *fileType) {
        if (completeBlock) completeBlock(data, fileType);
    }];
}

#pragma mark - 相机点击
- (void)takePhoto {
    [[SHPhotoCenter shareCenter] cameraAuthoriationValidWithHandle:^{
        [self launchCamera];
    }];
}

- (void)launchCamera {
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        [self dismissPhotoPicker];
        return;
    }
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.sender presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //将该图像保存到媒体库中
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    //压缩图片 －> 以最长边为屏幕分辨率压缩
    CGSize size;
    CGFloat scale = image.size.width / image.size.height;
    if (scale > 1.0) {
        if (image.size.width < SCREEN_W) {
            //最长边小于屏幕宽度时，采用原图
            size = CGSizeMake(image.size.width, image.size.height);
        }else {
            size = CGSizeMake(SCREEN_W, SCREEN_W / scale);
        }
    }else {
        if (image.size.height < SCREEN_H) {
            //最长边小于屏幕高度时，采用原图
            size = CGSizeMake(image.size.width, image.size.height);
        }else {
            size = CGSizeMake(SCREEN_H * scale, SCREEN_H);
        }
        
    }
    image = [UIImage imageWithImage:image scaledToSize:size];
    [[SHPhotoCenter shareCenter] endPickWithImage:image info:info];
    [self dismissPhotoPickerWithoutAni];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissPhotoPickerWithoutAni];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 相册点击
- (void)albumBrowser {
    
    [self dismissPhotoPicker];
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {

        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *ale = [[UIAlertView alloc]initWithTitle:@"提示" message:@"开启权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [ale show];
        });
        return;
    }
    SHPhotoAblumList * ablumsList = [[SHPhotoAblumList alloc]init];
    ablumsList.assetCollections = [[SHPhotoManager manager]getAllAblums];
    UINavigationController * NVC = [[UINavigationController alloc]initWithRootViewController:ablumsList];
    //默认跳转到照片图册
    SHPhotoBrowser * browser = [[SHPhotoBrowser alloc]init];
    [ablumsList.navigationController pushViewController:browser animated:NO];
    
    [self.sender presentViewController:NVC animated:YES completion:nil];
}

#pragma mark - 原图点击
- (void)originalSwitch:(UIButton *)sender {
    sender.selected = !sender.selected;
    [SHPhotoCenter shareCenter].isOriginal = sender.selected;
}

#pragma mark - 编辑点击
- (void)editClick{
    
    [self dismissPhotoPicker];

}

#pragma mark - 完成
- (void)endPick {
    
    [[SHPhotoCenter shareCenter] endPick];
    [self dismissPhotoPicker];
}

#pragma clang diagnostic pop

@end
