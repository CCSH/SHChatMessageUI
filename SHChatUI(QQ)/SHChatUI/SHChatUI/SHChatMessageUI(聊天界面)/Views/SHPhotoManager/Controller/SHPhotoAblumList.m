//
//  SHPhotoBrowser.m
//  LazyWeather
//
//  Created by KevinSH on 15/12/6.
//  Copyright © 2015年 SHXiaoMing. All rights reserved.
//

#import "SHPhotoAblumList.h"
#import "SHPhotoHeader.h"
#import "SHPhotoAblumCell.h"

@interface SHPhotoAblumList ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation SHPhotoAblumList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"手机"];
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    [self setupCancelBtn];
}

- (void)setupCancelBtn {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnAction)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)cancelBtnAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assetCollections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHPhotoAblumCell * cell = [SHPhotoAblumCell cellForTableView:tableView info:self.assetCollections[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat {
    return 62.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SHPhotoBrowser * browser = [[SHPhotoBrowser alloc]init];
    SHAblumInfo * info = self.assetCollections[indexPath.row];
    browser.assetCollection = info.assetCollection;
    browser.collectionTitle = info.ablumName;
    [self.navigationController pushViewController:browser animated:YES];
}

@end
