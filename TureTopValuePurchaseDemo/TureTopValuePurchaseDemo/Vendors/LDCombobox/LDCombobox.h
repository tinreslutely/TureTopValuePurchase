//
//  LDCombobox.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/29.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDCombobxView.h"

@class LDCombobox;

@protocol LDComboboxDelegate <NSObject>

@optional
-(void)combobox:(LDCombobox*)combobox didSelectedRowValue:(NSDictionary*)value;

@end

@interface LDCombobox : UIControl

@property(nonatomic,strong,readonly) LDCombobxView *comboboxView;
@property(nonatomic,assign) BOOL dropState;
@property(nonatomic,strong) id<LDComboboxDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame comboSuperView:(UIView*)superView items:(NSArray*)items;
-(void)drop;
-(void)dropUpWithAnimation:(BOOL)animation;
@end
