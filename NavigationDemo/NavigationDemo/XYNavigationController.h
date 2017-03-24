//
//  XYNavigationController.h
//  NavigationDemo
//
//  Created by smok on 16/11/16.
//  Copyright © 2016年 xinyuly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,TransformType) {
    TransformTypeNormal,
    TransformTypeScale,
    TransformTypeTranslation
};

@interface XYNavigationController : UINavigationController <UIGestureRecognizerDelegate>

// default is YES
@property (nonatomic, assign) BOOL canDragBack;

// default is TransformTypeTranslation
@property (nonatomic, assign) TransformType type;

@end
