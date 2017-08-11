//
//  SHBaseViewController.m
//  NewsReader
//
//  Created by KevinSH on 15/10/15.
//  Copyright (c) 2015年 KevinSH. All rights reserved.
//

#import "SHPhotoBaseController.h"
#import "SHPhotoHeader.h"

@implementation SHPhotoBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITECOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavbar];
}

#pragma mark - 导航栏
- (void)setupNavbar {
    self.navigationController.navigationBar.barTintColor = BTNCOLOR;
    self.navigationController.navigationBar.tintColor = WHITECOLOR;
    //隐藏导航栏下面的线
    [self.navigationController.navigationBar findHairlineImageViewUnder].hidden = YES;
    
    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithFrame:CGRectMake(0, 0, 22, 22) Target:self Selector:@selector(backBtnAction) Image:@"back.png" ImagePressed:@"back.png"]];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavigationTitle:(NSString *)title {
    self.title = title;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITECOLOR}];
}

@end
