//
//  LDCombobox.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/29.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDCombobox : UIControl

@property(nonatomic,strong,readonly) UIView *comboboxView;

-(instancetype)initWithFrame:(CGRect)frame comboSuperView:(UIView*)superView items:(NSArray*)items;
@end
