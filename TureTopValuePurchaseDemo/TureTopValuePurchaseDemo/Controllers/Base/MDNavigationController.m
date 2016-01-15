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
    UILabel *bottomBorder;//
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
        
        bottomBorder = [[UILabel alloc] initWithFrame:CGRectMake(0, _alphaView.frame.size.height-0.5, frame.size.width, 0.5)];
        [_alphaView addSubview:bottomBorder];
        
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
    
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([viewController isKindOfClass:NSClassFromString(@"MDHomeViewController")]){
        _alphaView.backgroundColor = UIColorFromRGBA(251, 77, 2, 1);
        [bottomBorder setBackgroundColor:UIColorFromRGBA(251, 77, 2, 1)];
    }else{
        _alphaView.backgroundColor = UIColorFromRGBA(255, 255, 255, 1);
        [bottomBorder setBackgroundColor:UIColorFromRGBA(170, 170, 170, 1)];
    }
}

#pragma mark private methods
-(void)setAlpha:(float)alphaValue{
    if(alphaValue > 0){
        _alphaView.alpha = alphaValue;
    }
}

@end
