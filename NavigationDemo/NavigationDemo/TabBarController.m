//
//  TabBarController.m
//  test
//
//  Created by smok on 16/10/24.
//  Copyright © 2016年 smok. All rights reserved.
//

#import "TabBarController.h"
#import "XYNavigationController.h"
#import "ViewController.h"

@interface TabBarController ()<UITabBarControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationController];
    self.delegate = self;
}

- (void)addNavigationController {
    
    ViewController *controller = [[ViewController alloc] init];
    controller.title = @"Scale";
    XYNavigationController *navController = [[XYNavigationController alloc]
                                             initWithRootViewController:controller];
    navController.view.backgroundColor = [UIColor whiteColor];
    navController.type = TransformTypeScale;
    [self addChildViewController:navController];
    
    
    ViewController *shopController = [[ViewController alloc] init];
    shopController.title = @"Normal";
    XYNavigationController *navController1 = [[XYNavigationController alloc] initWithRootViewController:shopController];
     navController1.view.backgroundColor = [UIColor whiteColor];
    navController1.type = TransformTypeNormal;
    [self addChildViewController:navController1];
    
    
    ViewController *reviewController = [[ViewController alloc] init];
    reviewController.title = @"Translation";
    XYNavigationController *navController2 = [[XYNavigationController alloc]
                                              initWithRootViewController:reviewController];
     navController2.view.backgroundColor = [UIColor whiteColor];
    navController2.type = TransformTypeTranslation;
    [self addChildViewController:navController2];
    
}

#pragma mark - tabBarDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    UIViewController *selectController = tabBarController.selectedViewController;
    if ([viewController isEqual:selectController]) {
        //refresh data
        return NO;
    }
    return YES;
}

@end
