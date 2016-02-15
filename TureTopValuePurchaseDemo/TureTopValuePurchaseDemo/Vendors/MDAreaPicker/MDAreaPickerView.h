//
//  MDAreaPickerView.h
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/11/4.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDAreaPickerView : UIView

-(id)initWithProvince:(NSString*)province city:(NSString*)city district:(NSString*)district confirmBlock:(void(^)(NSString*,NSString*,NSString*))confirmBlock cancelBlock:(void(^)())cancelBlock;

- (void)showInView:(UIView *) view;
- (void)hideView;
@end
