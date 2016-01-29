//
//  MDBaseViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/21.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDBaseViewController.h"
#import "MDNavigationController.h"

@interface MDBaseViewController ()

@end

@implementation MDBaseViewController

@synthesize leftButton,rightButton,progressView,tabBarController,hidesBottomBarWhenPushed;

-(instancetype)init{
    if(self = [super init]){
        tabBarController = (RDVTabBarController*)APPDELEGATE.window.rootViewController;

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    progressView = [[LDProgressView alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:progressView];
    
    MDNavigationController *navigationController = (MDNavigationController*)self.navigationController;
    [navigationController setNormalBar];
    [self setupNavigationItem:self.navigationItem];
    [self.leftButton setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchDown];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [progressView removeFromSuperview];
    // Dispose of any resources that can be recreated.
}

#pragma mark action event methods
-(void)backTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark public methods
-(BOOL)validLogined{
    if(!APPDATA.isLogin){
        [self.view makeToast:@"您尚未登录" duration:1 position:CSToastPositionBottom];
        return NO;
    }
    return YES;
}


-(void)showAlertDialog:(NSString*)message{
    static UIAlertController *baseAlertController;
    static UIAlertView *baseAlertView;
    if(__IPHONE_SYSTEM_VERSION >= 8){
        if(!baseAlertView){
            baseAlertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [baseAlertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        }
        [baseAlertController setMessage:message];
        [self presentViewController:baseAlertController animated:YES completion:nil];
    }else{
        if(!baseAlertView){
            baseAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
        [baseAlertView setMessage:message];
        [baseAlertView show];
    }
}

#pragma mark private methods
/*!
 *  配置导航栏
 *
 *  @param navigationItem navigationItem对象
 */
-(void)setupNavigationItem:(UINavigationItem*)navigationItem{
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setContentMode:UIViewContentModeScaleToFill];
    if(__IPHONE_SYSTEM_VERSION > 7){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        navigationItem.leftBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:leftButton]];
    }
    else{
        [navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
    }
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 30)];
    if(__IPHONE_SYSTEM_VERSION > 7){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:rightButton]];
    }
    else{
        [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightButton]];
    }
}

-(void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed{
    [tabBarController setTabBarHidden:hidesBottomBarWhenPushed];
}

@end
