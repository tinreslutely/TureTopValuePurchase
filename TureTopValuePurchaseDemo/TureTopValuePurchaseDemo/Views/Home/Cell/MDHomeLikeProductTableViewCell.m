//
//  MDHomeLikeProductTableViewCell.m
//  TureTopValuePurchaseDemo
//  首页-广告功能视图
//  Created by 李晓毅 on 16/1/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHomeLikeProductTableViewCell.h"

@implementation MDHomeLikeProductTableViewCell

@synthesize imageView,titleLabel,priceLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(_Nullable id)target action:(SEL)action{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self bringLikeProductCellWidthTarget:target action:action];
    }
    return self;
}

/**
 *  生成一个包含两个产品显示信息的UIControl的UITableViewCell
 *  你可能喜欢模块
 *
 *  @param identifier Cell的identifier
 *
 *  @return UITableViewCell对象
 */
-(void)bringLikeProductCellWidthTarget:(_Nullable id)target action:(SEL)action{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    float width = SCREEN_WIDTH/2 - 15;
    float pointX = 10;
    [self createImageAndTwoTextForControlWithSuperView:self.contentView pointX:pointX width:width height:width+80 target:target action:action];
    pointX += width + 10;
    [self createImageAndTwoTextForControlWithSuperView:self.contentView pointX:pointX width:width height:width+80 target:target action:action];
}


/**
 *  创建一个包含图片和一个标题，一个价格的产品信息UIControl
 *  用于可能喜欢商品模块的商品显示
 *
 *  @param superView 所属父级
 *  @param pointX    x坐标
 *  @param width     控件宽度
 *  @param height    控件高度
 */
-(void)createImageAndTwoTextForControlWithSuperView:(UIView*)superView pointX:(float)pointX width:(float)width height:(float)height target:(_Nullable id)target action:(SEL)action{
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(pointX, 0, width, height)];
    [control addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:control];
    
    imageView = [[UIImageView alloc] init];
    [control addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(control.mas_top).with.offset(15);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
        make.height.mas_equalTo(width);
    }];
    
    titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [control addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(0);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont systemFontOfSize:14]];
    [priceLabel setTextColor:[UIColor redColor]];
    [control addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(0);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    
}

@end
