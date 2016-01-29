//
//  NumberBoxView.h
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/12/3.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NumberBoxView;
@protocol NumberBoxViewDelegate <NSObject>

@optional
-(void)numberBoxView:(NumberBoxView*)numberBoxView shouldValueChangedInNumber:(int)number;

@end

@interface NumberBoxView : UIView

@property(assign,nonatomic) int number;
@property(weak,nonatomic) id<NumberBoxViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame maxValue:(int)maxValue minValue:(int)minValue;

@end
