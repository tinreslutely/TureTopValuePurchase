//
//  MDFacesShopViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/8.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDFacesShopViewController.h"
#import "MDFacesShopDataController.h"
#import "MDFacesShopTableViewCell.h"

#import "SDCycleScrollView.h"
#import "MDLocationManager.h"

#import "MDDropdownMenu.h"
#import "MDDropdownMenuModel.h"
@interface MDFacesShopViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MDDropdownMenuDelegate>

@end

@implementation MDFacesShopViewController{
    MDFacesShopDataController *_dataController;
    UITableView *_mainTableView;
    UIButton *_siteButton;
    UIView *_conditionView;
    
    NSString *_shopName;
    NSString *_city;
    NSString *_distract;
    NSString *_street;
    NSString *_orderBy;
    int _industry;
    int _parentIndustry;
    double _userLat;
    double _userLng;
    int _page;
    int _pageSize;
    int _totalCount;
    float _bannerHeight;
    NSMutableArray *_shopsArray;
    int _selectTag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark MDDropdownMenuDelegate

-(void)dropdownMenu:(MDDropdownMenu*)dropdownMenu didSelectleftRowAtIndex:(NSInteger)index  menuItem:(MDDropdownMenuModel*)menuItem
{
    if(_selectTag == 1002){
        if(index == 0){
            _parentIndustry = -1;
            _industry = -1;
            [self refreshData];
            UIButton *button = [_conditionView viewWithTag:_selectTag];
            [button setTitle:menuItem.title forState:UIControlStateNormal];
            return;
        }
        NSMutableArray *rightArray = [[NSMutableArray alloc] init];
        [_dataController requestCategoryDataWithParentTypeId:[menuItem.code intValue]  completion:^(BOOL state, NSString *msg, NSArray<MDFacesShopCategoryModel *> *list) {
            if(state){
                MDDropdownMenuModel *menuModel;
                for (MDFacesShopCategoryModel *categoryModel in list) {
                    menuModel = [[MDDropdownMenuModel alloc] init];
                    menuModel.code = [NSString stringWithFormat:@"%d",categoryModel.id];
                    menuModel.title = categoryModel.industryName;
                    menuModel.expand = [ imageURL stringByAppendingString: categoryModel.typeCover];
                    menuModel.isNetworking = YES;
                    [rightArray addObject:menuModel];
                }
                [dropdownMenu reloadAtRightDataWithArray:rightArray];
            }

        }];
    }else if(_selectTag == 1004){
        _distract = menuItem.code;
        if(index == 0){
            _distract = @"";
            _street = @"";
            [self refreshData];
            UIButton *button = [_conditionView viewWithTag:_selectTag];
            [button setTitle:@"全城" forState:UIControlStateNormal];
            return;
        }
        NSMutableArray *rightArray = [[NSMutableArray alloc] init];
        [_dataController requestStreetDataWithCode:_distract completion:^(BOOL state, NSString *msg, NSArray<MDFacesShopStreetModel *> *list) {
            if(state){
                MDDropdownMenuModel *menuModel;
                for (MDFacesShopStreetModel *streetModel in list) {
                    menuModel = [[MDDropdownMenuModel alloc] init];
                    menuModel.code = streetModel.areaCode;
                    menuModel.title = streetModel.areaName;
                    menuModel.expand = [NSString stringWithFormat:@"%d",streetModel.shopCount];
                    menuModel.isNetworking = NO;
                    [rightArray addObject:menuModel];
                }
                [dropdownMenu reloadAtRightDataWithArray:rightArray];
            }
        }];
    }
}

-(void)dropdownMenu:(MDDropdownMenu*)dropdownMenu didSelectrightRowAtIndex:(NSInteger)index  menuItem:(MDDropdownMenuModel*)menuItem parentMenuItem:(MDDropdownMenuModel*)parentMenuItem{
    
    UIButton *button = [_conditionView viewWithTag:_selectTag];
    [button setTitle:menuItem.title forState:UIControlStateNormal];
    if(_selectTag == 1002){
        _parentIndustry = [parentMenuItem.code intValue];
        _industry = [menuItem.code intValue];
        [self refreshData];
    }else if(_selectTag == 1004){
        _street = menuItem.code;
        [self refreshData];
    }
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? _bannerHeight : 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDFacesShopModel *model = _shopsArray[indexPath.row];
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeFaceDetail title:model.companyName parameters:@{@"id":[NSString stringWithFormat:@"%d",model.shopId]} isNeedLogin:NO loginTipBlock:nil];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : _shopsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(indexPath.section == 0){
        static NSString* bannerCellIdentifier = @"BannerCell";
        cell = [tableView dequeueReusableCellWithIdentifier:bannerCellIdentifier];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bannerCellIdentifier];
            UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bannerHeight)];
            [bannerView setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:bannerView];
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero shouldInfiniteLoop:YES  imageNamesGroup:@[@"banner1",@"banner2"]];
            cycleScrollView.infiniteLoop = YES;
            cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            //--- 轮播时间间隔，默认1.0秒，可自定义
            cycleScrollView.autoScrollTimeInterval = 4.0;
            [bannerView addSubview:cycleScrollView];
            [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bannerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }
    }else{
        static NSString* cellIdentifier = @"FacePayCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[MDFacesShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section != 0){
        MDFacesShopModel *model = _shopsArray[indexPath.row];
        MDFacesShopTableViewCell *shopCell = (MDFacesShopTableViewCell*)cell;
        [shopCell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_300x300",[imageURL stringByAppendingString:model.logo]]] placeholderImage:[UIImage imageNamed:@"loading"]];
        [shopCell.titleLabel setText:model.companyName];
        [shopCell.subLabel setText:[NSString stringWithFormat:@"全单送%d%%",model.returnRatio]];
        [shopCell.typeLabel setText:model.industryName];
        if(model.streetName != nil && ![model.streetName isEqualToString:@""] && ![model.position isEqualToString:@""]){
            [shopCell.positionLabel setText:[NSString stringWithFormat:@"%@/%@",model.streetName,model.position]];
        }else if(model.streetName != nil && ![model.streetName isEqualToString:@""]){
            [shopCell.positionLabel setText:[NSString stringWithFormat:@"%@",model.streetName]];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 : 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(_conditionView == nil) [self createViewForCustomConditionWithHeight:40];
    return section == 0 ? nil : _conditionView;
}


#pragma mark aciton methods

/**
 *  刷新数据
 */
-(void)refreshData{
    _page = 1;
    [self requestDataWithCompletion:^(BOOL state, NSString *msg, NSArray<MDFacesShopModel *> *list, int totalPage) {
        if(state){
            [_shopsArray removeAllObjects];
            [_shopsArray addObjectsFromArray:list];
            _totalCount = totalPage;
            if(_shopsArray.count > 0){
                [_mainTableView reloadData];
            }
        }
        [_mainTableView.mj_header endRefreshing];
    }];
}

/**
 *  加载数据
 */
-(void)loadData{
    if(_page + 1 > _totalCount) return;
    _page ++;
    [self requestDataWithCompletion:^(BOOL state, NSString *msg, NSArray<MDFacesShopModel *> *list, int totalPage) {
        if(state){
            [_shopsArray addObjectsFromArray:list];
            _totalCount = totalPage;
            if(_shopsArray.count > 0){
                [_mainTableView reloadData];
            }
        }
        [_mainTableView.mj_header endRefreshing];
    }];
}


#pragma mark event methods

/**
 *  定位
 */
-(void)locationTapped{
    [_siteButton setTitle:(APPDATA.locationCity == nil || [APPDATA.locationCity isEqualToString:@""] ? @"正在定位" : APPDATA.locationCity) forState:UIControlStateNormal];
    [[MDLocationManager sharedManager] startUpdatingLocationWithSuccessBlock:^{
        CLLocation *location = [[MDLocationManager sharedManager] getLocation];
        if(location != nil){
            _userLat = location.coordinate.latitude;
            _userLng = location.coordinate.longitude;
        }
        CLPlacemark *placemark = [[MDLocationManager sharedManager] getPlacemark];
        
        if(placemark != nil){
            _city = [placemark locality];
        }else{
            _city = APPDATA.locationCity;
        }
        [_siteButton setTitle:(_city != nil ? _city : @"定位失败") forState:UIControlStateNormal];
    } failureBlock:^{
        [_siteButton setTitle:@"定位失败" forState:UIControlStateNormal];
    }];
}

/**
 *  城市选择
 */
-(void)citySelectTapped{
    
}

/**
 *  店铺分类 按钮点击触发事件
 *
 *  @param button 店铺分类 按钮
 */
-(void)classifyButtonTap:(UIButton*)button{
    MDDropdownMenuModel *menuModel = [[MDDropdownMenuModel alloc] init];
    menuModel.code = 0;
    menuModel.title = @"全部分类";
    menuModel.expand = @"NaviMenu";
    menuModel.isNetworking = NO;
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:menuModel, nil];
    
    MDDropdownMenu *dropdownMenu = [[MDDropdownMenu alloc] initWIthLeftArray:array rightArray:@[] style:DropdownMenuStyleImageNoNum selectCode:[NSString stringWithFormat:@"%d",_parentIndustry]];
    dropdownMenu.delegate = self;
    [dropdownMenu show];
    [self alertButtonTappedForResultWithButton:button];
    [_dataController requestCategoryDataWithParentTypeId:0 completion:^(BOOL state, NSString *msg, NSArray<MDFacesShopCategoryModel *> *list) {
        if(state){
            [array removeAllObjects];
            MDDropdownMenuModel *menuModel;
            for (MDFacesShopCategoryModel *categoryModel in list) {
                menuModel = [[MDDropdownMenuModel alloc] init];
                menuModel.code = [NSString stringWithFormat:@"%d",categoryModel.id];
                menuModel.title = categoryModel.industryName;
                menuModel.expand = [ imageURL stringByAppendingString: categoryModel.typeCover];
                menuModel.isNetworking = YES;
                [array addObject:menuModel];
            }
            [dropdownMenu reloadAtLeftDataWithArray:array];
        }
    }];
    if(_industry != -1){
        [_dataController requestCategoryDataWithParentTypeId:_parentIndustry completion:^(BOOL state, NSString *msg, NSArray<MDFacesShopCategoryModel *> *list) {
            if(state){
                [array removeAllObjects];
                MDDropdownMenuModel *menuModel;
                for (MDFacesShopCategoryModel *categoryModel in list) {
                    menuModel = [[MDDropdownMenuModel alloc] init];
                    menuModel.code = [NSString stringWithFormat:@"%d",categoryModel.id];
                    menuModel.title = categoryModel.industryName;
                    menuModel.expand = [ imageURL stringByAppendingString: categoryModel.typeCover];
                    menuModel.isNetworking = YES;
                    [array addObject:menuModel];
                }
                [dropdownMenu reloadAtRightDataWithArray:array];
            }
        }];
    }
}

/**
 *  排序 按钮点击事件
 *
 *  @param button 排序 按钮
 */
-(void)sortButtonTap:(UIButton*)button{
    if(__IPHONE_SYSTEM_VERSION >= 8.0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"离我最近" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _orderBy = @"distance";
            [self refreshData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"全单送比例由高到低" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _orderBy = @"return_down";
            [self refreshData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"全单送比例由低到高" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _orderBy = @"return_up";
            [self refreshData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc ] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"离我最近",@"全单送比例由高到低",@"全单送比例由低到高", nil];//[[UIActionSheet alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"离我最近",@"全单送比例由高到低",@"全单送比例由低到高", nil];
        [actionSheet showInView:self.view];
    }
    
    [self alertButtonTappedForResultWithButton:button];
}

/**
 *  所有城市 按钮点击事件
 *
 *  @param button 所有城市 按钮
 */
-(void)allCityButtonTap:(UIButton*)button{
    if([_city isEqualToString:@""]) return;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    MDDropdownMenu *dropdownMenu = [[MDDropdownMenu alloc] initWIthLeftArray:array rightArray:@[] style:DropdownMenuStyleNumAndNum selectCode:_distract];
    dropdownMenu.delegate = self;
    [dropdownMenu show];
    [self alertButtonTappedForResultWithButton:button];
    [_dataController requestAreaDataWithCity:_city lng:-1 lat:-1 completion:^(BOOL state, NSString *msg, NSString *parentCode, NSString *city, NSArray<MDFacesShopAreaModel *> *list){
        if(state){
            [array removeAllObjects];
            MDDropdownMenuModel *menuModel;
            for (MDFacesShopAreaModel *areaModel in list) {
                menuModel = [[MDDropdownMenuModel alloc] init];
                menuModel.code = areaModel.areaCode;
                menuModel.title = areaModel.areaName;
                menuModel.expand = [ NSString stringWithFormat:@"%d",areaModel.shopCount];
                menuModel.isNetworking = NO;
                [array addObject:menuModel];
            }
            [dropdownMenu reloadAtLeftDataWithArray:array];
        }
    }];
    if(![_street isEqualToString:@""]){
        [_dataController requestStreetDataWithCode:_distract completion:^(BOOL state, NSString *msg, NSArray<MDFacesShopStreetModel *> *list) {
            if(state){
                [array removeAllObjects];
                MDDropdownMenuModel *menuModel;
                for (MDFacesShopStreetModel *streetModel in list) {
                    menuModel = [[MDDropdownMenuModel alloc] init];
                    menuModel.code = streetModel.areaCode;
                    menuModel.title = streetModel.areaName;
                    menuModel.expand = [NSString stringWithFormat:@"%d",streetModel.shopCount];
                    menuModel.isNetworking = NO;
                    [array addObject:menuModel];
                }
                [dropdownMenu reloadAtRightDataWithArray:array];
            }
        }];
    }
}

#pragma mark private methods

-(void)initData{
    _dataController = [[MDFacesShopDataController alloc] init];
    _shopsArray = [[NSMutableArray alloc] init];
    _bannerHeight = SCREEN_WIDTH*300/640;
    _shopName = @"";
    _city = @"广州市";
    _distract = @"";
    _street = @"";
    _orderBy = @"";
    _industry = -1;
    _parentIndustry = -1;
    _userLat = -1;
    _userLng = -1;
    _page = 1;
    _pageSize = 20;
    _selectTag = 1002;
}

/**
 *  初始化界面
 */
-(void)initView{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //导航栏
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    UIButton *locationButton = [[UIButton alloc] init];
    [locationButton setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationTapped) forControlEvents:UIControlEventTouchDown];
    [rightView addSubview:locationButton];
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightView.mas_top).with.offset(0);
        make.left.equalTo(rightView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
    _siteButton = [[UIButton alloc] init];
    [_siteButton setTitle:@"正在定位" forState:UIControlStateNormal];
    [_siteButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_siteButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_siteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_siteButton addTarget:self action:@selector(citySelectTapped) forControlEvents:UIControlEventTouchDown];
    [rightView addSubview:_siteButton];
    [_siteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightView.mas_top).with.offset(0);
        make.left.equalTo(locationButton.mas_right).with.offset(0);
        make.right.equalTo(rightView.mas_right).with.offset(0);
        make.height.mas_equalTo(30);
    }];
    [self setupSearchLoactionNavigationItem:self.navigationItem searchBarFrame:CGRectMake(0, 0, SCREEN_WIDTH - 110, 30) placeholder:@"搜索店铺" keyword:@"" rightView:rightView];
    
    //定位
    [self locationTapped];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_mainTableView setBackgroundColor:[UIColor whiteColor]];
    [_mainTableView setDataSource:self];
    [_mainTableView setDelegate:self];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    [_mainTableView setMj_footer:[MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)]];
    [_mainTableView setMj_header:[MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)]];
