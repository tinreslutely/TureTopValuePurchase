//
//  LDSearchViewController.m
//  TureTopValuePurchaseDemo
//  搜索界面控制器--实现跳转加载和返回消失的效果
//  Created by 李晓毅 on 16/1/16.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDSearchViewController.h"
#import "LDCombobox.h"

@interface LDSearchViewController ()


@end

@implementation LDSearchViewController{
    float _globalHeight;
}

@synthesize navigationView,searchText,progressView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupLDSearchData];
    [self setupLDSearchView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [progressView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [progressView removeFromSuperview];
}

#pragma mark action and event methods
/*!
 *  返回事件
 *
 *  @param button 触发事件的对象
 */
-(void)backTap:(UIButton*)button{
    [searchText resignFirstResponder];
    __weak typeof(self) weakSelf = self;
    UIView *searchView = [searchText superview];
    UIView *searchBarView = [searchView superview];
    UIView *checkTypeControl = [searchBarView viewWithTag:1001];
    
    [UIView animateWithDuration:0.2 animations:^{
        [searchBarView setFrame:CGRectMake(40, searchBarView.frame.origin.y, searchBarView.frame.size.width-30, 30)];
    } completion:^(BOOL finished) {
        if(finished){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(0.2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    [self animationTranslationWithView:searchView animationKey:@"translation-layer-left" duration:0.4 fromValue:0 toValue:-110 stopTime:0.2];
    [self animationTranslationWithView:checkTypeControl animationKey:@"translation-layer-left" duration:0.8 fromValue:0 toValue:-220 stopTime:0];
}

#pragma mark private methods
/*!
 *  初始化数据
 */
-(void)setupLDSearchData{
    _globalHeight = 30;
}

/*!
 *  初始化界面
 */
-(void)setupLDSearchView{
    
    progressView = [[LDProgressView alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:progressView];
    
    navigationView = [[UIView alloc] init];
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
    UIView *rightView = [[UIView alloc] init];
    [navigationView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.bottom.equalTo(bottomView.mas_top).with.offset(-6);
        make.right.equalTo(navigationView.mas_right).with.offset(-8);
    }];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal ];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(backTap:) forControlEvents:UIControlEventTouchDown];
    [rightView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, _globalHeight));
        make.bottom.equalTo(bottomView.mas_top).with.offset(-6);
        make.right.equalTo(navigationView.mas_right).with.offset(-8);
    }];
    [self animationScaleLayerWithView:cancelButton duration:0.2 fromValue:0.1 toValue:1];
    
    
    UIView *searchBarView = [self bringSearchBar];
    [navigationView addSubview:searchBarView];
    [searchBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_globalHeight);
        make.bottom.equalTo(bottomView.mas_top).with.offset(-6);
        make.right.equalTo(cancelButton.mas_left).with.offset(-5);
        make.left.equalTo(navigationView.mas_left).with.offset(40);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            [searchBarView setFrame:CGRectMake(10, searchBarView.frame.origin.y, searchBarView.frame.size.width+30, _globalHeight)];
        } completion:^(BOOL finished) {
            if(finished){
               [searchText becomeFirstResponder];
                
                //添加清除输入内容按钮
                float height = _globalHeight / 2;
                UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(searchBarView.frame.size.width-height-5, height/2, height, height)];
                [clearButton setImage:[UIImage imageNamed:@"search_close"] forState:UIControlStateNormal];
                [clearButton setContentMode:UIViewContentModeScaleAspectFit];
                [searchBarView addSubview:clearButton];
                [self animationScaleLayerWithView:clearButton duration:0.2 fromValue:0.1 toValue:1];
            }
            if(finished) [searchText becomeFirstResponder];
            [UIView animateWithDuration:1 animations:^{
                [cancelButton setFrame:CGRectMake(0, 0, 30, 30)];
                [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
            }];
        }];
    });
}

/*!
 *  创建搜索栏
 *
 *  @return 返回搜索栏对象
 */
