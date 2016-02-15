//
//  MDFacesShopSearchViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDFacesShopSearchViewController.h"
#import "MDSearchDataController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "MDSearchNormalTableViewCell.h"

@interface MDFacesShopSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation MDFacesShopSearchViewController{
    TPKeyboardAvoidingTableView *_mainTableView;
    MDSearchDataController *_dataController;
    NSMutableArray *_mainSearchArray;
    int _searchType;
}

@synthesize keyword,searchBlock;

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
    [self searchTap];
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
            [cell setSpaceLabelHidden:YES];
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
            [cell setSpaceLabelHidden:YES];
            UIButton *clearButton = [[UIButton alloc] init];
            [clearButton setTitle:@"清空搜索记录" forState:UIControlStateNormal];
            [clearButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [clearButton setTitleColor:UIColorFromRGBA(180, 180, 180, 1)  forState:UIControlStateNormal];
            [clearButton.layer setBorderColor:UIColorFromRGBA(120, 120, 120, 1).CGColor];
            [clearButton.layer setBorderWidth:0.5];
            [clearButton.layer setCornerRadius:2];
            [clearButton.layer setMasksToBounds:YES];
            [clearButton addTarget:self action:@selector(clearItemsTap:) forControlEvents:UIControlEventTouchUpInside];
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
    if(indexPath.row == 0 || indexPath.row == _mainSearchArray.count + 1) return;
    MDSearchModel *model = _mainSearchArray[indexPath.row - 1];
    [self.searchText setText:model.keyword];
    [self searchTap];
    //[self navigationToGoodsWithKeyword:model.keyword];
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
    [_dataController selectAllRecordWithType:_searchType completion:^(NSArray *array) {
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
    [_dataController deleteRecordWithKeyword:model.keyword type:_searchType completion:^(BOOL state){
        [self.progressView hide];
        [_mainSearchArray removeObject:model];
        [_mainTableView reloadData];
    }];
}

-(void)clearItemsTap:(UIButton*)button{
    [self.progressView show];
    [_dataController deleteAllRecordWithType:_searchType completion:^(BOOL state){
        [_mainSearchArray removeAllObjects];
        [_mainTableView reloadData];
        [self.progressView hide];
    }];
}

-(void)searchTap{
    keyword = self.searchText.text;
    __weak NSString *kw = keyword;
    [_dataController updateRecordWithKeyword:kw type:_searchType completion:^(BOOL state){
        if(state && searchBlock) searchBlock(kw);
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark private methods
-(void)initData{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    _dataController = [[MDSearchDataController alloc] init];
    _mainSearchArray = [[NSMutableArray alloc] init];
    _searchType = MDSearchTypeFacesShop;
}

-(void)initView{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(searchTap) forControlEvents:UIControlEventTouchUpInside];
    [self setupSearchNavigationItem:self.navigationItem searchBarFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 30) placeholder:@"搜索店铺" keyword:@"" rightView:rightButton];
    [self.searchText setDelegate:self];
    [self.searchText becomeFirstResponder];
    [self.searchText setText:keyword];
    
    _mainTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    _mainTableView.tableHeaderView = [[UIView alloc] init];
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
}

@end
