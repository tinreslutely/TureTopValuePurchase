//
//  MDNavigationController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDNavigationController.h"

@interface MDNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation MDNavigationController{
    UIView *_alphaView;
    BOOL _changing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if(self = [super initWithRootViewController:rootViewController]){
        CGRect frame = self.navigationBar.frame;
        _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height + 20)];
        _alphaView.backgroundColor = UIColorFromRGBA(251, 77, 2, 1);
        [self.view insertSubview:_alphaView belowSubview:self.navigationBar];
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow"] forBarMetrics:UIBarMetricsCompact];
        self.navigationBar.layer.masksToBounds = YES;
    }
    return self;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [super pushViewController:viewController animated:animated];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setAlpha];
    });
    
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if([viewController isKindOfClass:NSClassFromString(@"MDHomeViewController")]){
//        navigationController.navigationBar.barTintColor = UIColorFromRGBA(251, 77, 2, 1);
//        navigationController.navigationBar.alpha = 0.300;
//        navigationController.navigationBar.translucent = YES;
//    }else{
//        navigationController.navigationBar.alpha = 1;
//        navigationController.navigationBar.tintColor = nil;
//        navigationController.navigationBar.translucent = NO;
//    }
}

#pragma mark private methods
-(void)setAlpha{
    if (_changing == NO) {
        _changing = YES;
        [UIView animateWithDuration:1 animations:^{
            _alphaView.alpha = _alphaView.alpha == 0.0 ? 1.0 : 0.0;
        } completion:^(BOOL finished) {
            _changing = NO;
        }];
    }
}

@end
