//
//  MDBaseViewController.h
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/21.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"
#import "RDVTabBarController.h"

@interface MDBaseViewController : UIViewController

@property(nonatomic,strong,nullable,readonly) UILabel *titleLabel;
@property(nonatomic,strong,nullable,readonly) UIButton *leftButton;
@property(nonatomic,strong,nullable,readonly) UIButton *rightButton;
@property(nonatomic,strong,nullable,readonly) LDProgressView *progressView;
@property(nonatomic,strong,nullable,readonly) RDVTabBarController *tabBarController;
@property(nonatomic,assign) BOOL hidesBottomBarWhenPushed;

-(BOOL)validLogined;
-(UIView* _Nullable)setupCustomNormalNavigationBar;
-( UIView* _Nullable)setupCustomSearchNavigationWithPlaceholder:(NSString* _Nullable)placeholder keyword:(NSString* _Nullable)keyword;
-(void)showAlertDialog:(NSString* __nullable)message;
@end
