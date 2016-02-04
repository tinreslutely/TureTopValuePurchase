//
//  MDMessageTableViewCell.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/4.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDMessageTableViewCell.h"

@implementation MDMessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initiation];
    }
    return self;
}

-(void)initiation{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setTag:1001];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.contentView.frame.size.height-2, self.contentView.frame.size.height-2));
        make.left.equalTo(self.contentView.mas_left).with.offset(8);
        make.centerY.equalTo(self.contentView);
    }];
    
    UILabel *titleView = [[UILabel alloc] init];
    [titleView setTag:1002];
    [titleView setNumberOfLines:2];
    [titleView setFont:[UIFont systemFontOfSize:14]];
    [titleView setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).with.offset(8);
        make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        make.height.mas_equalTo(self.contentView.frame.size.height-2);
        make.centerY.equalTo(self.contentView);
    }];
}
@end
