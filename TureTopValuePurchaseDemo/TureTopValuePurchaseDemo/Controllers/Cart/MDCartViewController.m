//
//  MDCartViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDCartViewController.h"
#import "MDLoginViewController.h"
#import "MDCartDataController.h"

#import "CheckBoxButton.h"
#import "NumberBoxView.h"
#import "SWTableViewCell.h"
#import "MDCartTableViewCell.h"

#import "TPKeyboardAvoidingTableView.h"

@interface MDCartViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,NumberBoxViewDelegate>

@end

@implementation MDCartViewController{
    MDCartDataController *_dataController;
    TPKeyboardAvoidingTableView *_mainTableView;
    UIView *_cartFuncitonView;
    UIView *_editFuncitonView;
    UIView *_noneStateView;
    
    NSMutableArray *_mainCartArray;
    int _noneStateForTag;
    int _hasDataForTag;
    
    int _totalCart;
    BOOL _isStart;
    BOOL _isEidtState;
    NSMutableArray *_mainCheckedArray;
}

#pragma mark life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self initData];
    [self setupMainView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!APPDATA.isLogin){
        [self noneLoginStateView];
    }else{
        if(!_isStart &&_totalCart == 0) [self noneDataStateView];
        [self refreshData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark NumberBoxViewDelegate
-(void)numberBoxView:(NumberBoxView *)numberBoxView shouldValueChangedInNumber:(int)number{
    MDCartTableViewCell *cell;
    if(__IPHONE_SYSTEM_VERSION >= 8.0){
        cell = (MDCartTableViewCell*)[[[[numberBoxView superview] superview] superview] superview];
    }else{
        cell = (MDCartTableViewCell*)[[[[[numberBoxView superview] superview] superview] superview] superview];
    }
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    MDCartShopModel *shopModel = _mainCartArray[indexPath.section];
    MDCartModel *cartModel = shopModel.products[indexPath.row-1];
    
    [self.progressView show];
    [_dataController alertCartNumberWithCartId:[NSString stringWithFormat:@"%d",cartModel.cartId] quantity:[NSString stringWithFormat:@"%d",number] completion:^(BOOL state, NSString *msg) {
        [self.progressView hide];
        if(state){
            cartModel.qty = number;
            [_mainTableView reloadData];
            [self alertGlobalCartNumber];
            [self alertGlobalTotalCartPrice];
        }
    }];
}

#pragma mark SWTableViewCellDelegate

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    MDCartModel *cartModel = ((MDCartShopModel*)_mainCartArray[indexPath.section]).products[indexPath.row-1];
    if(index == 0){
        [self deleteCartTappedWithCartModel:cartModel];
    }
    
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once  自动隐藏
    return YES;
}


#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 40;
    MDCartShopModel *model = _mainCartArray[indexPath.section];
    if(indexPath.row != 0 && indexPath.row <= model.products.count){
        height = 140;
    }
    
    return height;
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MDCartShopModel *model = _mainCartArray[section];
    return model.products.count + (_isEidtState ?  1 : 2);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _mainCartArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *shopInformationCellIdentifier = @"ShopCell";
    static NSString *shoptotalPriceCellIdentifier = @"ShopTotalPriceCell";
    static NSString *shopCartItemCellIdentifier = @"ShopCartItem";
    MDCartShopModel *model = _mainCartArray[indexPath.section];
    UITableViewCell *cell;
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:shopInformationCellIdentifier];
        if(cell == nil){
            cell = [self bringCartCellForShopInformationWithIdentifier:shopInformationCellIdentifier];
            CheckBoxButton *button = (CheckBoxButton*)[cell viewWithTag:1001];
            [button addTarget:self action:@selector(shopChecked:) forControlEvents:UIControlEventTouchDown];
        }
    }else if(indexPath.row <= model.products.count){
        cell = [tableView dequeueReusableCellWithIdentifier:shopCartItemCellIdentifier];
        if(cell == nil){
            cell = [[MDCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shopCartItemCellIdentifier delegate:self];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [(MDCartTableViewCell*)cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:78.0f];
            [(MDCartTableViewCell*)cell setDelegate:self];
            [((MDCartTableViewCell*)cell).checkButton addTarget:self action:@selector(cartChecked:) forControlEvents:UIControlEventTouchDown];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:shoptotalPriceCellIdentifier];
        if(cell == nil){
            cell = [self bringCartCellForShopTotalPriceWithIdentifier:shoptotalPriceCellIdentifier];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    MDCartShopModel *model = _mainCartArray[indexPath.section];
    
    if(indexPath.row == 0){
        CheckBoxButton *button = (CheckBoxButton*)[cell viewWithTag:1001];
        BOOL hasUnChecked = NO;
        for (MDCartModel *cartModel in model.products) {
            if(![_mainCheckedArray containsObject:[NSString stringWithFormat:@"%d",cartModel.cartId]]){
                hasUnChecked = YES;
                break;
            }
        }
        button.checked = !hasUnChecked;
        UILabel *label = [cell viewWithTag:1002];
        [label setText:model.shopName];
        
    }else if(indexPath.row <= model.products.count){
        MDCartModel *cartModel = model.products[indexPath.row - 1];
        MDCartTableViewCell *cartCell = (MDCartTableViewCell *)cell;
        
        if(cartModel.mainPic != nil && ![cartModel.mainPic isEqualToString:@""]){
            [cartCell.imageView sd_setImageWithURL:[NSURL URLWithString:cartModel.mainPic] placeholderImage:[UIImage imageNamed:@"loading"]];
        }
        [cartCell.titleLabel setText:cartModel.productName];
        [cartCell.propertyLabel setText:cartModel.skuAttr];
        [cartCell.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",cartModel.salesPrice]];
        [cartCell.numberBoxView setNumber:cartModel.qty];
        [cartCell.checkButton setChecked:[_mainCheckedArray containsObject:[NSString stringWithFormat:@"%d",cartModel.cartId]]];
    }else{
        float totalCartPrice = 0;
        for(MDCartModel *cartModel in model.products){
            if([_mainCheckedArray containsObject:[NSString stringWithFormat:@"%d",cartModel.cartId]]){
                totalCartPrice += cartModel.salesPrice * cartModel.qty;
            }
        }
        UILabel *priceLabel = [cell viewWithTag:1002];
        [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",totalCartPrice]];
        
    }
}


#pragma mark action event methods

-(void)backTap{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  刷新数据
 */
-(void)refreshData{
    if(APPDATA.isLogin == NO) return;
    [self.progressView show];
    [_dataController requestDataWithUserId:APPDATA.userId completion:^(BOOL state, NSString *msg, NSArray<MDCartShopModel *> *list) {
        [self.progressView hide];
        if(state){
            _totalCart = 0;
            [_mainCartArray removeAllObjects];
            for (MDCartShopModel *shopModel in list) {
                if(shopModel.products.count > 0){
                    [_mainCartArray addObject:shopModel];
                }
                _totalCart += shopModel.products.count;
            }
            if(_isStart){
                for (MDCartShopModel *shopModel in list) {
                    for (MDCartModel *cartModel in shopModel.products) {
                        [_mainCheckedArray addObject:[NSString stringWithFormat:@"%d", cartModel.cartId]];
                    }
                }
                _isStart = NO;
            }
            if(_totalCart > 0){
                [self.view sendSubviewToBack: _noneStateView];
                [_mainTableView reloadData];
                [self alertGlobalCheckBoxButton];
                [self alertGlobalTotalCartPrice];
                [self alertGlobalCartNumber];
            }else{
                [self noneDataStateView];
            }
        }else{
            [self noneDataStateView];
        }
        [_mainTableView.mj_header endRefreshing];
    }];
}

/**
 *  购物车进入编辑状态或结束编辑状态
 */
-(void)editTap{
    if(!_isEidtState && _totalCart == 0) return;
    NSString *rightButtonName = @"编辑";
    if(_isEidtState){
        _isEidtState = NO;
        [_mainTableView reloadData];
        ((CheckBoxButton*)[_cartFuncitonView viewWithTag:1001]).checked = ((CheckBoxButton*)[_editFuncitonView viewWithTag:1001]).checked;
        [self alertGlobalCartNumber];
        [self alertGlobalTotalCartPrice];
        [self.view bringSubviewToFront:_cartFuncitonView];
    }else{
        _isEidtState = YES;
        [_mainTableView reloadData];
        if(_editFuncitonView == nil){
            [self bringEditFunctionViewWithSuperView:self.view hasTabBar:(!self.tabBarController.tabBar.hidden)];
        }
        ((CheckBoxButton*)[_editFuncitonView viewWithTag:1001]).checked = ((CheckBoxButton*)[_cartFuncitonView viewWithTag:1001]).checked;
        [self.view bringSubviewToFront:_editFuncitonView];
        rightButtonName = @"完成";
    }
    for(UIBarButtonItem *item in self.navigationItem.rightBarButtonItems){
        UIButton *button = item.customView;
        if(button != nil){
            [button setTitle:rightButtonName forState:UIControlStateNormal];
        }
    }
}

/**
 *  购物车选中事件
 *
 *  @param button 购物车选中按钮
 */
-(void)cartChecked:(CheckBoxButton*)button{
    MDCartTableViewCell *cell = __IPHONE_SYSTEM_VERSION >= 8.0 ? (MDCartTableViewCell*)[[[[button superview] superview] superview] superview] : (MDCartTableViewCell*)[[[[[button superview] superview] superview] superview] superview];
    if(![cell isKindOfClass:[MDCartTableViewCell class]]) return;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    MDCartShopModel *shopModel =  _mainCartArray[indexPath.section];
    MDCartModel *cartModel = shopModel.products[indexPath.row - 1];
    NSString *cartId = [NSString stringWithFormat:@"%d",cartModel.cartId];
    if([_mainCheckedArray containsObject:cartId]){
        [_mainCheckedArray removeObject:cartId];
    }else{
        [_mainCheckedArray addObject:cartId];
    }
    [_mainTableView reloadData];
    [self alertGlobalCheckBoxButton];
    [self alertGlobalCartNumber];
    [self alertGlobalTotalCartPrice];
}

/**
 *  选中店铺事件
 *
 *  @param button 店铺按钮
 */
-(void)shopChecked:(CheckBoxButton*)button{
    MDCartTableViewCell *cell = (MDCartTableViewCell*)[button superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    MDCartShopModel *shopModel =  _mainCartArray[indexPath.section];
    if(button.checked){//当前选中
        for (MDCartModel *cartModel in shopModel.products) {
            [_mainCheckedArray removeObject:[NSString stringWithFormat:@"%d", cartModel.cartId]];
        }
        
    }else{//当前未选中
        for (MDCartModel *cartModel in shopModel.products) {
            [_mainCheckedArray removeObject:[NSString stringWithFormat:@"%d", cartModel.cartId]];
        }
        for (MDCartModel *cartModel in shopModel.products) {
            [_mainCheckedArray addObject:[NSString stringWithFormat:@"%d", cartModel.cartId]];
        }
    }
    [_mainTableView reloadData];
    [self alertGlobalCheckBoxButton];
    [self alertGlobalCartNumber];
    [self alertGlobalTotalCartPrice];
}

/**
 *  所有购物车选中取消事件
 *
 *  @param button 全局全选按钮
 */
-(void)allCartChecked:(CheckBoxButton*)button{
    button.checked = !button.checked;
    [_mainCheckedArray removeAllObjects];
    if(button.checked){
        for (MDCartShopModel *shopModel in _mainCartArray) {
            for (MDCartModel *cartModel in shopModel.products) {
                [_mainCheckedArray addObject:[NSString stringWithFormat:@"%d", cartModel.cartId]];
            }
        }
    }
    [_mainTableView reloadData];
    [self alertGlobalCartNumber];
    [self alertGlobalTotalCartPrice];
}

/**
 *  点击 结算按钮 触发事件
 *
 *  @param button 结算按钮
 */
-(void)submitCartTapped:(UIButton*)button{
    NSString *json = [self orderParameterForJson];
    if(json == nil) return;
    json = [json stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    json = [json stringByReplacingOccurrencesOfString:@" " withString:@""];
    json = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)json,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeSubmitOrder title:@"填写订单" parameters:@{@"prodJson":json}  isNeedLogin:YES loginTipBlock:nil];
}

/**
 *  删除购物车商品事件
 */
-(void)deleteCartsTapped{
    if(_mainCheckedArray == 0) return;
    NSString *carts = @"";
    for (NSString *cartId in _mainCheckedArray) {
        carts = [carts isEqualToString:@""] ? [NSString stringWithFormat:@"%@",cartId] : [NSString stringWithFormat:@"%@,%@",carts,cartId];
    }
    [self.progressView show];
    [_dataController removeCartWithCartId:carts completion:^(BOOL state, NSString *msg) {
        if(state){
            NSMutableArray *cartArray;
            NSMutableArray *removeShopArray = [[NSMutableArray alloc] init];
            for (MDCartShopModel *shopModel in _mainCartArray) {
                cartArray = [[NSMutableArray alloc] init];
                for (MDCartModel *cartModel in shopModel.products) {
                    if(![_mainCheckedArray containsObject:[NSString stringWithFormat:@"%d",cartModel.cartId]]){
                        [cartArray addObject:cartModel];
                    }else{
                        _totalCart -= cartModel.qty;
                    }
                }
                shopModel.products = cartArray;
                if(cartArray.count == 0) [removeShopArray addObject:shopModel];
            }
            for (MDCartShopModel *shopModel in removeShopArray) {
                [_mainCartArray removeObject:shopModel];
            }
            [_mainCheckedArray removeAllObjects];
            [_mainTableView reloadData];
            [self alertGlobalCheckBoxButton];
            if(_mainCartArray.count == 0){
                [self editTap];
                [self noneDataStateView];
            }
        }
        [self.progressView hide];
    }];
}

-(void)deleteCartTappedWithCartModel:(MDCartModel*)cartModel{
    [self.progressView show];
    [_dataController removeCartWithCartId:[NSString stringWithFormat:@"%d",cartModel.cartId] completion:^(BOOL state, NSString *msg) {
        if(state){
            NSMutableArray *cartArray = [[NSMutableArray alloc] init];
            for (MDCartShopModel *shopModel in _mainCartArray) {
                cartArray = [[NSMutableArray alloc] initWithArray:shopModel.products];
                if([cartArray containsObject:cartModel]){
                    if(cartArray.count > 1){
                        [cartArray removeObject:cartModel];
                        shopModel.products = cartArray;
                    }else{
                        [_mainCartArray removeObject:shopModel];
                    }
                    _totalCart -= cartModel.qty;
                    break;
                }
            }
            if(![_mainCheckedArray containsObject:[NSString stringWithFormat:@"%d",cartModel.cartId]]){
                [_mainCheckedArray removeObject:[NSString stringWithFormat:@"%d",cartModel.cartId]];
            }
            [_mainTableView reloadData];
            [self alertGlobalCheckBoxButton];
            if(_mainCartArray.count == 0){
                [self editTap];
                [self noneDataStateView];
            }
        }else{
            [self.view makeToast:msg duration:1 position:CSToastPositionBottom];
        }
        [self.progressView hide];
    }];
}

/**
 *  去登录或去逛逛按钮 触发事件
 *
 *  @param button 触发对象
 */
-(void)noneStateTap:(UIButton*)button{
    NSString *title = button.titleLabel.text;
    if([title isEqualToString:@"去登录"]){
        [self.navigationController pushViewController:[[MDLoginViewController alloc] init] animated:YES];
    }else if([title isEqualToString:@"去逛逛"]){
        [self.tabBarController setSelectedIndex:tab_home_index];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

/**
 *  更改全局全选按钮的选中状态
 */
-(void)alertGlobalCheckBoxButton{
    CheckBoxButton *button;
    if(_isEidtState){
        button = (CheckBoxButton*)[_editFuncitonView viewWithTag:1001];
    }else{
        button = (CheckBoxButton*)[_cartFuncitonView viewWithTag:1001];
    }
    button.checked = (_totalCart > 0 && _mainCheckedArray.count == _totalCart);
}

/**
 *  更改全局购物车商品选中数量
 */
-(void)alertGlobalCartNumber{
    if(_isEidtState) return;
    UIButton *submitButton = (UIButton*)[_cartFuncitonView viewWithTag:1003];
    int totalCount = 0;
    for(MDCartShopModel *shopModel in _mainCartArray){
        for (MDCartModel *cartModel in shopModel.products) {
            if([_mainCheckedArray containsObject:[NSString stringWithFormat:@"%d",cartModel.cartId]]){
                totalCount +=cartModel.qty;
            }
        }
    }
    [submitButton setTitle:[NSString stringWithFormat:@"去结算(%d)",totalCount] forState:UIControlStateNormal];
}

/**
 *  更改全局所有购物车选中商品总计价格
 */
-(void)alertGlobalTotalCartPrice{
    if(_isEidtState) return;
    float totalPrice = 0;
    UILabel *priceLabel = (UILabel*)[_cartFuncitonView viewWithTag:1002];
    for(MDCartShopModel *shopModel in _mainCartArray){
        for (MDCartModel *cartModel in shopModel.products) {
            if([_mainCheckedArray containsObject:[NSString stringWithFormat:@"%d",cartModel.cartId]]){
                totalPrice += cartModel.salesPrice *cartModel.qty;
            }
        }
    }
    [priceLabel setText:[NSString stringWithFormat:@"%.2f",totalPrice]];
}

/**
 *  未登录状态显示提示内容
 */
-(void)noneLoginStateView{
    UILabel *label = [_noneStateView viewWithTag:1002];
    [label setText:@"亲，您尚未登录哦，快去登录查看您的购物车吧！"];
    UIButton *button = [_noneStateView viewWithTag:1003];
    [button setTitle:@"去登录" forState:UIControlStateNormal];
    [_noneStateView setHidden:NO];
    [self.view bringSubviewToFront:_noneStateView];
}

/**
 *  无数据状态显示提示内容
 */
-(void)noneDataStateView{
    UILabel *label = [_noneStateView viewWithTag:1002];
    [label setText:@"亲，您的购物车是空的哦，快去挑选几件喜欢的商品吧！"];
    UIButton *button = [_noneStateView viewWithTag:1003];
    [button setTitle:@"去逛逛" forState:UIControlStateNormal];
    [_noneStateView setHidden:NO];
    [self.view bringSubviewToFront:_noneStateView];
}


#pragma mark private methods
/**
 *  初始化数据
 */
-(void)initData{
    _dataController = [[MDCartDataController alloc] init];
    _mainCheckedArray = [[NSMutableArray alloc] init];
    _mainCartArray = [[NSMutableArray alloc] init];
    _isStart = YES;
    _isEidtState = NO;
    _noneStateForTag = 501;
    _hasDataForTag = 502;
}

/**
 *  配置界面
 */
-(void)setupMainView{
    [self.navigationItem setTitle:@"我的购物车"];
    [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(editTap) forControlEvents:UIControlEventTouchDown];
    if(self.navigationController.viewControllers.count <= 1){
        [self.leftButton setHidden:YES];
    }
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    
    //添加一个未登录提示视图
    _noneStateView = [[UIView alloc] init];
    [_noneStateView setBackgroundColor:UIColorFromRGB(247, 247, 247)];
    [_noneStateView setHidden:YES];
    [self.view addSubview:_noneStateView];
    [_noneStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    
    [self bringNoLoginStateForViewWithSuperView:_noneStateView];
    
    BOOL hasTabBar = (!self.tabBarController.tabBar.isHidden);
    int bottomInsert = hasTabBar ? 44 : 0;
    //添加一个有数据的视图
    _mainTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_mainTableView setDataSource:self];
    [_mainTableView setDelegate:self];
    [_mainTableView setMj_header:[MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)]];
    
    if(__IPHONE_SYSTEM_VERSION > 7) _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, bottomInsert, 0));
    }];
    [self bringCartFunctionViewWithSuperView:self.view hasTabBar:hasTabBar];
    [self refreshData];
}

/**
 *  生成显示购物车店铺信息的UITableViewCell
 *
 *  @param identifier cell的identifier
 *
 *  @return UITableViewCell
 */
-(UITableViewCell*)bringCartCellForShopInformationWithIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    CheckBoxButton *selectButton = [[CheckBoxButton alloc] initWithChecked:false];
    [selectButton addTarget:self action:@selector(shopChecked:) forControlEvents:UIControlEventTouchDown];
    [selectButton setTag:1001];
    [cell addSubview:selectButton];
    [selectButton setRadius:10];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(20);//
        make.centerY.equalTo(cell);
        make.left.equalTo(cell.mas_left).with.offset(16);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:@""];
    [label setTag:1002];
    [label setTextColor:UIColorFromRGB(51, 51, 51)];
    [label setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(selectButton.mas_right).with.offset(8);
        make.right.equalTo(cell.mas_right).with.offset(-8);
        make.height.mas_equalTo(30);
    }];
    return cell;
}

