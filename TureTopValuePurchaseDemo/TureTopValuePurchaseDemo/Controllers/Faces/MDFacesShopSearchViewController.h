//
//  MDFacesShopSearchViewController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDFacesShopSearchViewController : MDBaseViewController
@property(nonatomic,strong,nullable) NSString *keyword;
@property(nonatomic,strong,nullable) void(^searchBlock)(NSString* _Nullable keyword);


@end
