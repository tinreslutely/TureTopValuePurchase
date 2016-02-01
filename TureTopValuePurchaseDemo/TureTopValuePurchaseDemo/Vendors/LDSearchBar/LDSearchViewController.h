//
//  LDSearchViewController.h
//  TureTopValuePurchaseDemo
//  搜索界面控制器--实现跳转加载和返回消失的效果
//  Created by 李晓毅 on 16/1/16.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"
#import "LDCombobox.h"

@interface LDSearchViewController : UIViewController

@property(nonatomic,strong,nullable,readonly) LDProgressView *progressView;
@property(nonatomic,strong,nullable,readonly) LDCombobox *checkTypeControl;
@property(nonatomic,strong,nullable,readonly) UIView *navigationView;
@property(nonatomic,strong,nullable,readonly) UITextField *searchText;

@end
