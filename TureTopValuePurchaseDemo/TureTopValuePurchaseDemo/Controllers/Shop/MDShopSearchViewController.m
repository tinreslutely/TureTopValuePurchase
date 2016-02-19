//
//  MDShopSearchViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/17.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDShopSearchViewController.h"
#import "MDShopSearchDataController.h"

#import "MDShopSearchCollectionViewCell.h"
#import "MDShopSearchManyCollectionViewCell.h"

#import "MJRefresh.h"
#import "UIView+Toast.h"

@interface MDShopSearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@end

@implementation MDShopSearchViewController{
    MDShopSearchDataController *_dataController;
    UICollectionView *_mainCollectionView;
    UIButton *_mainNoDataButton;
    UITextField *_searchView;
    int _shopId;
    int _pageNo;
    int _pageSize;
    int _totalCount;
    BOOL _firstRow;
    NSMutableArray *_mainArray;
    
}

@synthesize keyword;

#pragma mark life cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.navigationController.navigationBarHidden){
        [self.navigationController setNavigationBarHidden:YES];
    }
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    keyword = [textField text];
    [_dataController updateRecordWithKeyword:keyword type:MDSearchTypeShop completion:^(BOOL state) {
        [self refreshData];
    }];
    return YES;
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchView resignFirstResponder];
}

#pragma mark UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return _firstRow ? CGSizeMake(SCREEN_WIDTH, 80) : CGSizeMake(SCREEN_WIDTH/2-10, SCREEN_WIDTH/2 + 73);
}

#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [self setContentWithCell:cell indexPath:indexPath];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MDShopSearchModel *model = _mainArray[(_firstRow ? indexPath.section : (int)(2*indexPath.section+indexPath.row))];
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeShopList title:@"进入店铺" parameters:@{@"shopId":[NSString stringWithFormat:@"%d", model.shopId]} isNeedLogin:NO loginTipBlock:nil];
}

#pragma mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _firstRow ? 1 : 2;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _firstRow ? _mainArray.count : (_mainArray.count == 1 ? 1 : _mainArray.count / 2);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if(_firstRow){
        static NSString *cellIdentifier = @"CollectionCell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
    }else{
        static NSString *manyCellIdentifier = @"ManyCollectionCell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:manyCellIdentifier forIndexPath:indexPath];
    }
    if(__IPHONE_SYSTEM_VERSION < 8){
        [self setContentWithCell:cell indexPath:indexPath];
    }
    return cell;
}



#pragma mark action and event methods
/**
 *  刷新数据
 */
-(void)refreshData{
    _pageNo = 1;
    [_dataController requestDataWithKeyword:keyword shopId:_shopId pageNo:_pageNo pageSize:_pageSize completion:^(BOOL state, NSString * _Nullable msg, NSArray<MDShopSearchModel *> * _Nullable list, int totalCount) {
        if(state && list.count > 0){
            _totalCount = totalCount;
            [self.view sendSubviewToBack:_mainNoDataButton];
            if(_mainCollectionView.isHidden) [_mainCollectionView setHidden:NO];
            [_mainArray removeAllObjects];
            [_mainArray addObjectsFromArray:list];
            [_mainCollectionView reloadData];
        }else{
            [self.view sendSubviewToBack:_mainCollectionView];
            if(_mainNoDataButton.isHidden) [_mainNoDataButton setHidden:NO];
        }
        [_mainCollectionView.mj_header endRefreshing];

    }];
}

/**
 *  加载下一页数据
 */
-(void)loadData{
    if(_pageNo + 1 <= _totalCount){
        _pageNo ++;
        [_dataController requestDataWithKeyword:keyword shopId:_shopId pageNo:_pageNo pageSize:_pageSize completion:^(BOOL state, NSString * _Nullable msg, NSArray<MDShopSearchModel *> * _Nullable list, int totalCount){
            if(state){
                [self.view makeToast:[NSString stringWithFormat:@"%d/%d",_pageNo,_totalCount] duration:3.0 position:CSToastPositionBottom];
                if(list.count > 0){
                    _totalCount = totalCount;
                    [_mainArray addObjectsFromArray:list];
                    [_mainCollectionView reloadData];
                }
            }else{
                [self.view makeToast:@"加载失败" duration:3.0 position:CSToastPositionBottom];
                
            }
            [_mainCollectionView.mj_footer endRefreshing];
        }];
    }else{
        [self.view makeToast:@"最后一页" duration:3.0 position:CSToastPositionBottom];
    }
}


