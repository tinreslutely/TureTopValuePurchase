//
//  AppDelegate.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "AppDelegate.h"
#import "MDTabBarController.h"
#import "Reachability.h"
#import "MDLocationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    Reachability *_hostReach;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupWindow];
    [self setupCheckNetwork];
    
    [[MDLocationManager sharedManager] startUpdatingLocation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark private methods
/*!
 *  配置window
 */
-(void)setupWindow{
    MDTabBarController *rootViewController = [[MDTabBarController alloc] init];
    [rootViewController setupTabBarController];
    
    self.window = [[UIWindow alloc] initWithFrame:SCREEN_BOUNDS];
    [self.window setRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
}
/*!
 *  配置网络检查通知
 */
-(void)setupCheckNetwork{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _hostReach = [Reachability reachabilityWithHostName:@"weilinli.turetop.com"];
    [_hostReach startNotifier];
}
/*!
 *  网络状态检测方法
 *
 *  @param note 通知对象
 */
-(void)reachabilityChanged:(NSNotification*)note{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    switch (status) {
        case NotReachable:{
            if(APPDATA.networkStatus != -1){
                [self.window.rootViewController.navigationController.view makeToast:@"网络正在开小差哦~" duration:1 position:CSToastPositionBottom];
                APPDATA.networkStatus = -1;
            }
        }
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN:{
            if(APPDATA.networkStatus == -1){
                [self.window.rootViewController.navigationController.view makeToast:@"网络已经恢复啦~" duration:1 position:CSToastPositionBottom];
            }
            APPDATA.networkStatus = 2;
        }
            break;
        case ReachableVia2G:
        case ReachableVia3G:{
            if(APPDATA.networkStatus == -1){
                [self.window.rootViewController.navigationController.view makeToast:@"网络已经恢复啦~" duration:1 position:CSToastPositionBottom];
            }
            APPDATA.networkStatus = 0;
        }
            break;
        case ReachableVia4G:{
            if(APPDATA.networkStatus == -1){
                [self.window.rootViewController.navigationController.view makeToast:@"网络已经恢复啦~" duration:1 position:CSToastPositionBottom];
            }
            APPDATA.networkStatus = 1;
        }
            break;
    }
}
@end
