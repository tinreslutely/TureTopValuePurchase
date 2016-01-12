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

@implementation MDNavigationController

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

@end
