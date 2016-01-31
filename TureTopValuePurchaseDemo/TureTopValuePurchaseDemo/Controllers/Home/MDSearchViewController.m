//
//  MDSearchViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/16.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDSearchViewController.h"
#import "LDSearchBar.h"
#import "MDSearchNormalTableViewCell.h"
#import "MDSearchDataController.h"
#import "TPKeyboardAvoidingTableView.h"

@interface MDSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation MDSearchViewController{
    TPKeyboardAvoidingTableView *_mainTableView;
    MDSearchDataController *_dataController;
    NSMutableArray *_mainSearchArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_dataController updateRecordWithKeyword:self.searchText.text type:MDSearchTypeProduct completion:^(BOOL state){
        [self refreshData];
    }];
    return YES;
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mainSearchArray.count > 0 ? _mainSearchArray.count + 2 : 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *normalCellIdentifier = @"NormalCell";
    static NSString *tipCellIdentifier = @"TipCell";
    static NSString *buttonCellIdentifier = @"ClearCell";
    static NSString *titleCellIdentifier = @"TitleCell";
    MDSearchNormalTableViewCell *cell;
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
        if(!cell){
            cell = [[MDSearchNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellIdentifier];
            [cell.iconButton setImage:[UIImage imageNamed:@"SearchHistory"] forState:UIControlStateNormal];
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.textLabel setText:@"历史记录"];
        }
    }else if(indexPath.row == 1 && _mainSearchArray.count == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
        if(!cell){
            cell = [[MDSearchNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tipCellIdentifier];
            UILabel *tipLabel = [[UILabel alloc] init];
            [tipLabel setText:@"暂无历史记录"];
            [tipLabel setFont:[UIFont systemFontOfSize:16]];
            [tipLabel setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:tipLabel];
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(120, 30));
                make.centerX.equalTo(cell.contentView.mas_centerX);
                make.centerY.equalTo(cell.contentView.mas_centerY);
            }];
        }
    }else if(indexPath.row <= _mainSearchArray.count){
        cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
        if(!cell){
            cell = [[MDSearchNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdentifier];
            [cell.iconButton setImage:[UIImage imageNamed:@"search_history_delete_icon_normal"] forState:UIControlStateNormal];
            [cell.iconButton setImage:[UIImage imageNamed:@"search_history_delete_icon_selected"] forState:UIControlStateSelected];
            [cell.iconButton addTarget:self action:@selector(clearItemTap:) forControlEvents:UIControlEventTouchDown];
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.textLabel setTextColor:[UIColor grayColor]];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:buttonCellIdentifier];
        if(!cell){
            cell = [[MDSearchNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:buttonCellIdentifier];
            UIButton *clearButton = [[UIButton alloc] init];
            [clearButton setTitle:@"清空搜索记录" forState:UIControlStateNormal];
            [clearButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [clearButton setTitleColor:UIColorFromRGBA(180, 180, 180, 1)  forState:UIControlStateNormal];
            [clearButton.layer setBorderColor:UIColorFromRGBA(120, 120, 120, 1).CGColor];
            [clearButton.layer setBorderWidth:0.5];
            [clearButton.layer setCornerRadius:2];
            [clearButton.layer setMasksToBounds:YES];
            [clearButton addTarget:self action:@selector(clearItemsTap:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:clearButton];
            [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(120, 30));
                make.center.equalTo(cell.contentView);
            }];
        }
    }
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = 40;
    if(indexPath.row == 0){
        height = 30;
    }else if(indexPath.row == 1 && _mainSearchArray.count == 0){
        height = 80;
    }else if(indexPath.row >= _mainSearchArray.count + 1){
        height = 50;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if( _mainSearchArray.count > 0 && indexPath.row > 0  && indexPath.row <= _mainSearchArray.count){
        MDSearchModel *model = _mainSearchArray[indexPath.row - 1];
        [cell.textLabel setText:model.keyword];
    }
}

#pragma mark action and event methods
-(void)refreshData{
    [self.progressView show];
    [_dataController selectAllRecordWithType:MDSearchTypeProduct completion:^(NSArray *array) {
        [_mainSearchArray removeAllObjects];
        [_mainSearchArray addObjectsFromArray: array];
        [self.progressView hide];
        [_mainTableView reloadData];
    }];
}

-(void)clearItemTap:(UIButton*)button{
    [self.progressView show];
    UITableViewCell *cell = (UITableViewCell*)(__IPHONE_SYSTEM_VERSION >= 8.0 ? [[button superview] superview] : [[[button superview] superview] superview]);
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    MDSearchModel *model = _mainSearchArray[indexPath.row - 1];
    [_dataController deleteRecordWithKeyword:model.keyword type:MDSearchTypeProduct completion:^(BOOL state){
        [self.progressView hide];
        [_mainSearchArray removeObject:model];
        [_mainTableView reloadData];
    }];
}

-(void)clearItemsTap:(UIButton*)button{
    [self.progressView show];
    [_dataController deleteAllRecordWithType:MDSearchTypeProduct completion:^(BOOL state){
        [_mainSearchArray removeAllObjects];
        [_mainTableView reloadData];
        [self.progressView hide];
        
    }];
}

#pragma mark private methods
-(void)initData{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    _dataController = [[MDSearchDataController alloc] init];
    _mainSearchArray = [[NSMutableArray alloc] init];
}

-(void)initView{
    [self.searchText setDelegate:self];
    
    _mainTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
}



@end
