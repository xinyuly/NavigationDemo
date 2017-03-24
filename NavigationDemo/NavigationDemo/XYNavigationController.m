//
//  XYNavigationController.m
//  NavigationDemo
//
//  Created by smok on 16/11/16.
//  Copyright © 2016年 xinyuly. All rights reserved.
//

#import "XYNavigationController.h"
#import <QuartzCore/QuartzCore.h>

#define KEY_WINDOW   [[UIApplication sharedApplication]keyWindow]
#define TOP_VIEW     [[UIApplication sharedApplication]keyWindow].rootViewController.view
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//Maximum width to move
static CGFloat kMAXWidth = 320;

@interface XYNavigationController ()

@property (nonatomic, assign) CGPoint startTouch;
@property (nonatomic, strong) UIView *blackMask;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView    *lastScreenShotView;
@property (nonatomic, strong) NSMutableArray *screenShotsList;
@property (nonatomic, assign) BOOL isMoving;

@end

@implementation XYNavigationController

- (void)dealloc {
    self.screenShotsList = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = YES;
        self.type = TransformTypeTranslation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)];
    panRecognizer.delegate = self;
    [panRecognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:panRecognizer];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:(BOOL)animated];
    
    if (self.screenShotsList.count == 0) {
        UIImage *capturedImage = [self capture];
        if (capturedImage) {
            [self.screenShotsList addObject:capturedImage];
        }
    }
}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UIImage *capturedImage = [self capture];
    if (capturedImage) {
        [self.screenShotsList addObject:capturedImage];
    }
    [super pushViewController:viewController animated:animated];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self.screenShotsList removeLastObject];
    
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods
// get the current view screen shot
- (UIImage *)capture {
    
    UIGraphicsBeginImageContextWithOptions(TOP_VIEW.bounds.size, TOP_VIEW.opaque, 0.0);
    [TOP_VIEW.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x {
    
//    NSLog(@"Move to:%f",x);
    x = x>kMAXWidth ? kMAXWidth:x;
    x = x<0 ? 0:x;
    
    CGRect frame = TOP_VIEW.frame;
    frame.origin.x = x;
    TOP_VIEW.frame = frame;
    
    float scale = (x/6400)+0.95;
    float alpha = 0.4 - (x/800);
    _blackMask.alpha = alpha;
    
    if (self.type == TransformTypeScale) {
        _lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    } else if (self.type == TransformTypeTranslation) {
        x = -kScreenWidth*0.6 + x/1.3;
        x = (x > 0) ? 0 : x ;
        _lastScreenShotView.transform = CGAffineTransformMakeTranslation(x, 0);
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.viewControllers.count <= 1 || !self.canDragBack) {
        
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        [self paningGestureReceive:(UIPanGestureRecognizer*)gestureRecognizer];
        return YES;
    }
    return YES;

}
#pragma mark - Gesture Recognizer
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer {
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) {
        return;
    }
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        _isMoving = YES;
        _startTouch = touchPoint;
        
        if (!self.backgroundView) {
            CGRect frame = TOP_VIEW.frame;
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [TOP_VIEW.superview insertSubview:self.backgroundView belowSubview:TOP_VIEW];
            
            _blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            _blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:_blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (_lastScreenShotView) {
            
            [_lastScreenShotView removeFromSuperview];
        }
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        _lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:_lastScreenShotView belowSubview:_blackMask];
        
        //End paning, always check that if it should move right or move left automatically
    } else if (recoginzer.state == UIGestureRecognizerStateEnded) {
        
        if (touchPoint.x - _startTouch.x > 50) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:kMAXWidth];
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                CGRect frame = TOP_VIEW.frame;
                frame.origin.x = 0;
                TOP_VIEW.frame = frame;
                _isMoving = NO;
                self.backgroundView.hidden = YES;
                
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    } else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - _startTouch.x];
    }
}
 
@end
