//
//  LDSearchBar.h
//  TureTopValuePurchaseDemo
//  导航栏搜索控件
//  Created by 李晓毅 on 16/1/13.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LDSearchBar;

@protocol LDSearchBarDelegate <NSObject>

@optional
-(void)searchBar:(LDSearchBar*)searchBar willStartEditingWithTextField:(UITextField*)textField;

@end


@interface LDSearchBar : UIView

@property(nonatomic,strong) UITextField *searchTextFiled;//搜索输入框
@property(nonatomic,strong) UIButton *leftButton;//左侧按钮
@property(nonatomic,strong) UIButton *rightButton;//右侧按钮
@property(nonatomic,weak) id<LDSearchBarDelegate> delegate;

-(instancetype)initWithNavigationItem:(UINavigationItem*)navigationItem;
-(instancetype)initWithNavigationItem:(UINavigationItem*)navigationItem hasLeftButton:(BOOL)hasLeftButton;
@end
