//
//  CustomAnimation.m
//  NavigationDemo
//
//  Created by smok on 16/11/16.
//  Copyright © 2016年 xinyuly. All rights reserved.
//

#import "CustomAnimation.h"

#define TOP_VIEW      [[UIApplication sharedApplication] keyWindow].rootViewController.view
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CustomAnimation ()
/**
 截屏数组
 */
@property(nonatomic,strong)NSMutableArray * screenShotArray;
/**
 所属的导航栏有没有TabBarController
 */
@property (nonatomic,assign)BOOL isTabbar;

@end


@implementation CustomAnimation

- (void)removeAllScreenShot {
    [self.screenShotArray removeAllObjects];
}

- (void)removeLastScreenShot {
    [self.screenShotArray removeLastObject];
}

//截屏
- (UIImage *)capture {
    
    UIGraphicsBeginImageContextWithOptions(TOP_VIEW.bounds.size, TOP_VIEW.opaque, 0.0);
    [TOP_VIEW.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - UIViewControllerAnimatedTransitioning
// 动画时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.45;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIImageView * screentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIImage * screenImg = [self capture];
    screentImgView.image =screenImg;
//    screentImgView.backgroundColor = [UIColor redColor];
    
    //fromViewController,fromView
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //toViewController，toView
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    CGRect fromViewEndFrame = [transitionContext finalFrameForViewController:fromViewController];
    fromViewEndFrame.origin.x = kScreenWidth;
    CGRect fromViewStartFrame = fromViewEndFrame;
    CGRect toViewEndFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect toViewStartFrame = toViewEndFrame;
    
    UIView * containerView = [transitionContext containerView];
    
    if (self.navigationOperation == UINavigationControllerOperationPush) {
        [self.screenShotArray addObject:screenImg];
        
        //这句非常重要，没有这句，就无法正常Push和Pop出对应的界面
        [containerView addSubview:toView];
        toView.frame = toViewStartFrame;
        UIView * nextVC = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        
        //添加截图添加
        [self.navigationController.view.window insertSubview:screentImgView atIndex:0];
        
        nextVC.layer.shadowColor = [UIColor blackColor].CGColor;
        nextVC.layer.shadowOffset = CGSizeMake(-0.8, 0);
        nextVC.layer.shadowOpacity = 0.6;
        
        self.navigationController.view.transform = CGAffineTransformMakeTranslation(kScreenWidth, 0);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                             screentImgView.center = CGPointMake(-kScreenWidth/2, kScreenHeight / 2);
                         } completion:^(BOOL finished) {
                             [nextVC removeFromSuperview];
                             [screentImgView removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
        
    }
    if (self.navigationOperation == UINavigationControllerOperationPop) {
        
        fromViewStartFrame.origin.x = 0;
        [containerView addSubview:toView];
        UIImageView * lastVcImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        //Pop多个控制器
        if (_removeCount > 0) {
            for (NSInteger i = 0; i < _removeCount; i ++) {
                if (i == _removeCount - 1) {
                    //当删除到要跳转页面的截图时，不再删除，并将该截图作为ToVC的截图展示
                    lastVcImgView.image = [self.screenShotArray lastObject];
                    _removeCount = 0;
                    break;
                } else {
                    [self.screenShotArray removeLastObject];
                }
                
            }
        } else {
            lastVcImgView.image = [self.screenShotArray lastObject];
        }
        screentImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        screentImgView.layer.shadowOffset = CGSizeMake(-0.8, 0);
        screentImgView.layer.shadowOpacity = 0.6;
        [self.navigationController.view.window addSubview:lastVcImgView];
        [self.navigationController.view addSubview:screentImgView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            screentImgView.center = CGPointMake(kScreenWidth * 3 / 2 , kScreenHeight / 2);
            lastVcImgView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
            
        } completion:^(BOOL finished) {
            [lastVcImgView removeFromSuperview];
            [screentImgView removeFromSuperview];
            [self.screenShotArray removeLastObject];
            [transitionContext completeTransition:YES];
            
        }];
    }
    

}

#pragma mark - setter && getter
- (void)setNavigationController:(UINavigationController *)navigationController {
    _navigationController = navigationController;
    UIViewController *VC = navigationController.view.window.rootViewController;
    if (navigationController.tabBarController == VC) {
        self.isTabbar = YES;
    } else {
        self.isTabbar = NO;
    }
}

- (NSMutableArray *)screenShotArray {
    if (_screenShotArray == nil) {
        _screenShotArray = [[NSMutableArray alloc] init];
    }
    return _screenShotArray;
}

@end
