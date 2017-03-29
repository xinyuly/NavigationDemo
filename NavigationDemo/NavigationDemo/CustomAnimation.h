//
//  CustomAnimation.h
//  NavigationDemo
//
//  Created by smok on 16/11/16.
//  Copyright © 2016年 xinyuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation  navigationOperation;

@property (nonatomic, weak) UINavigationController * navigationController;

/**
 导航栏Pop多个控制器时，需删除了多张截图
 */
@property (nonatomic, assign) NSInteger  removeCount;

/**
 手势pop时，删除数组最后一张截图
 */
- (void)removeLastScreenShot;

/**
 移除全部截图
 */
- (void)removeAllScreenShot;

@end
