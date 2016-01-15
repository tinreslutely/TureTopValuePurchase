//
//  MDHomeBannerFoundationTableViewCell.h
//  TureTopValuePurchaseDemo
//  首页-广告功能视图
//  Created by 李晓毅 on 16/1/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface MDHomeBannerFoundationTableViewCell : UITableViewCell

@property(nonatomic,strong) SDCycleScrollView *bannerView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier bannerHeight:(float)bannerHeight delegate:(id<SDCycleScrollViewDelegate>)delegate target:(_Nullable id)target action:(SEL)action;

@end
