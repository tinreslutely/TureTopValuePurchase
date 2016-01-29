//
//  MDPersonCenterInformationTableViewCell.m
//  TureTopValuePurchaseDemo
//  个人中心 - 显示头像、用户名、用户角色、收藏商品、收藏店铺等信息的UITableViewCell扩展类
//  Created by 李晓毅 on 16/1/26.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDPersonCenterInformationTableViewCell.h"

@implementation MDPersonCenterInformationTableViewCell

@synthesize headImageView,nameButton,roleButton,roleImageView,consigneeShopLabel,consigneeProductLabel,detailButton,consigneeProductControl,consigneeShopControl;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initView];
    }
    return self;
}

-(void)initView{
    int headWidth = 60;
    [self.contentView.layer setContents:(id)[UIImage imageNamed:@"head_info_bg"].CGImage];
    
    UIView *headView = [[UIView alloc] init];
    [headView.layer addSublayer:[self setImageViewShadowLayerWithSize:CGSizeMake(headWidth+2, headWidth+2)]];
    [self.contentView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(headWidth+2, headWidth+2));
        make.left.equalTo(self.contentView.mas_left).with.offset(40);
        make.top.equalTo(self.contentView.mas_top).with.offset(40);
    }];
    headImageView = [[UIImageView alloc] init];
    [headImageView setClipsToBounds:YES];
    [headImageView.layer setCornerRadius:headWidth/2];
    [headImageView.layer setMasksToBounds:YES];
    [headView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headView).with.insets(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
    
    nameButton = [[UIButton alloc] init];
    [nameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [nameButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:nameButton];
    [nameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 25));
        make.left.equalTo(headView.mas_right).with.offset(8);
        make.top.equalTo(self.contentView.mas_top).with.offset(45);
    }];
    
    roleImageView = [[UIImageView alloc] init];
    [roleImageView.layer setContents:(id)[UIImage imageNamed:@"center_identity"].CGImage];
    [headView addSubview:roleImageView];
    [roleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 15));
        make.top.equalTo(nameButton.mas_bottom).with.offset(5);
        make.left.equalTo(headView.mas_right).with.offset(8);
    }];
    
    roleButton = [[UIButton alloc] init];
    [roleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [roleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [roleButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:roleButton];
    [roleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.left.equalTo(roleImageView.mas_right).with.offset(8);
        make.top.equalTo(nameButton.mas_bottom).with.offset(0);
    }];
    
    float consigneeWidth = SCREEN_WIDTH/2;
    
    consigneeProductControl = [[UIControl alloc] init];
    [consigneeProductControl setBackgroundColor: UIColorFromRGBA(220, 220, 220, 0.5)];
    [self.contentView addSubview:consigneeProductControl];
    [consigneeProductControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(consigneeWidth, 60));
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
    
    consigneeProductLabel = [[UILabel alloc] init];
    [consigneeProductLabel setTextColor:[UIColor whiteColor]];
    [consigneeProductLabel setTextAlignment:NSTextAlignmentCenter];
    [consigneeProductLabel setFont:[UIFont systemFontOfSize:14]];
    [consigneeProductControl addSubview:consigneeProductLabel];
    [consigneeProductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.left.equalTo(consigneeProductControl.mas_left).with.offset(0);
        make.right.equalTo(consigneeProductControl.mas_right).with.offset(0);
        make.top.equalTo(consigneeProductControl.mas_top).with.offset(5);
    }];
    
    UILabel *consigneeProductTitleLabel = [[UILabel alloc] init];
    [consigneeProductTitleLabel setTextColor:[UIColor whiteColor]];
    [consigneeProductTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [consigneeProductTitleLabel setText:@"收藏的商品"];
    [consigneeProductTitleLabel setFont:[UIFont systemFontOfSize:14]];
    [consigneeProductControl addSubview:consigneeProductTitleLabel];
    [consigneeProductTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.left.equalTo(consigneeProductControl.mas_left).with.offset(0);
        make.right.equalTo(consigneeProductControl.mas_right).with.offset(0);
        make.bottom.equalTo(consigneeProductControl.mas_bottom).with.offset(-5);
    }];
    
    consigneeShopControl = [[UIControl alloc] init];
    [consigneeShopControl setBackgroundColor: UIColorFromRGBA(220, 220, 220, 0.5)];
    [self.contentView addSubview:consigneeShopControl];
    [consigneeShopControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(consigneeWidth, 60));
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
    consigneeShopLabel = [[UILabel alloc] init];
    [consigneeShopLabel setTextColor:[UIColor whiteColor]];
    [consigneeShopLabel setTextAlignment:NSTextAlignmentCenter];
    [consigneeShopLabel setFont:[UIFont systemFontOfSize:14]];
    [consigneeShopControl addSubview:consigneeShopLabel];
    [consigneeShopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.left.equalTo(consigneeShopControl.mas_left).with.offset(0);
        make.right.equalTo(consigneeShopControl.mas_right).with.offset(0);
        make.top.equalTo(consigneeShopControl.mas_top).with.offset(5);
    }];
    
    UILabel *consigneeShopTitleLabel = [[UILabel alloc] init];
    [consigneeShopTitleLabel setTextColor:[UIColor whiteColor]];
    [consigneeShopTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [consigneeShopTitleLabel setText:@"收藏的店铺"];
    [consigneeShopTitleLabel setFont:[UIFont systemFontOfSize:14]];
    [consigneeShopControl addSubview:consigneeShopTitleLabel];
    [consigneeShopTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.left.equalTo(consigneeShopControl.mas_left).with.offset(0);
        make.right.equalTo(consigneeShopControl.mas_right).with.offset(0);
        make.bottom.equalTo(consigneeShopControl.mas_bottom).with.offset(-5);
    }];
    
    detailButton = [[UIButton alloc] init];
    [detailButton setImage:[UIImage imageNamed:@"arrow_right_cb"] forState:UIControlStateNormal];
    [self.contentView addSubview:detailButton];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 24));
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.top.equalTo(self.contentView.mas_top).with.offset(70);
    }];
}
/*!
 *  设置阴影
 *
 *  @param size 控件尺寸
 *
 *  @return CALayer
 */
-(CALayer*)setImageViewShadowLayerWithSize:(CGSize)size{
    CALayer *layer = [CALayer layer];
    [layer setFrame: CGRectMake(0, 0, size.width, size.height)];
    [layer setCornerRadius:size.width/2];
    [layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [layer setShadowColor:[UIColor grayColor].CGColor];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowOpacity:0.8];
    return layer;
}
@end
