//
//  ViewController.m
//  NavigationDemo
//
//  Created by smok on 16/11/17.
//  Copyright © 2016年 xinyuly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UILabel  *textLabel;
@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 60, 40)];
    [self.view addSubview:self.textLabel];
    self.textLabel.text = [NSString stringWithFormat:@"%d",self.navigationController.viewControllers.count];
    
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 200, 60, 40)];
    [self.nextButton addTarget:self action:@selector(nextViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setTitle:@"下一页" forState:UIControlStateNormal];
    [self.view addSubview:self.nextButton];
    self.nextButton.backgroundColor = [UIColor lightGrayColor];
}

- (void)nextViewController{
    ViewController *vc = [[ViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
