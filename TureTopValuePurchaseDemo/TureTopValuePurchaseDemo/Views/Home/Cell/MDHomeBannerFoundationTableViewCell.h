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

@property(nonatomic,strong) SDCycleScrollView* _Nullable bannerView;

-(instancetype _Nullable)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString* _Nullable)reuseIdentifier bannerHeight:(float)bannerHeight delegate:(id<SDCycleScrollViewDelegate> _Nullable)delegate target:(id _Nullable)target action:(SEL _Nullable)action;

@end
