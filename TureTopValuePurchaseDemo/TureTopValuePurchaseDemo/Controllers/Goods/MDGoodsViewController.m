//
//  MDGoodsViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/1.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDGoodsViewController.h"
#import "MDGoodsDataController.h"

#import "MDGoodsTableViewCell.h"

@interface MDGoodsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SWTableViewCellDelegate>

@end

@implementation MDGoodsViewController{
    MDGoodsDataController *_dataController;
    UIView *_navigationView;
    UITextField *_searchView;
    UITableView *_mainTableView;
    
    int _pageIndex;//当前页数 默认1
    int _pageSize;//每页数量 默认10
    int _pageTotal;//总页数
    int _categroyId;//商品类目编号 -1为不作为条件
    int _shopId;//店铺编号  -1为不作为条件
    int _sort;//排序  -1：不排序  0：销量，1：价格升序，2:上架时间， 3：价格降序
    NSMutableArray *_mainArray;
    float _transStartY;
    float _transEndY;
    int _currentTag;
}

@synthesize categoryId,keyword;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark SWTableViewCellDelegate

#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _transStartY = scrollView.contentOffset.y;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y > _transStartY && _navigationView.transform.ty == 0){
        [_navigationView setTransform:CGAffineTransformMakeTranslation(0, -108)];
        [_mainTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
        }];
    }else if(scrollView.contentOffset.y < _transStartY && _navigationView.transform.ty == -108){
        [_navigationView setTransform:CGAffineTransformMakeTranslation(0, 0)];
        [_mainTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(108);
        }];
    }
    
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mainArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"productCell";
    MDGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[MDGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    MDGoodsTableViewCell *goodsCell = (MDGoodsTableViewCell*)cell;
    MDProductModel *model = _mainArray[indexPath.row];
    [goodsCell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_300x300",model.prodMainPicUrl]] placeholderImage:[UIImage imageNamed:@"loading"]];
    [goodsCell.sellPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.salesPrice]];
    [goodsCell.titleLabel setText:model.productName];
    
    if(indexPath.row%_pageSize==0){
        [self.view makeToast:[NSString stringWithFormat:@"%d/%d",(int)(indexPath.row/_pageSize)+1,_pageTotal] duration:1 position:CSToastPositionBottom];
    }
}

#pragma mark action event methods
-(void)backTap{
    NSArray *array = self.navigationController.viewControllers;
    UIViewController *controller = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    if([controller isKindOfClass:NSClassFromString(@"MDSearchViewController")]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)refreshData{
    _pageIndex = 1;
    [self.progressView show];
    [_dataController requestDataWithPageNo:_pageIndex pageSize:_pageSize keywords:keyword categoryId:_categroyId shopId:_shopId productType:APPDATA.appFunctionType sort:_sort completion:^(BOOL state, NSString *msg, NSArray<MDGoodsModel *> *list, int totalPage) {
        if(state){
            _pageTotal = totalPage;
            [_mainArray removeAllObjects];
            [_mainArray addObjectsFromArray:list];
            [_mainTableView reloadData];
            [_mainTableView.mj_header endRefreshing];
        }
        [self.progressView hide];
    }];
}

-(void)loadData{
    if(_pageIndex > _pageTotal){
        [self.view makeToast:@"已经是最后一页了" duration:0.3 position:CSToastPositionBottom];
        [_mainTableView.mj_footer endRefreshing];
        return;
    }
    _pageIndex ++;
    [self.progressView show];
    [_dataController requestDataWithPageNo:_pageIndex pageSize:_pageSize keywords:keyword categoryId:_categroyId shopId:_shopId productType:APPDATA.appFunctionType sort:_sort completion:^(BOOL state, NSString *msg, NSArray<MDGoodsModel *> *list, int totalPage) {
        if(state){
            _pageTotal = totalPage;
            [_mainArray addObjectsFromArray:list];
            [_mainTableView reloadData];
            [_mainTableView.mj_footer endRefreshing];
        }
        [self.progressView hide];
    }];
}

/**
 *  排序按钮点击事件
 *
 *  @param button 排序按钮
 */
-(void)sortButtonTap:(UIButton*)button{
    if(button.tag == _currentTag && _currentTag != 1002) return;
    [((UIButton*)[button.superview viewWithTag:_currentTag]) setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _currentTag = (int)button.tag;
    switch(_currentTag){
        case 1001:
            _sort = 0;
            break;
        case 1002:
            _sort = _sort == 1 ? 3 : 1;
            break;
        case 1003:
            _sort = 2;
            break;
    }
    if(_currentTag == 1002){
        NSString *sortImage = @"sort_up";
        if(_sort == 3) {
            sortImage = @"sort_down";
        }
        [button setImage:[UIImage imageNamed:sortImage] forState:UIControlStateNormal];
    }else{
        [((UIButton*)[button.superview viewWithTag:1002]) setImage:nil forState:UIControlStateNormal];
    }
    [self refreshData];
}

#pragma mark private methods
-(void)initData{
    _dataController = [[MDGoodsDataController alloc] init];
    _mainArray = [[NSMutableArray alloc] init];
    _pageTotal = 0;
    _sort = -1;
    _shopId = -1;
    _pageSize = 10;
    _pageIndex = 1;
    _currentTag = 1000;
}

-(void)initView{
    _navigationView = [self setupCustomSearchNavigationWithPlaceholder:@"搜索商品" keyword:keyword];
    [_navigationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(108);
    }];
    _searchView = (UITextField*)[[_navigationView viewWithTag:1001] viewWithTag:1003];
    [self.rightButton setImage:[UIImage imageNamed:@"fun_sortway"] forState:UIControlStateNormal];
    [self.leftButton removeTarget:self action:@selector(backTap) forControlEvents:UIControlEventTouchDown];
    [self.leftButton addTarget:self action:@selector(backTap) forControlEvents:UIControlEventTouchDown];
    
    UIView *sortView = [self createViewForCustomConditionWithWidth:SCREEN_WIDTH];
    [_navigationView addSubview:sortView];
    [sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.left.equalTo(_navigationView.mas_left).with.offset(0);
        make.right.equalTo(_navigationView.mas_right).with.offset(0);
        make.bottom.equalTo(_navigationView.mas_bottom).with.offset(-6);
    }];
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_mainTableView setDelegate:self];
    [_mainTableView setDataSource:self];
    [_mainTableView setMj_header:[MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)]];
    [_mainTableView setMj_footer:[MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)]];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(108);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    [self refreshData];
}

