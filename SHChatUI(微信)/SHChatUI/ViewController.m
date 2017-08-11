//
//  ViewController.m
//  SHChatUI
//
//  Created by CSH on 2016/10/24.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "ViewController.h"
#import "SHChatMessageViewController.h"

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
    
    UIStoryboard *chatViewSB=[UIStoryboard storyboardWithName:@"SHChatMessageViewController" bundle:nil];
    
    SHChatMessageViewController *chatView = [chatViewSB instantiateViewControllerWithIdentifier:@"SHChatMessageViewController"];

    
    [self.navigationController pushViewController:chatView animated:YES];
}

@end
