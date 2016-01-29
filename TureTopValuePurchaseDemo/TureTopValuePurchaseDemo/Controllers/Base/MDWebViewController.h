//
//  MDWebViewController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDWebViewController : MDBaseViewController

/*!
 *  网页请求路径
 */
@property(strong,nonatomic) NSString *requestURL;

/*!
 *  导航显示标题
 *  如果该标题为nil，则显示网页标题
 */
@property(strong,nonatomic) NSString *navigateTitle;

@end