/**
 *  添加一个自定义的排序条件的UIView
 *
 *  @param superView 父级UIView
 *  @param height    UIView的高度
 *
 *  @return UIView对象
 */
-(UIView*)createViewForCustomConditionWithWidth:(CGFloat)width{
    UIView *view = [[UIView alloc] init];
    
    float itemWidth = (width/3)-1;
    //销量
    UIButton *salesButton = [[UIButton alloc] init];
    [[salesButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [salesButton setTitle:@"销量" forState:UIControlStateNormal];
    [salesButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    salesButton.tag = 1001;
    [salesButton addTarget:self action:@selector(sortButtonTap:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:salesButton];
    [salesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(itemWidth);
        make.top.equalTo(view.mas_top).with.offset(1);
        make.bottom.equalTo(view.mas_bottom).with.offset(1);
        make.left.equalTo(view.mas_left).with.offset(0);
    }];
    
    UILabel *sepLabel = [[UILabel alloc] init];
    [sepLabel setBackgroundColor:UIColorFromRGBA(204, 204, 204, 1)];
    [view addSubview:sepLabel];
    [sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.equalTo(view.mas_top).with.offset(10);
        make.bottom.equalTo(view.mas_bottom).with.offset(-5);
        make.left.equalTo(salesButton.mas_right).with.offset(0);
    }];
    
    //价格
    UIButton *priceSortButton = [[UIButton alloc] init];
    [priceSortButton addTarget:self action:@selector(sortButtonTap:) forControlEvents:UIControlEventTouchDown];
    [priceSortButton setTag:1002];
    [[priceSortButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [priceSortButton setTitle:@"价格" forState:UIControlStateNormal];
    [priceSortButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [priceSortButton setImageEdgeInsets:UIEdgeInsetsMake(0, (itemWidth/2)+20, 0, 0)];
    [view addSubview:priceSortButton];
    [priceSortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(itemWidth);
        make.top.equalTo(view.mas_top).with.offset(1);
        make.bottom.equalTo(view.mas_bottom).with.offset(1);
        make.left.equalTo(salesButton.mas_right).with.offset(0);
    }];
    
    sepLabel = [[UILabel alloc] init];
    [sepLabel setBackgroundColor:UIColorFromRGBA(204, 204, 204, 1)];
    [view addSubview:sepLabel];
    [sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.equalTo(view.mas_top).with.offset(10);
        make.bottom.equalTo(view.mas_bottom).with.offset(-5);
        make.left.equalTo(priceSortButton.mas_right).with.offset(0);
    }];
    
    //最新
    UIButton *newSortButton = [[UIButton alloc] init];
    [[newSortButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [newSortButton setTitle:@"最新" forState:UIControlStateNormal];
    [newSortButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [newSortButton addTarget:self action:@selector(sortButtonTap:) forControlEvents:UIControlEventTouchDown];
    newSortButton.tag = 1003;
    [view addSubview:newSortButton];
    [newSortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(itemWidth);
        make.top.equalTo(view.mas_top).with.offset(1);
        make.bottom.equalTo(view.mas_bottom).with.offset(1);
        make.left.equalTo(priceSortButton.mas_right).with.offset(0);
    }];
    return view;
}




@end
