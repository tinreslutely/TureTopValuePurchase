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
#import "MDShopViewController.h"
#import "MDCartViewController.h"
#import "MDHomeViewController.h"

#import "MDMemberDataController.h"

#import "RDVTabBarItem.h"

@interface MDTabBarController ()

@end

@implementation MDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self setupTabBarController];
    [self setupTabBar];
    [self initUserData];
}

#pragma mark private methods

-(void)setupTabBarController{
    [self setViewControllers:@[
                                  [[MDNavigationController alloc] initWithRootViewController:[[MDHomeViewController alloc] init]],
                                  [[MDNavigationController alloc] initWithRootViewController:[[MDClassesViewController alloc] init]],
                                  [[MDNavigationController alloc] initWithRootViewController:[[MDShopViewController alloc] init]],
                                  [[MDNavigationController alloc] initWithRootViewController:[[MDCartViewController alloc] init]],
                                  [[MDNavigationController alloc] initWithRootViewController:[[MDPersonalCenterViewController alloc] init]]
                              ]];
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
    [self setSelectedIndex:0];
}

-(void)setupTabbarItemWithIndex:(NSInteger)index imageNamed:(NSString*)imageName selectedImageNamed:(NSString*)selectedImageName title:(NSString*)title{
    RDVTabBarItem *item = [self.tabBar.items objectAtIndex:index];
    [item setFinishedSelectedImage:[UIImage imageNamed:selectedImageName] withFinishedUnselectedImage:[UIImage imageNamed:imageName]];
    [item setUnselectedTitleAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:10], NSForegroundColorAttributeName: TAB_COLOR}];
    [item setSelectedTitleAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:10], NSForegroundColorAttributeName: TAB_SELECTED_COLOR}];
    [item setTitlePositionAdjustment:UIOffsetMake(0, 5)];
    [item setTitle:title];
}

/**
 *  每次进入app都去请求一次用户信息，判断用户是否已经登录
 */
-(void)initUserData{
    NSString* userId = [MDUserDefaultHelper readForKey:userIDKey];
    APPDATA.locationCity = [MDUserDefaultHelper readForKey:locationCityKey];
    APPDATA.locationLatitude = [MDUserDefaultHelper readForKey:locationLatitudeKey];
    APPDATA.locationLongitude = [MDUserDefaultHelper readForKey:locationLongitudeKey];
    if(userId == nil){
        APPDATA.isLogin = NO;
        return;
    }
    APPDATA.isLogin = YES;
    APPDATA.token = [MDUserDefaultHelper readForKey:tokenKey];
    APPDATA.userCode = [MDUserDefaultHelper readForKey:userCodeKey];
    APPDATA.userId = userId;
    [[[MDMemberDataController alloc] init] requestDataWithUserId:APPDATA.userId token:APPDATA.token completion:^(BOOL state, NSString *msg, MDMemberInfomationModel *model) {
        if(state){
            APPDATA.userName = model.nickName;
            APPDATA.sex = [MDCommon sexTextWithValue:model.sex];
            APPDATA.area = model.area;
            APPDATA.headPortrait = model.headPortrait;
            APPDATA.phone = model.phone;
        }else{
            APPDATA.isLogin = NO;
        }
    }];
}

@end