/**
 *  生成显示购物车店铺商品的小计的UITableViewCell
 *
 *  @param identifier cell的identifier
 *
 *  @return UITableViewCell
 */
-(UITableViewCell*)bringCartCellForShopTotalPriceWithIdentifier:(NSString*)identifier{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UILabel *namelabel = [[UILabel alloc] init];
    [namelabel setText:@"小计："];
    [namelabel setTag:1001];
    [namelabel setTextColor:UIColorFromRGB(51, 51, 51)];
    [namelabel setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:namelabel];
    [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell.mas_left).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(45, 30));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [label setTag:1002];
    [label setText:@"￥0.00"];
    [label setTextColor:UIColorFromRGB(51, 51, 51)];
    [label setFont:[UIFont systemFontOfSize:14]];
    [cell addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(namelabel.mas_right).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(-8);
        make.height.mas_equalTo(30);
    }];
    return cell;
}

/**
 *  编辑状态功能区显示视图的内容
 *
 *  @param superView 父级视图
 *  @param hasTabBar 是否有tabber存在
 */
-(void)bringEditFunctionViewWithSuperView:(UIView*)superView hasTabBar:(BOOL)hasTabBar{
    //int bottom =  hasTabBar ? -44 : 0;
    int bottom = 0;
    _editFuncitonView = [[UIView alloc] init];
    [_editFuncitonView setBackgroundColor:UIColorFromRGBA(255, 255, 255, 1)];
    [superView addSubview:_editFuncitonView];
    [_editFuncitonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.left.equalTo(superView.mas_left).with.offset(0);
        make.right.equalTo(superView.mas_right).with.offset(0);
        make.bottom.equalTo(superView.mas_bottom).with.offset(bottom);
    }];
    
    CheckBoxButton *selectButton = [[CheckBoxButton alloc] initWithChecked:false];
    [selectButton addTarget:self action:@selector(allCartChecked:) forControlEvents:UIControlEventTouchDown];
    [selectButton setRadius:10];
    [selectButton setChecked:YES];
    [selectButton setTag:1001];
    [_editFuncitonView addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(_editFuncitonView);
        make.left.equalTo(_editFuncitonView.mas_left).with.offset(8);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setText:@"全选"];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [_editFuncitonView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 30));
        make.left.equalTo(selectButton.mas_right).with.offset(8);
        make.centerY.equalTo(_editFuncitonView);
    }];
    
    UIButton *submitButton = [[UIButton alloc] init];
    [submitButton setTitle:@"删除" forState:UIControlStateNormal];
    [submitButton setTag:1003];
    [submitButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [submitButton setBackgroundColor:UIColorFromRGB(255, 80, 0)];
    [submitButton.layer setBorderWidth:1];
    [submitButton.layer setBorderColor:[UIColorFromRGB(255, 80, 0) CGColor]];
    [submitButton.layer setCornerRadius:5];
    [submitButton.layer setMasksToBounds:YES];
    [submitButton addTarget:self action:@selector(deleteCartsTapped) forControlEvents:UIControlEventTouchUpInside];
    [_editFuncitonView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.right.equalTo(_editFuncitonView.mas_right).with.offset(-8);
        make.centerY.equalTo(_editFuncitonView);
    }];
    
    [superView bringSubviewToFront:_editFuncitonView];
}

