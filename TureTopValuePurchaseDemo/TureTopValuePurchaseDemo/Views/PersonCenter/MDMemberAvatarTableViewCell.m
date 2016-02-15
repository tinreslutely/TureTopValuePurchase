//
//  MDMemberAvatarTableViewCell.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDMemberAvatarTableViewCell.h"

@implementation MDMemberAvatarTableViewCell
@synthesize avatarImageView;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self.textLabel setFont:[UIFont systemFontOfSize:14]];
        [self initCell];
    }
    return self;
}

-(void)initCell{
    float radius = 40;
    avatarImageView = [[UIImageView alloc] init];
    [avatarImageView.layer setMask:[self shadowToImageViewWRadius:radius point:CGPointMake(radius, radius)]];
    [self.contentView addSubview:avatarImageView];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(radius*2, radius*2));
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.centerY.equalTo(self.contentView);
    }];
}

/**
 *  通过UIImageView的圆角属性layer.mask,实现图片圆角
 *
 *  @param radius 圆半径
 *  @param point  圆心坐标
 *
 *  @return 圆角属性
 */
-(CAShapeLayer*)shadowToImageViewWRadius:(float)radius point:(CGPoint)point{
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer* shape = [CAShapeLayer layer];
    shape.path = path.CGPath;
    return shape;
}

@end
