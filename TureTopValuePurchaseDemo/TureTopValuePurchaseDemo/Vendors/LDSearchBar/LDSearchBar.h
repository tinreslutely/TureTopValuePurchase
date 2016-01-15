//
//  LDSearchBar.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/13.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDSearchBar : UIView

@property(nonatomic,strong) UIButton *leftButton;
@property(nonatomic,strong) UIButton *rightButton;

-(instancetype)initWithNavigationItem:(UINavigationItem*)navigationItem;

@end
