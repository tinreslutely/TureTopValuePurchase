//
//  MDHomeBannerFoundationTableViewCell.m
//  TureTopValuePurchaseDemo
//  首页-广告功能视图
//  Created by 李晓毅 on 16/1/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHomeBannerFoundationTableViewCell.h"

@implementation MDHomeBannerFoundationTableViewCell

@synthesize bannerView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier bannerHeight:(float)bannerHeight delegate:(id<SDCycleScrollViewDelegate>)delegate target:(_Nullable id)target action:(SEL)action{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self bringBannerAndIconButtonForCellWithBannerHeight:bannerHeight delegate:delegate target:target action:action];
    }
    return self;
}


/**
 *  生成一个包含banner控件和由五个功能按钮组成的UIView的UITableViewCell
 *
 *  @param bannerHeight banner控件的高度
 *  @param delegate     SDCycleScrollView协议
 *  @param target       目标控制器
 *  @param action       功能按钮点击事件
 *
 *  @return UITableViewCell对象
 */
-(void)bringBannerAndIconButtonForCellWithBannerHeight:(float)bannerHeight delegate:(id<SDCycleScrollViewDelegate>)delegate  target:(_Nullable id)target action:(SEL)action{
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, bannerHeight) delegate:delegate placeholderImage:nil];
    bannerView.infiniteLoop = YES;
    bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    bannerView.autoScrollTimeInterval = 4.0;
    [self addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, bannerHeight));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    UIView *view = [[UIView alloc] init];
    [self addSubview: view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bannerView.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
    
    CGFloat width = SCREEN_WIDTH/3;
    CGFloat height = 60;
    CGFloat iconSize = 40;
    int point_x = 0;
    int point_y = 12;
    [self createIconAndTitleForControlWithSuperView:view title:@"面对面支付" icon:@"h_facespay" target:target action:action rect:CGRectMake(point_x, point_y, width, height) iconSize:iconSize];
    point_x += width;
    [self createIconAndTitleForControlWithSuperView:view title:@"快乐购" icon:@"h_happlybuy" target:target action:action rect:CGRectMake(point_x, point_y, width, height) iconSize:iconSize];
    point_x += width;
    [self createIconAndTitleForControlWithSuperView:view title:@"我要购卡" icon:@"h_buycard" target:target action:action rect:CGRectMake(point_x, point_y, width, height) iconSize:iconSize];
    point_y += 72;
    point_x = 0;
    [self createIconAndTitleForControlWithSuperView:view title:@"开通资格" icon:@"h_opencerfiticate" target:target action:action rect:CGRectMake(point_x, point_y, width, height) iconSize:iconSize];
    point_x += width;
    [self createIconAndTitleForControlWithSuperView:view title:@"铭道书院" icon:@"h_mdschool" target:target action:action rect:CGRectMake(point_x, point_y, width, height) iconSize:iconSize];
}


/**
 *  创建一个包含一个UIImageView和一个UILabel，上下层级的UIControl
 *
 *  @param superView 所属父级
 *  @param title     显示的文本内容
 *  @param icon      图标路径
 *  @param target    目标
 *  @param action    事件
 *  @param rect      CGRect属性
 *  @param iconSize  图标大小
 */
-(void)createIconAndTitleForControlWithSuperView:(UIView*)superView title:(NSString*)title icon:(NSString*)icon target:(_Nullable id)target action:(SEL)action rect:(CGRect)rect iconSize:(float)iconSize {
    UIControl *control = [[UIControl alloc] initWithFrame:rect];
    [control addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:control];
    
    //添加一个imageview
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:icon]];
    [control addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
        make.top.equalTo(control.mas_top).with.offset(0);
        make.centerX.equalTo(control);
    }];
    //添加一个文本label
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:14]];
    [control addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(21);
        make.top.equalTo(imageView.mas_bottom).with.offset(5);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
    }];
}
@end