/**
 *  购物车状态功能区显示视图的内容
 *
 *  @param superView 父级视图
 *  @param hasTabBar 是否有tabber存在
 */
-(void)bringCartFunctionViewWithSuperView:(UIView*)superView hasTabBar:(BOOL)hasTabBar{
    //int bottom =  hasTabBar ? -44 : 0;
    int bottom =  0;
    _cartFuncitonView = [[UIView alloc] init];
    [_cartFuncitonView setBackgroundColor:UIColorFromRGBA(255, 255, 255, 1)];
    [superView addSubview:_cartFuncitonView];
    [_cartFuncitonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.left.equalTo(superView.mas_left).with.offset(0);
        make.right.equalTo(superView.mas_right).with.offset(0);
        make.bottom.equalTo(superView.mas_bottom).with.offset(bottom);
    }];
    
    CheckBoxButton *selectButton = [[CheckBoxButton alloc] initWithChecked:false];
    [selectButton addTarget:self action:@selector(allCartChecked:) forControlEvents:UIControlEventTouchDown];
    [selectButton setRadius:10];
    [selectButton setChecked:YES];
    [selectButton setTag:1001];
    [_cartFuncitonView addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(_cartFuncitonView);
        make.left.equalTo(_cartFuncitonView.mas_left).with.offset(8);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setText:@"总计："];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [_cartFuncitonView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 30));
        make.left.equalTo(selectButton.mas_right).with.offset(8);
        make.centerY.equalTo(_cartFuncitonView);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setTextAlignment:NSTextAlignmentLeft];
    [priceLabel setFont:[UIFont systemFontOfSize:14]];
    [priceLabel setText:@"￥0.00"];
    [priceLabel setTag:1002];
    [_cartFuncitonView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.left.equalTo(nameLabel.mas_right).with.offset(8);
        make.centerY.equalTo(_cartFuncitonView);
        
    }];
    
    UIButton *submitButton = [[UIButton alloc] init];
    [submitButton setTitle:@"去结算(0)" forState:UIControlStateNormal];
    [submitButton setTag:1003];
    [submitButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [submitButton setBackgroundColor:UIColorFromRGB(255, 80, 0)];
    [submitButton.layer setBorderWidth:1];
    [submitButton.layer setBorderColor:[UIColorFromRGB(255, 80, 0) CGColor]];
    [submitButton.layer setCornerRadius:5];
    [submitButton.layer setMasksToBounds:YES];
    [submitButton addTarget:self action:@selector(submitCartTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_cartFuncitonView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.right.equalTo(_cartFuncitonView.mas_right).with.offset(-8);
        make.centerY.equalTo(_cartFuncitonView);
    }];
    
    [superView bringSubviewToFront:_cartFuncitonView];
}

