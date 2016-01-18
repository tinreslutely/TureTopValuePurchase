//
//  LDSearchPopTransition.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/18.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDSearchPopTransition.h"

@implementation LDSearchPopTransition

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toVC.view.alpha = 0.1;
    [toVC.navigationController setNavigationBarHidden:NO];
    [[transitionContext containerView] addSubview:toVC.view];
    //[[transitionContext containerView] bringSubviewToFront:fromVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [toVC.navigationController setNavigationBarHidden:NO animated:NO];
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
@end
