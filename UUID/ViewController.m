//
//  ViewController.m
//  UUID
//
//  Created by chenxiaosong on 2019/2/19.
//  Copyright © 2019年 chenxiaosong. All rights reserved.
//

#import "ViewController.h"

#import "Masonry.h"

#import "OpenUDID.h"

#import <AdSupport/AdSupport.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blueColor];
    label.numberOfLines = 3;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.center.equalTo(self.view);
    }];

    label.text = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
}


@end
