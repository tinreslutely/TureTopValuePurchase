//
//  MDMessageDetailViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/4.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDMessageDetailViewController.h"
#import "MDMessageDataController.h"

@interface MDMessageDetailViewController ()

@end

@implementation MDMessageDetailViewController{
    MDMessageDataController *_dataController;
    UILabel *_mainTimeLabel;
    UILabel *_mainLabel;
}

@synthesize messageId,messageType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark action and event methods

-(void)refreshData{
    [_dataController requestDetailDataWithMessageId:messageId messageType:messageType completion:^(BOOL state, NSString *msg, MDMessageModel *model) {
        if(state){
            _mainTimeLabel.text = model.createTime;
            [self boundingRectWithLabel:_mainLabel content:model.content];
        }
    }];
}

#pragma mark private methods
-(void)initData{
    _dataController = [[MDMessageDataController alloc] init];
}
-(void)initView{
    [self.navigationItem setTitle:@"消息详情"];
    
    _mainTimeLabel = [[UILabel alloc] init];
    [_mainTimeLabel setFont:[UIFont systemFontOfSize:14]];
    [_mainTimeLabel setTextAlignment:NSTextAlignmentRight];
    [_mainTimeLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:_mainTimeLabel];
    [_mainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.equalTo(self.view.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(-8);
    }];
    
    UILabel *spaceLabel = [[UILabel alloc] init];
    [spaceLabel setBackgroundColor:UIColorFromRGBA(250, 250, 250, 1)];
    [self.view addSubview:spaceLabel];
    [spaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.equalTo(_mainTimeLabel.mas_bottom).with.offset(1);
        make.left.equalTo(self.view.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(-8);
    }];
    
    
    _mainLabel = [[UILabel alloc] init];
    [_mainTimeLabel setTextColor:UIColorFromRGBA(73, 73, 73, 1)];
    [_mainLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:_mainLabel];
    [_mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spaceLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-16, 0));
        
    }];
    
    [self refreshData];
}

-(void)boundingRectWithLabel:(UILabel*)label content:(NSString*)content
{
    [label setNumberOfLines:0];
    [label setText:content];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    CGRect rect=[label.text boundingRectWithSize:label.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil] context:nil];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(rect.size.height);
    }];
}
@end
