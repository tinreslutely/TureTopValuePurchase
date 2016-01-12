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
    
    [self setupTabbarItemWithIndex:0 imageNamed:@"home_tabbar" selectedImageNamed:@"home_tabbar_selected" title:@"首页"];
    [self setupTabbarItemWithIndex:1 imageNamed:@"classes_tabbar" selectedImageNamed:@"classes_tabbar_selected" title:@"类目"];
    [self setupTabbarItemWithIndex:2 imageNamed:@"shop_tabbar" selectedImageNamed:@"shop_tabbar_selected" title:@"店铺"];
    [self setupTabbarItemWithIndex:3 imageNamed:@"cart_tabbar" selectedImageNamed:@"cart_tabbar_selected" title:@"购物车"];
    [self setupTabbarItemWithIndex:4 imageNamed:@"personal_tabbar" selectedImageNamed:@"personal_tabbar_selected" title:@"我的"];
}

-(void)setupTabbarItemWithIndex:(NSInteger)index imageNamed:(NSString*)imageName selectedImageNamed:(NSString*)selectedImageName title:(NSString*)title{
    UITabBarItem *tabBarItem = [self.tabBar.items objectAtIndex:index];
    [tabBarItem setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setTitle:title];
}

@end
