//
//  LDCombobox.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/29.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "LDCombobox.h"

@interface LDCombobox()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LDCombobox{
    NSMutableArray *_comboItems;//key  value
}

@synthesize comboboxView;

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _comboItems = [[NSMutableArray alloc] init];
        [self initView];
    }
    return self;
}

-(void)dropDown{
    [comboboxView setHidden:NO];
    
}

-(void)dropUp{
    
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _comboItems.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *comboCellIdentifier = @"ComboCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:comboCellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:comboCellIdentifier];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _comboItems[indexPath.row];
    [cell.textLabel setText:[dic objectForKey:@"key"]];
}

#pragma mark public methods
-(void)setComboItems:(NSArray*)items{
    [_comboItems removeAllObjects];
    [_comboItems addObjectsFromArray:items];
}

#pragma mark private methods
-(void)initView{
    
    UILabel *typeLabel = [[UILabel alloc] init];
    [typeLabel setText:@"商品"];
    [typeLabel setTextColor:UIColorFromRGB(161, 161, 161)];
    [typeLabel setTextAlignment:NSTextAlignmentCenter];
    [typeLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, self.frame.size.height));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(8);
    }];
    
    UILabel *spaceLabel = [[UILabel alloc] init];
    [spaceLabel setBackgroundColor:UIColorFromRGB(161, 161, 161)];
    [self addSubview:spaceLabel];
    [spaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        
    }];
    
    UIImageView *typeImageView = [[UIImageView alloc] init];
    [typeImageView setImage:[UIImage imageNamed:@"arrow_bottom_b"]];
    [self addSubview:typeImageView];
    [typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 5));
        make.right.equalTo(spaceLabel.mas_left).with.offset(-8);
        make.centerY.equalTo(self);
    }];

}

-(void)setupComboboxViewWithFrame:(CGRect)frame{
    comboboxView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [comboboxView setDataSource:self];
    [comboboxView setDelegate:self];
}

@end