//    [self refreshView];
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
-(UIView*)createViewForCustomConditionWithHeight:(CGFloat)height{
    float width = SCREEN_WIDTH;
    _conditionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width+2, height+4)];
    [_conditionView setBackgroundColor:[UIColor whiteColor]];
    UILabel *bottomSpaceLabel = [[UILabel alloc] init];
    [bottomSpaceLabel setBackgroundColor:UIColorFromRGBA(186, 186, 186, 1)];
    [_conditionView addSubview: bottomSpaceLabel];
    [bottomSpaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(_conditionView.mas_left).with.offset(0);
        make.right.equalTo(_conditionView.mas_right).with.offset(0);
        make.bottom.equalTo(_conditionView.mas_bottom).with.offset(0);
    }];
    float itemWidth = (width/3)-1;
    //全部分类
    UIButton *classifyButton = [[UIButton alloc] init];
    [[classifyButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [classifyButton setTitle:@"全部分类" forState:UIControlStateNormal];
    [classifyButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [classifyButton addTarget:self action:@selector(classifyButtonTap:) forControlEvents:UIControlEventTouchDown];
    [classifyButton setTag:1002];
    [_conditionView addSubview:classifyButton];
    [classifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(itemWidth, height-2));
        make.top.equalTo(_conditionView.mas_top).with.offset(1);
        make.left.equalTo(_conditionView.mas_left).with.offset(0);
    }];
    
    UILabel *sepLabel = [[UILabel alloc] init];
    sepLabel.layer.borderWidth = 0.5;
    sepLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    [_conditionView addSubview:sepLabel];
    [sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 20));
        make.centerY.equalTo(_conditionView);
        make.left.equalTo(classifyButton.mas_right).with.offset(0);
    }];
    
    //排序
    UIButton *sortButton = [[UIButton alloc] init];
    [sortButton addTarget:self action:@selector(sortButtonTap:) forControlEvents:UIControlEventTouchDown];
    [[sortButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [sortButton setTitle:@"排序" forState:UIControlStateNormal];
    [sortButton setTag:1003];
    [sortButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_conditionView addSubview:sortButton];
    [sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(itemWidth, height-2));
        make.top.equalTo(_conditionView.mas_top).with.offset(1);
        make.left.equalTo(classifyButton.mas_right).with.offset(0);
    }];
    sepLabel = [[UILabel alloc] init];
    sepLabel.layer.borderWidth = 0.5;
    sepLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    [_conditionView addSubview:sepLabel];
    [sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 20));
        make.centerY.equalTo(_conditionView);
        make.left.equalTo(sortButton.mas_right).with.offset(0);
    }];
    
    //全城
    UIButton *allCityButton = [[UIButton alloc] init];
    [[allCityButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [allCityButton setTitle:@"全城" forState:UIControlStateNormal];
    [allCityButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [allCityButton setTag:1004];
    [allCityButton addTarget:self action:@selector(allCityButtonTap:) forControlEvents:UIControlEventTouchDown];
    [_conditionView addSubview:allCityButton];
    [allCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(itemWidth, height-2));
        make.top.equalTo(_conditionView.mas_top).with.offset(1);
        make.left.equalTo(sortButton.mas_right).with.offset(0);
    }];
    return _conditionView;
}



