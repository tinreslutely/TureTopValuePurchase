//
//  MDTabBarController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDTabBarController.h"
#import "MDNavigationController.h"

#import "MDPersonalCenterViewController.h"
#import "MDClassesViewController.h"
#import "MDShopManagementViewController.h"
#import "MDCartViewController.h"
#import "MDHomeViewController.h"

@interface MDTabBarController ()

@end

@implementation MDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabBarController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self setupTabBar];
}

#pragma mark private methods

-(void)setupTabBarController{
    
    [self addChildViewController:[[MDNavigationController alloc] initWithRootViewController:[[MDHomeViewController alloc] init]]];
    [self addChildViewController:[[MDNavigationController alloc] initWithRootViewController:[[MDClassesViewController alloc] init]]];
    [self addChildViewController:[[MDNavigationController alloc] initWithRootViewController:[[MDShopManagementViewController alloc] init]]];
    [self addChildViewController:[[MDNavigationController alloc] initWithRootViewController:[[MDCartViewController alloc] init]]];
    [self addChildViewController:[[MDNavigationController alloc] initWithRootViewController:[[MDPersonalCenterViewController alloc] init]]];
}

-(void)setupTabBar{
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TAB_COLOR} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:TAB_SELECTED_COLOR} forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setTintColor:GRAY_COLOR]; //设置导航字体的颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];  //设置导航的颜色
    
    UITabBarItem *tabBarItem;
    tabBarItem = [self.tabBar.items objectAtIndex:0];
    [tabBarItem setImage:[[UIImage imageNamed:@"home_tabbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:@"home_tabbar_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setTitle:@"首页"];
    
    
    tabBarItem = [self.tabBar.items objectAtIndex:1];
    [tabBarItem setImage:[[UIImage imageNamed:@"classes_tabbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:@"classes_tabbar_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setTitle:@"类目"];
    
    
    tabBarItem = [self.tabBar.items objectAtIndex:2];
    [tabBarItem setImage:[[UIImage imageNamed:@"shop_tabbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:@"shop_tabbar_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setTitle:@"店铺"];
    
    
    tabBarItem = [self.tabBar.items objectAtIndex:3];
    [tabBarItem setImage:[[UIImage imageNamed:@"cart_tabbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:@"cart_tabbar_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setTitle:@"购物车"];
    
    
    tabBarItem = [self.tabBar.items objectAtIndex:4];
    [tabBarItem setImage:[[UIImage imageNamed:@"personal_tabbar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:@"personal_tabbar_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setTitle:@"我的"];
}

@end