/**
 *  生成未登录或无数据的提示界面，包含一个UIImageView和一个提示信息UILabel、一个UIButton
 *
 *  @param superView 父级视图
 */
-(void)bringNoLoginStateForViewWithSuperView:(UIView*)superView{
    float top = (SCREEN_HEIGHT - 275)/2;
    float width = SCREEN_WIDTH/2;
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImage:[UIImage imageNamed:@"blankcart"]];
    [imageView setTag:1001];
    [superView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 82));
        make.centerX.equalTo(superView);
        make.top.equalTo(superView.mas_top).with.offset(top);
        //make.top.equalTo(superView.mas_top).with.offset(100);
        
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [label setTag:1002];
    [label setText:@""];
    [label setNumberOfLines:2];
    [label setTextColor:UIColorFromRGB(204, 204, 204)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [superView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width + width/2, 70));
        make.centerX.equalTo(superView);
        make.top.equalTo(imageView.mas_bottom).with.offset(20);
    }];
    
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button.layer setCornerRadius:2];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1];
    [button setTag:1003];
    [button.layer setBorderColor: [UIColorFromRGB(252, 80, 2) CGColor]];
    [button setBackgroundColor:UIColorFromRGB(252, 80, 2)];
    [button addTarget:self action:@selector(noneStateTap:) forControlEvents:UIControlEventTouchDown];
    [superView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, 35));
        make.centerX.equalTo(superView);
        make.top.equalTo(label.mas_bottom).with.offset(20);
    }];
}



