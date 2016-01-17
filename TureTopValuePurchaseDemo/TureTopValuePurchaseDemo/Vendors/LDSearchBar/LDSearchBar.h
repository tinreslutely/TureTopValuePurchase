//
//  LDSearchBar.h
//  TureTopValuePurchaseDemo
//
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

@property(nonatomic,strong) UITextField *searchTextFiled;
@property(nonatomic,strong) UIButton *leftButton;
@property(nonatomic,strong) UIButton *rightButton;
@property(nonatomic,weak) id<LDSearchBarDelegate> delegate;

-(instancetype)initWithNavigationItem:(UINavigationItem*)navigationItem;
-(instancetype)initWithNavigationItem:(UINavigationItem*)navigationItem hasLeftButton:(BOOL)hasLeftButton;
@end
