//
//  MDHomeRedClassesTableViewCell.h
//  TureTopValuePurchaseDemo
//  首页-推荐类别产品视图
//  Created by 李晓毅 on 16/1/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDHomeRedClassesTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *navTitleLabel;
@property(nonatomic,strong) UIButton *bannerButtonView;
@property(nonatomic,strong) UIView *productsView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageHeight:(float)imageHeight proImageHeight:(float)proImageHeight target:(_Nullable id)target rmMoreAction:(SEL)rmMoreAction rmImageAction:(SEL)rmImageAction rmProductDetailAction:(SEL)rmProductDetailAction;

@end