/**
 *  根据选中的购物车商品按照指定的数据格式获取json数据
 *
 *  @return json数据
 */
-(NSString*)orderParameterForJson{
    if(_mainCheckedArray.count == 0) return nil;
    NSMutableArray *products = [[NSMutableArray alloc] init];
    NSMutableArray *shops = [[NSMutableArray alloc] init];
    for (MDCartShopModel *shopModel in _mainCartArray) {
        products = [[NSMutableArray alloc] init];
        for (MDCartModel *cartModel in shopModel.products) {
            if([_mainCheckedArray containsObject:[NSString stringWithFormat:@"%d",cartModel.cartId]]){
                [products addObject:@{@"prodId":[NSString stringWithFormat:@"%d",cartModel.productId],@"prodSkuId":[NSString stringWithFormat:@"%d",cartModel.skuId],@"qty":[NSString stringWithFormat:@"%d",cartModel.qty]}];
            }
        }
        if(products.count > 0){
            [shops addObject:@{@"shopId":[NSString stringWithFormat:@"%d",shopModel.shopId],@"products":products,@"deliveryType":@"",@"remark":@""}];
        }
    }
    if(shops.count == 0) return nil;
    NSError *error;
    NSDictionary *prodJson = @{@"userId":APPDATA.userId,@"shopProducts":shops,@"addrId":@""};
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:prodJson options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding];
}

/**
 *  设置cell隐藏的按钮
 *
 *  @return 数组
 */
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    //    [rightUtilityButtons sw_addUtilityButtonWithColor:
    //     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
    //                                                title:@"移入收藏"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"移除"];
    
    return rightUtilityButtons;
}


@end
