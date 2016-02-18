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

@synthesize searchText,titleLabel,leftButton,rightButton,progressView,tabBarController,hidesBottomBarWhenPushed;

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
-(void)setupNavigationItem:(UINavigationItem* _Nullable)navigationItem{
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

/*!
 *  配置带搜索栏、左返回、右定位的导航栏
 *
 *  @param navigationItem navigationItem对象
 */
-(void)setupSearchNavigationItem:(UINavigationItem* _Nullable)navigationItem searchBarFrame:(CGRect)frame placeholder:(NSString* _Nullable)placeholder keyword:(NSString* _Nullable)keyword rightView:(UIView* _Nullable)rightView{
    //右侧
    if(__IPHONE_SYSTEM_VERSION > 7){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:rightView]];
    }
    else{
        [navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightView]];
    }
    navigationItem.titleView = [self bringSearchBarWithFrame:frame placeholder:placeholder keyword:keyword];
}

/*!
 *  配置普通的导航栏
 *
 *  @param navigationItem navigationItem对象
 */
-(UIView* _Nullable)setupCustomNormalNavigationBar{
    [self.navigationController setNavigationBarHidden:YES];
    
    UIView *navigationView = [[UIView alloc] init];
    [navigationView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(64);
    }];
    
    UILabel *bottomView = [[UILabel alloc] init];
    [bottomView setBackgroundColor:UIColorFromRGBA(170, 170, 170, 1)];
    [navigationView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navigationView.mas_left).with.offset(0);
        make.right.equalTo(navigationView.mas_right).with.offset(0);
        make.bottom.equalTo(navigationView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchDown];
    [navigationView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(navigationView.mas_top).with.offset(26);
        make.left.equalTo(navigationView.mas_left).with.offset(3);
    }];
    
    rightButton = [[UIButton alloc] init];
    [navigationView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(navigationView.mas_top).with.offset(26);
        make.right.equalTo(navigationView.mas_right).with.offset(-8);
    }];
    
    
    titleLabel = [[UILabel alloc] init];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [navigationView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.top.equalTo(navigationView.mas_top).with.offset(26);
        make.right.equalTo(rightButton.mas_left).with.offset(-5);
        make.left.equalTo(leftButton.mas_right).with.offset(3);
    }];
    
    return navigationView;
}

/*!
 *  配置自定义导航栏
 *
 *  @param navigationItem navigationItem对象
 */
-(UIView* _Nullable)setupCustomSearchNavigationWithPlaceholder:(NSString* _Nullable)placeholder keyword:(NSString* _Nullable)keyword{
    [self.navigationController setNavigationBarHidden:YES];
    
    UIView *navigationView = [[UIView alloc] init];
    [navigationView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.mas_equalTo(64);
    }];
    
    UILabel *bottomView = [[UILabel alloc] init];
    [bottomView setBackgroundColor:UIColorFromRGBA(170, 170, 170, 1)];
    [navigationView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navigationView.mas_left).with.offset(0);
        make.right.equalTo(navigationView.mas_right).with.offset(0);
        make.bottom.equalTo(navigationView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
    leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"arrow_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchDown];
    [navigationView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(navigationView.mas_top).with.offset(26);
        make.left.equalTo(navigationView.mas_left).with.offset(3);
    }];
    
    rightButton = [[UIButton alloc] init];
    [navigationView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(navigationView.mas_top).with.offset(26);
        make.right.equalTo(navigationView.mas_right).with.offset(-8);
    }];
    
    
    UIView *searchBarView = [self bringSearchBarWithPlaceholder:placeholder keyword:keyword];
    [searchBarView setTag:1001];
    [navigationView addSubview:searchBarView];
    [searchBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.top.equalTo(navigationView.mas_top).with.offset(26);
        make.right.equalTo(rightButton.mas_left).with.offset(-5);
        make.left.equalTo(leftButton.mas_right).with.offset(3);
    }];
    
    return navigationView;
}

/*!
 *  创建搜索栏
 *
 *  @return 返回搜索栏对象
 */
-(UIView*)bringSearchBarWithPlaceholder:(NSString*)placeholder keyword:(NSString*)keyword{
    UIView *searchBarView = [[UIView alloc] init];
    [searchBarView.layer setBorderColor:[UIColorFromRGBA(170, 170, 170, 1) CGColor]];
    [searchBarView.layer setBorderWidth:0.5];
    [searchBarView.layer setCornerRadius:2];
    [searchBarView.layer setMasksToBounds:YES];
    [searchBarView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *searchView = [[UIView alloc] init];
    [searchBarView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBarView.mas_top).with.offset(0);
        make.bottom.equalTo(searchBarView.mas_bottom).with.offset(0);
        make.left.equalTo(searchBarView.mas_left).with.offset(0);
        make.right.equalTo(searchBarView.mas_right).with.offset(0);
        
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setTag:1002];
    [imageView setImage:[UIImage imageNamed:@"icon_question_search"]];
    [searchView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.left.equalTo(searchView.mas_left).with.offset(8);
        make.centerY.equalTo(searchView);
    }];
    
    searchText = [[UITextField alloc] initWithFrame:CGRectZero];
    [searchText setTextAlignment:NSTextAlignmentLeft];
    [searchText setTextColor:[UIColor grayColor]];
    [searchText setFont:[UIFont systemFontOfSize:14]];
    [searchText setPlaceholder:placeholder];
    [searchText setTag:1003];
    [searchText setText:keyword];
    [searchView addSubview:searchText];
    [searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_top).with.offset(0);
        make.bottom.equalTo(searchView.mas_bottom).with.offset(0);
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(searchView.mas_right).with.offset(5);
    }];
    
    return searchBarView;
}

/*!
 *  创建搜索栏
 *
 *  @return 返回搜索栏对象
 */
-(UIView*)bringSearchBarWithFrame:(CGRect)frame placeholder:(NSString*)placeholder keyword:(NSString*)keyword{
    UIView *searchBarView = [[UIView alloc] initWithFrame:frame];
    [searchBarView.layer setBorderColor:[UIColorFromRGBA(170, 170, 170, 1) CGColor]];
    [searchBarView.layer setBorderWidth:0.5];
    [searchBarView.layer setCornerRadius:2];
    [searchBarView.layer setMasksToBounds:YES];
    [searchBarView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *searchView = [[UIView alloc] init];
    [searchBarView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBarView.mas_top).with.offset(0);
        make.bottom.equalTo(searchBarView.mas_bottom).with.offset(0);
        make.left.equalTo(searchBarView.mas_left).with.offset(0);
        make.right.equalTo(searchBarView.mas_right).with.offset(0);
        
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setTag:1002];
    [imageView setImage:[UIImage imageNamed:@"icon_question_search"]];
    [searchView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.left.equalTo(searchView.mas_left).with.offset(8);
        make.centerY.equalTo(searchView);
    }];
    
    searchText = [[UITextField alloc] initWithFrame:CGRectZero];
    [searchText setTextAlignment:NSTextAlignmentLeft];
    [searchText setTextColor:[UIColor grayColor]];
    [searchText setFont:[UIFont systemFontOfSize:14]];
    [searchText setPlaceholder:placeholder];
    [searchText setTag:1003];
    [searchText setText:keyword];
    [searchView addSubview:searchText];
    [searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_top).with.offset(0);
        make.bottom.equalTo(searchView.mas_bottom).with.offset(0);
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(searchView.mas_right).with.offset(5);
    }];
    
    return searchBarView;
}
-(void)setHidesBottomBarWhenPushed:(BOOL)hides{
    [tabBarController setTabBarHidden:hides];
}


@end
