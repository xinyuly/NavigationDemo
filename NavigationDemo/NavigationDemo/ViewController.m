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
    self.view.backgroundColor =  [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    if (self.navigationController.viewControllers.count > 1 ) {
        [self showLeftBarItem:@"icon_nav_back" highlightedImage:@"icon_nav_back" selector:@selector(back)];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(60, 400, 100, 40)];
    [button setTitle:@"回到首页" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nextViewController{
    ViewController *vc = [[ViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)popViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
   
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showLeftBarItem:(NSString *)imageName highlightedImage:(NSString *)imageNameH selector:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 32, 32)];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageNameH] forState:UIControlStateHighlighted];
    if (selector) {
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

@end