-(void)backTap{
    if([self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] isKindOfClass:NSClassFromString(@"MDSearchViewController")]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)showWayTap{
    _firstRow = !_firstRow;
    [_mainCollectionView reloadData];
}


#pragma mark private methods

-(void)initData{
    _dataController = [[MDShopSearchDataController alloc] init];
    _mainArray = [[NSMutableArray alloc] init];
    _shopId = -1;
    _pageNo = 1;
    _pageSize = 10;
    _totalCount = 0;
    _firstRow = YES;
}

/**
 *  初始化布局
 */
-(void)initView{
    //设置导航栏
    UIView *_navigationView = [self setupCustomSearchNavigationWithPlaceholder:@"搜索商品" keyword:keyword];
    [_navigationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(64);
    }];
    _searchView = (UITextField*)[[_navigationView viewWithTag:1001] viewWithTag:1003];
    [_searchView setDelegate:self];
    [self.rightButton setImage:[UIImage imageNamed:@"fun_sortway"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(showWayTap) forControlEvents:UIControlEventTouchDown];
    [self.leftButton removeTarget:self action:@selector(backTap) forControlEvents:UIControlEventTouchDown];
    [self.leftButton addTarget:self action:@selector(backTap) forControlEvents:UIControlEventTouchDown];
    
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_mainCollectionView setShowsVerticalScrollIndicator:NO];
    [_mainCollectionView setBackgroundColor:UIColorFromRGBA(250, 250, 250, 1)];
    [_mainCollectionView setDelegate:self];
    [_mainCollectionView setDataSource:self];
    [_mainCollectionView setMj_header:[MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)]];
    [_mainCollectionView setMj_footer:[MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)]];
    [_mainCollectionView registerClass:[MDShopSearchCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    [_mainCollectionView registerClass:[MDShopSearchManyCollectionViewCell class] forCellWithReuseIdentifier:@"ManyCollectionCell"];
    [self.view addSubview:_mainCollectionView];
    [_mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    _mainNoDataButton = [[UIButton alloc] init];
    [_mainNoDataButton setBackgroundColor:[UIColor whiteColor]];
    [_mainNoDataButton setTitle:@"暂无店铺数据" forState:UIControlStateNormal];
    [_mainNoDataButton setTitleColor:UIColorFromRGBA(220, 220, 220, 1) forState:UIControlStateNormal];
    //[_mainNoDataButton setImage:[UIImage imageNamed:@"none_record"] forState:UIControlStateNormal];
    [_mainNoDataButton setContentMode:UIViewContentModeScaleAspectFit];
    [_mainNoDataButton setHidden:YES];
    [self.view addSubview:_mainNoDataButton];
    [_mainNoDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    //初始化请求数据
    [self refreshData];
}

/*!
 *  为指定的UICollectionViewCell对象内容赋值
 *
 *  @param cell      UICollectionViewCell对象
 *  @param indexPath 位置
 */
-(void)setContentWithCell:(UICollectionViewCell*)cell indexPath:(NSIndexPath*)indexPath{
    if(_firstRow){
        MDShopSearchCollectionViewCell *shopCell = (MDShopSearchCollectionViewCell*)cell;
        MDShopSearchModel *model = _mainArray[indexPath.section];
        [shopCell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_300x300",model.shopLogo]] placeholderImage:[UIImage imageNamed:@"loading"]];
        [shopCell.areaLabel setText:model.cityName];
        [shopCell.titleLabel setText:model.shopName];
        
    }else{
        MDShopSearchManyCollectionViewCell *shopCell = (MDShopSearchManyCollectionViewCell*)cell;
        int index = (int)(2*indexPath.section+indexPath.row);
        if(_mainArray.count - 1 < index) return;
        MDShopSearchModel *model = _mainArray[index];
        [shopCell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_300x300",model.shopLogo]] placeholderImage:[UIImage imageNamed:@"loading"]];
        [shopCell.areaLabel setText:model.cityName];
        [shopCell.titleLabel setText:model.shopName];
    }
}

@end