/**
 *  点击条件区域中的按钮切换选中的状态
 *
 *  @param button 点击的按钮对象
 */
-(void)alertButtonTappedForResultWithButton:(UIButton*)button{
    if(_selectTag == button.tag) return;
    UIButton *selectButton = [[button superview] viewWithTag:_selectTag];
    [selectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _selectTag = button.tag;
}

/**
 *  通过isShow参数决定是否显示一个button控件，遮挡tableview
 *
 *  @param parentView 主界面的对象
 *  @param isShow 是否显示button
 */
-(void)showNoDataTipsViewWithParentView:(UIView*)parentView isShow:(BOOL)isShow{
//    UIButton *button = [parentView viewWithTag:_tagForNoDataTipsButton];
//    //判断是否存在button
//    if(button == nil && isShow){
//        for (UIView *view in parentView.subviews) {
//            if([view isKindOfClass:[UITableView class]]) continue;
//            [view removeFromSuperview];
//        }
//        button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height)];
//        [button setTag:_tagForNoDataTipsButton];
//        [button setImage:[UIImage imageNamed:@"no_data"] forState:UIControlStateNormal];
//        [button setBackgroundColor:[UIColor whiteColor]];
//        [button setContentMode:UIViewContentModeScaleAspectFit];
//        [button addTarget:_weakself action:@selector(refreshView) forControlEvents:UIControlEventTouchDown];
//        [parentView addSubview:button];
//    }
//    if(!isShow) [button removeFromSuperview];
    NSLog(@"parentView的个数：%lu",(unsigned long)parentView.subviews.count);
    
}


-(void)requestDataWithCompletion:(void(^)(BOOL state, NSString *msg, NSArray<MDFacesShopModel *> *list, int totalPage))completion{
//    NSLog(@"请求面对面店铺列表数据shopName：%@，city：%@，street：%@，orderBy：%@，industry：%d，parentIndustry：%d，userLat：%f，userLng：%f，userId：%d，page：%d，pageSize：%d",_shopName,_city,_street,_orderBy,_industry,_parentIndustry,_userLat,_userLng,[APPDATA.userId intValue],_page,_pageSize);
    [_dataController requestDataWithShopName:_shopName city:_city street:_street orderBy:_orderBy industry:_industry parentIndustry:_parentIndustry userLat:_userLat userLng:_userLng userId:[APPDATA.userId intValue] page:_page pageSize:_pageSize completion:^(BOOL state, NSString *msg, NSArray<MDFacesShopModel *> *list, int totalPage) {
        if(completion) completion(state,msg,list,totalPage);
    }];
}


@end
