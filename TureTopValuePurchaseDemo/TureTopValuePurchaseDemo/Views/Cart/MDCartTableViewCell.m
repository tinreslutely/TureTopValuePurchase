//
//  MDCartTableViewCell.m
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/12/7.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import "MDCartTableViewCell.h"

@implementation MDCartTableViewCell

@synthesize checkButton,imageView,titleLabel,propertyLabel,priceLabel,numberBoxView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate:(id<NumberBoxViewDelegate>)delegate{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self bringCartCellForCartItemWithIdentifier:reuseIdentifier delegate:delegate];
    }
    return self;
}


-(void)bringCartCellForCartItemWithIdentifier:(NSString*)identifier delegate:(id<NumberBoxViewDelegate>)delegate{
    
    checkButton = [[CheckBoxButton alloc] initWithChecked:false];
    [self.contentView addSubview:checkButton];
    [checkButton setRadius:10];
    [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(20);//
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).with.offset(16);
    }];
    
    imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"01beauty"]];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkButton.mas_right).with.offset(8);
        make.top.equalTo(self.contentView.mas_top).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setNumberOfLines:2];
    [titleLabel setText:@""];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.top.equalTo(self.contentView.mas_top).with.offset(8);
        make.height.mas_equalTo(40);
    }];
    
    propertyLabel = [[UILabel alloc] init];
    [propertyLabel setFont:[UIFont systemFontOfSize:12]];
    [propertyLabel setTextColor:UIColorFromRGB(133, 133, 133)];
    [propertyLabel setText:@""];
    [self.contentView addSubview:propertyLabel];
    [propertyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(2);
        make.height.mas_equalTo(20);
    }];
    
    
    priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont systemFontOfSize:12]];
    [priceLabel setText:@"￥0.00"];
    [self.contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.top.equalTo(propertyLabel.mas_bottom).with.offset(2);
        make.height.mas_equalTo(20);
    }];
    
    numberBoxView = [[NumberBoxView alloc] initWithFrame:CGRectMake(0, 0, 100, 30) maxValue:9999 minValue:1];
    [numberBoxView setDelegate:delegate];
    [self.contentView addSubview:numberBoxView];
    [numberBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.top.equalTo(priceLabel.mas_bottom).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
}

@end