-(UIView*)bringSearchBar{
    UIView *searchBarView = [[UIView alloc] init];
    [searchBarView.layer setBorderColor:[UIColorFromRGBA(170, 170, 170, 1) CGColor]];
    [searchBarView.layer setBorderWidth:0.5];
    [searchBarView.layer setCornerRadius:2];
    [searchBarView.layer setMasksToBounds:YES];
    [searchBarView setBackgroundColor:[UIColor whiteColor]];
    
//    UIControl *checkTypeControl = [[UIControl alloc] init];
//    [checkTypeControl setTag:1001];
//    [searchBarView addSubview:checkTypeControl];
//    [searchBarView sendSubviewToBack:checkTypeControl];
//    [checkTypeControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(60, _globalHeight));
//        make.left.equalTo(searchBarView.mas_left).with.offset(0);
//        make.top.equalTo(searchBarView.mas_top).with.offset(0);
//    }];
//    
//    UILabel *typeLabel = [[UILabel alloc] init];
//    [typeLabel setText:@"商品"];
//    [typeLabel setTextColor:UIColorFromRGB(161, 161, 161)];
//    [typeLabel setTextAlignment:NSTextAlignmentCenter];
//    [typeLabel setFont:[UIFont systemFontOfSize:12]];
//    [checkTypeControl addSubview:typeLabel];
//    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(32, _globalHeight));
//        make.top.equalTo(checkTypeControl.mas_top).with.offset(0);
//        make.left.equalTo(checkTypeControl.mas_left).with.offset(8);
//    }];
//    
//    UILabel *spaceLabel = [[UILabel alloc] init];
//    [spaceLabel setBackgroundColor:UIColorFromRGB(161, 161, 161)];
//    [checkTypeControl addSubview:spaceLabel];
//    [spaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(0.5);
//        make.right.equalTo(checkTypeControl.mas_right).with.offset(0);
//        make.top.equalTo(checkTypeControl.mas_top).with.offset(0);
//        make.bottom.equalTo(checkTypeControl.mas_bottom).with.offset(0);
//        
//    }];
//    
//    UIImageView *typeImageView = [[UIImageView alloc] init];
//    [typeImageView setImage:[UIImage imageNamed:@"arrow_bottom_b"]];
//    [checkTypeControl addSubview:typeImageView];
//    [typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(10, 5));
//        make.right.equalTo(spaceLabel.mas_left).with.offset(-8);
//        make.centerY.equalTo(checkTypeControl);
//    }];
    LDCombobox *checkTypeControl = [[LDCombobox alloc] initWithFrame:CGRectZero comboSuperView:self.view items:@[@{@"key":@"商品",@"value":@"0"},@{@"key":@"店铺",@"value":@"1"}]];
    [checkTypeControl setTag:1001];
    [searchBarView addSubview:checkTypeControl];
    [searchBarView sendSubviewToBack:checkTypeControl];
    [checkTypeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, _globalHeight));
        make.left.equalTo(searchBarView.mas_left).with.offset(0);
        make.top.equalTo(searchBarView.mas_top).with.offset(0);
    }];
    [self animationTranslationWithView:checkTypeControl animationKey:@"translation-layer-right" duration:0.2 fromValue:-60 toValue:0 stopTime:0];
    
    UIView *searchView = [[UIView alloc] init];
    [searchBarView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBarView.mas_top).with.offset(0);
        make.bottom.equalTo(searchBarView.mas_bottom).with.offset(0);
        make.left.equalTo(checkTypeControl.mas_right).with.offset(0);
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
    [searchText setPlaceholder:@"搜索商品和店铺"];
    [searchView addSubview:searchText];
    [searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_top).with.offset(0);
        make.bottom.equalTo(searchView.mas_bottom).with.offset(0);
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(searchView.mas_right).with.offset(5);
    }];
    
    return searchBarView;
}

#pragma mark animation methods
/*!
 *  控件按比例放大缩小动画
 *
 *  @param view      指定控件
 *  @param duration  动画时间
 *  @param fromValue 起始比例
 *  @param toValue   最终比例
 */
-(void)animationScaleLayerWithView:(UIView*)view duration:(float)duration fromValue:(float)fromValue toValue:(float)toValue{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = duration;
    animation.repeatCount = 1;
    animation.autoreverses = NO;
    
    animation.fromValue = [NSNumber numberWithFloat:fromValue];
    animation.toValue = [NSNumber numberWithFloat:toValue];
    [view.layer addAnimation:animation forKey:@"scale-layer"];
}

/*!
 *  控件水平方向移动动画
 *
 *  @param view         指定的控件
 *  @param animationKey 控件的动画Key
 *  @param duration     动画时间
 *  @param fromValue    起始位置
 *  @param toValue      终点位置
 *  @param stopTime     暂停时间（如果时间小于0，则不需要暂停）
 */
-(void)animationTranslationWithView:(UIView*)view animationKey:(NSString*)animationKey duration:(float)duration fromValue:(float)fromValue toValue:(float)toValue stopTime:(float)stopTime{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.duration = duration;
    animation.repeatCount = 1;
    animation.autoreverses = NO;
    animation.fromValue = [NSNumber numberWithFloat:fromValue];
    animation.toValue = [NSNumber numberWithFloat:toValue];
    [view.layer addAnimation:animation forKey:animationKey];
    if(stopTime > 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(stopTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CFTimeInterval timeInterval = [view.layer convertTime:CACurrentMediaTime() fromLayer:nil];
            view.layer.speed = 0;
            view.layer.timeOffset = timeInterval;
        });
    }
}

@end
