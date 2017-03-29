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
    TransformTypeScale,//缩放模式
    TransformTypeTranslation //平移模式
};

@interface XYNavigationController : UINavigationController <UIGestureRecognizerDelegate,UINavigationControllerDelegate>

// default is YES
@property (nonatomic, assign) BOOL canDragBack;

// default is TransformTypeTranslation
@property (nonatomic, assign) TransformType type;

@end
