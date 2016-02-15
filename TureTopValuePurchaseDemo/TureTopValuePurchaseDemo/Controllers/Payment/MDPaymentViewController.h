//
//  MDPaymentViewController.h
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/12/15.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPaymentViewController : MDBaseViewController

@property(assign,nonatomic) int orderType;
@property(strong,nonatomic) NSString *orderCodes;

@end
