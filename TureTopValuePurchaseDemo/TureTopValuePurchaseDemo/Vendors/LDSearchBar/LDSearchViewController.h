//
//  LDSearchViewController.h
//  TureTopValuePurchaseDemo
//  搜索界面控制器--实现跳转加载和返回消失的效果
//  Created by 李晓毅 on 16/1/16.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"

@interface LDSearchViewController : UIViewController

@property(nonatomic,strong,nullable,readonly) LDProgressView *progressView;
@property(nonatomic,strong) UIView *navigationView;
@property(nonatomic,strong) UITextField *searchText;

@end
