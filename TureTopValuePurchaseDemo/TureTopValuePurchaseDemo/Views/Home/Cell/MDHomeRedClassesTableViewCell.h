//
//  MDHomeRedClassesTableViewCell.h
//  TureTopValuePurchaseDemo
//  首页-推荐类别产品视图
//  Created by 李晓毅 on 16/1/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDHomeRedClassesTableViewCell : UITableViewCell

@property(nonatomic,strong,nullable) UILabel *navTitleLabel;
@property(nonatomic,strong,nullable) UIButton *bannerButtonView;
@property(nonatomic,strong,nullable) UIView *productsView;

-(instancetype _Nullable)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString* _Nullable)reuseIdentifier imageHeight:(float)imageHeight proImageHeight:(float)proImageHeight target:(_Nullable id)target rmMoreAction:(SEL _Nullable)rmMoreAction rmImageAction:(SEL _Nullable)rmImageAction rmProductDetailAction:(SEL _Nullable)rmProductDetailAction;

@end
