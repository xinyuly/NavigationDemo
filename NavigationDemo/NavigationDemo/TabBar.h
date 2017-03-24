//
//  XYTabBar.h
//  test
//
//  Created by smok on 16/10/24.
//  Copyright © 2016年 smok. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBar;

@protocol TabBarDelegate <UITabBarDelegate>

@optional
- (void)tabBarDidClickPublishButton:(UIButton *)button;

@end

@interface TabBar : UITabBar

@property (nonatomic, weak) id <TabBarDelegate> tabDelegate;

@end
