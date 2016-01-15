//
//  MDHomeLikeProductTipTableViewCell.m
//  TureTopValuePurchaseDemo
//  首页-推荐产品提示视图
//  Created by 李晓毅 on 16/1/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHomeLikeProductTipTableViewCell.h"

@implementation MDHomeLikeProductTipTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self bringLikeProductTitleCell];
    }
    return self;
}

/**
 *  生成一个包含标题的UITableViewCell
 *  用于显示您可能喜欢的商品模块
 *
 *  @param identifier cell 的identifier
 *
 *  @return UITableViewCell
 */
-(void)bringLikeProductTitleCell{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel *bglabel = [[UILabel alloc] init];
    [bglabel.layer setBorderWidth:0.5];
    [bglabel.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self addSubview:bglabel];
    [bglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.centerY.equalTo(self);
    }];
    
    UILabel *titlelabel = [[UILabel alloc] init];
    [titlelabel setFont:[UIFont systemFontOfSize:14]];
    [titlelabel setTextAlignment:NSTextAlignmentCenter];
    [titlelabel setText:@"您可能喜欢的商品"];
    [titlelabel setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:titlelabel];
    [self bringSubviewToFront:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 30));
        make.center.equalTo(self);
    }];
}

@end
