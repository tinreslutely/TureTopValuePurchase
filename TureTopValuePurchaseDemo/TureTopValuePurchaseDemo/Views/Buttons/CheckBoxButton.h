//
//  CheckBoxButton.h
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/12/3.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxButton : UIButton

@property(assign,nonatomic) BOOL checked;
@property(assign,nonatomic) CGFloat radius;

-(id)initWithChecked:(BOOL)checked;

@end
