//
//  LDProgressView.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/21.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDProgressView.h"
#import "MMMaterialDesignSpinner.h"

@implementation LDProgressView{
    MMMaterialDesignSpinner *_spinnerView;
    int _viewSize;
}

-(instancetype)initWithView:(UIView*)view{
    int pointX = (SCREEN_WIDTH - 30)/2;
    int pointY = (SCREEN_HEIGHT - 30)/2;
    _viewSize = 30;
    if(self = [super initWithFrame:CGRectMake(pointX, pointY, _viewSize, _viewSize)]){
        [self setupView];
        [self setHidden:YES];
    }
    return self;
}

-(void)setupView{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 15, 15)];
    [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchDown];
    [button setImage:[UIImage imageNamed:@"logo_pg"] forState:UIControlStateNormal];
    [self addSubview: button];
    _spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    _spinnerView.tintColor = [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1];
    _spinnerView.center = CGPointMake(_viewSize/2, _viewSize/2);
    _spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_spinnerView];
    
}

-(void)show{
    [self setHidden:NO];
    [_spinnerView startAnimating];
}

-(void)hide{
    [self setHidden: YES];
    [_spinnerView stopAnimating];
}
@end
