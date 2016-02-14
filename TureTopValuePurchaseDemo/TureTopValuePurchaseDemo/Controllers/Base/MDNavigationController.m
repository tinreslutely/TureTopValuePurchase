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
    UILabel *_bottomBorder;//
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
        
        _bottomBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, _alphaView.frame.size.height-0.5, frame.size.width, 0.5)];
        [_alphaView addSubview:_bottomBorder];
        
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
    //子控制器是否等于1，那么就需要隐藏tabbar
    if(self.viewControllers.count == 1 && ![viewController isKindOfClass:NSClassFromString(@"MDHapplyPurchaseViewController")]){
        [((RDVTabBarController*)APPDELEGATE.window.rootViewController) setTabBarHidden:YES];
    }
    [super pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated{
    //子控制器是否等于2，那么就需要显示tabbar
    if(self.viewControllers.count == 2){
        if(self.navigationBarHidden) [self setNavigationBarHidden:NO];
        [((RDVTabBarController*)APPDELEGATE.window.rootViewController) setTabBarHidden:NO];
    }
    return [super popViewControllerAnimated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //子控制器是否等于2，那么就需要显示tabbar
    if(self.viewControllers.count == 2){
        if(self.navigationBarHidden) [self setNavigationBarHidden:NO];
        [((RDVTabBarController*)APPDELEGATE.window.rootViewController) setTabBarHidden:NO];
    }
    return [super popToViewController:viewController animated:animated];
    
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    [((RDVTabBarController*)APPDELEGATE.window.rootViewController) setTabBarHidden:NO];
    if(self.navigationBarHidden) [self setNavigationBarHidden:NO];
    return [super popToRootViewControllerAnimated:animated];
}


-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if(operation == UINavigationControllerOperationPop){
        return nil;
    }
    return nil;
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([viewController isKindOfClass:NSClassFromString(@"MDHomeViewController")] || [viewController isKindOfClass:NSClassFromString(@"MDHapplyPurchaseViewController")]){
        _alphaView.backgroundColor = UIColorFromRGBA(251, 77, 2, 1);
        [_bottomBorder setBackgroundColor:UIColorFromRGBA(251, 77, 2, 1)];
        if(navigationController.navigationBarHidden == YES){
            [navigationController setNavigationBarHidden:NO];
        }
    }else{
        _alphaView.backgroundColor = UIColorFromRGBA(255, 255, 255, 1);
        [_bottomBorder setBackgroundColor:UIColorFromRGBA(170, 170, 170, 1)];
    }
}

#pragma mark private methods
-(void)setAlpha:(float)alphaValue{
    if(alphaValue > 0){
        _alphaView.alpha = alphaValue;
    }
}
-(void)setAlphaBar{
    _alphaView.backgroundColor = UIColorFromRGBA(251, 77, 2, 1);
    _alphaView.alpha = 0.001;
    [_bottomBorder setBackgroundColor:UIColorFromRGBA(251, 77, 2, 1)];
}

-(void)setNormalBar{
    _alphaView.backgroundColor = UIColorFromRGBA(255, 255, 255, 1);
    _alphaView.alpha = 1;
    [_bottomBorder setBackgroundColor:UIColorFromRGBA(170, 170, 170, 1)];
}

-(void)setNavigationBarHidden:(BOOL)navigationBarHidden{
    [super setNavigationBarHidden:navigationBarHidden];
    [_alphaView setHidden:navigationBarHidden];
}

@end
