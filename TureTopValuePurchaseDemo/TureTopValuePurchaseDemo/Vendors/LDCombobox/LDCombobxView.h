//
//  LDCombobxView.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/31.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDCombobxView : UIView

@property(nonatomic,strong)UIView *contentView;

-(void)setBorderColor:(UIColor*)color;
-(void)setHasShadow:(BOOL)show;
@end
