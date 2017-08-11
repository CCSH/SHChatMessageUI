//
//  ViewController.m
//  SHChatUI
//
//  Created by CSH on 2017/8/11.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "ViewController.h"
#import "SHMessageMacroHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
    
    SHChatMessageViewController *chatVC = [[SHChatMessageViewController alloc]init];
    chatVC.chatId = @"123";
    chatVC.chatType = SHChatType_Chat;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

@end
