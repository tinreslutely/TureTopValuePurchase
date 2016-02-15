//
//  MDLoginViewController.h
//  TureTopValuePurchaseDemo
//  用户登录控制器
//  Created by 李晓毅 on 16/1/22.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDLoginViewController : MDBaseViewController

@property (assign, nonatomic) int topIndex;
@property(strong,nonatomic) void(^loginAlterBlock)();

@end
