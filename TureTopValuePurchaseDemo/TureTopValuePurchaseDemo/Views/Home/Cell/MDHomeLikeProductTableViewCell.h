//
//  MDHomeLikeProductTableViewCell.h
//  TureTopValuePurchaseDemo
//  首页-你可能喜欢栏目产品视图
//  Created by 李晓毅 on 16/1/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MDLikeProductControl : UIControl

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *priceLabel;

@end
@interface MDHomeLikeProductTableViewCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(_Nullable id)target action:(SEL)action;

@end
