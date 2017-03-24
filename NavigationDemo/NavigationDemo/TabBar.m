//
//  XYTabBar.m
//  test
//
//  Created by smok on 16/10/24.
//  Copyright © 2016年 smok. All rights reserved.
//

#import "TabBar.h"

@interface TabBar ()

@property (nonatomic, weak) UIButton *publishBtn;

@end

@implementation TabBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *plusBtn = [[UIButton alloc] init];
        UIImage *image = [UIImage imageNamed:@"tab_publish"];
        [plusBtn setImage:image forState:UIControlStateNormal];
        [plusBtn setImage:image forState:UIControlStateHighlighted];
        [plusBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
//        plusBtn.imageView.layer.cornerRadius = 20;
//        plusBtn.imageView.clipsToBounds = YES;
        self.publishBtn = plusBtn;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
   
    CGFloat tabBarButtonW  = self.bounds.size.width / 5;
    self.publishBtn.frame = CGRectMake(tabBarButtonW*2, 0, tabBarButtonW, self.bounds.size.height);
    
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.frame = CGRectMake(tabbarButtonIndex *tabBarButtonW, 0, tabBarButtonW, self.bounds.size.height);
            tabbarButtonIndex ++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex ++;
            }
        }
    }
}

- (void)publishAction {
    if ([self.tabDelegate respondsToSelector:@selector(tabBarDidClickPublishButton:)]) {
        [self.tabDelegate tabBarDidClickPublishButton:self.publishBtn];
    }
    
}

@end
