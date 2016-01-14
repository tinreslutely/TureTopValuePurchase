//
//  MDHomeDataController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/1/14.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDHomeDataController.h"


@implementation MDHomeDataController{
    NSArray<MDHomeRenovateChannelModel*> *_channelList;
    
    NSString *_type;
    float _bannerHeight;
    float _imageHeight;
    float _proImageHeight;
    float _rmShopHeight;
    
    int _pageIndex;
    int _pageSize;
    int _pageTotal;
    BOOL _isLast;
}

@synthesize scrollBlock;

-(instancetype)init{
    if(self = [super init]){
        [self initData];
    }
    return self;
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    scrollBlock(scrollView.contentOffset.y);
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0.1 : 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = _imageHeight + _proImageHeight + 45;
    if(_channelList.count > 0){
        MDHomeRenovateChannelModel *model = _channelList[indexPath.section];
        switch (model.columnType) {
            case 0:
                height = _bannerHeight + 156;
                break;
            case 2:
                height = _rmShopHeight + 30;
                break;
            default:
                break;
        }
    }
    return height;
}


#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 1;
    return number;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _channelList.count;
    //return _mainModules.count + (_mainModules.count > 0 ? 1 : 0);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *bannerFunctionCellIdentifier = @"BannerFunctionCell";//banner
    static NSString *productRMCellIdentifier = @"ProductRMCell";//productRM
    static NSString *likeProductTitleCellIdentifier = @"LikeProductTitleCell";//likeProductTitle
    static NSString *likeProductCellIdentifier = @"LikeProductCell";//likeProduct
    static NSString *rmShopCellIdentifier = @"RMShopCell";//likeProduct
    UITableViewCell *cell = nil;
    if(indexPath.section < _channelList.count){
        MDHomeRenovateChannelModel *model = _channelList[indexPath.section];
        switch (model.columnType) {
            case 0://焦点图类型
            {
                cell = [tableView dequeueReusableCellWithIdentifier:bannerFunctionCellIdentifier];
                if(cell == nil){
                    cell = [self bringBannerAndIconButtonForCellWithIdentifier:bannerFunctionCellIdentifier array:model.channelColumnDetails];
                }
            }
                break;
            case 1://一个标题、一张图片、三个推荐产品
            {
                cell = [tableView dequeueReusableCellWithIdentifier:productRMCellIdentifier];
                if(cell == nil){
                    cell = [self bringProductRecommendForCellWithIdentifier:productRMCellIdentifier];
                }
                UILabel *label = [cell viewWithTag:1001];
                [label setText:model.columnName];
                if(model.channelColumnDetails.count > 0){
                    UIButton *button = [cell viewWithTag:1002];
                    [button sd_setImageWithURL:[NSURL URLWithString:((MDHomeRenovateChannelDetailModel *)model.channelColumnDetails[0]).picAddr] forState:UIControlStateNormal];
                }
                UIView *productsView = [cell viewWithTag:1003];
                for(int i = 1;i< model.channelColumnDetails.count && i < productsView.subviews.count + 1;i++){
                    MDHomeRenovateChannelDetailModel *item = model.channelColumnDetails[i];
                    UIButton *button = productsView.subviews[i-1];
                    if(button != nil){
                        [button sd_setImageWithURL:[NSURL URLWithString:item.picAddr] forState:UIControlStateNormal];
                    }
                }
            }
                break;
            case 2://推荐店铺
            {
                NSArray * array = model.channelColumnDetails;
                NSMutableArray *imageURLArray = [[NSMutableArray alloc] init];
                NSMutableArray *titleArray = [[NSMutableArray alloc] init];
                for (MDHomeRenovateChannelDetailModel *item in array) {
                    [imageURLArray addObject:item.picAddr];
                    [titleArray addObject:item.content];
                }
                cell = [tableView dequeueReusableCellWithIdentifier:rmShopCellIdentifier];
                if(cell == nil){
                    cell = [self bringRMShopCellWidthIdentifier:rmShopCellIdentifier];
                }
                UILabel *label = [cell viewWithTag:1001];
                [label setText:model.columnName];
                ImageCarouselView *view = [cell viewWithTag:1002];
                [view setImageURLStringsGroup:imageURLArray];
                [view setTitlesGroup:titleArray];
            }
                break;
        }
    }else{
//        if(indexPath.row == 0){
//            cell = [tableView dequeueReusableCellWithIdentifier:likeProductTitleCellIdentifier];
//            if(cell == nil){
//                cell = [self bringLikeProductTitleCellWidthIdentifier:likeProductTitleCellIdentifier];
//            }
//        }else{
//            cell = [tableView dequeueReusableCellWithIdentifier:likeProductCellIdentifier];
//            if(cell == nil){
//                cell = [self bringLikeProductCellWidthIdentifier:likeProductCellIdentifier];
//            }
//            MDHomeLikeProductModel *model;
//            UIImageView *imageView;// = [cell viewWithTag:1001];
//            UILabel *titleLabel;// = [cell viewWithTag:1002];
//            UILabel *priceLabel;// = [cell viewWithTag:1003];
//            int index = ((int)indexPath.row - 1) * 2;
//            NSArray *array = cell.contentView.subviews;
//            for(UIControl *view in array){
//                if(![view isKindOfClass:[UIControl class]]) continue;
//                imageView = [view viewWithTag:1001];
//                titleLabel = [view viewWithTag:1002];
//                priceLabel = [view viewWithTag:1003];
//                if( index < _likeProductArray.count){
//                    model = _likeProductArray[index];
//                    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_300x300",model.imageURL]]];
//                    [titleLabel setText:model.title];
//                    [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.sellPirce]];
//                }
//                index ++;
//            }
//        }
    }
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xxx"];
    }
    
    return cell;
}

#pragma mark public methods
-(void)refreshDataWithCompletion:(void(^)(BOOL state))completion{
    [self requestDataWithType:@"1" completion:^(BOOL state, NSString *msg, NSArray<MDHomeRenovateChannelModel*> *list){
        if(state){
            _channelList = [list copy];
        }
        completion(state);
    }];
}

#pragma mark private methods

/**
 *  初始化数据
 */
-(void)initData{
    _channelList = [[NSArray alloc] init];
    _type = 0; //0-超值购  1-快乐购
    _bannerHeight = SCREEN_WIDTH*300/640;
    _imageHeight = SCREEN_WIDTH*200/640;
    _proImageHeight = SCREEN_WIDTH*260/214/3;
    _rmShopHeight = SCREEN_WIDTH/3;
    _pageIndex = 1;
    _pageSize = 10;
    _isLast = NO;
}
-(void)requestDataWithType:(NSString*)type completion:(void(^)(BOOL state, NSString *msg, NSArray<MDHomeRenovateChannelModel*> *list))completion{
    [LDUtils readDataWithResourceName:@"data-home" successBlock:^(NSDictionary *returnData) {
        MDHomeRenovateModel *renovateModel = [[MDHomeRenovateModel alloc] init];
        renovateModel.stateCode = [returnData objectForKey:@"state"];
        if(![renovateModel.stateCode isEqualToString:@"200"]){
            renovateModel.state = NO;
            renovateModel.message = [returnData objectForKey:@"result"];
            completion(renovateModel.state,renovateModel.message,@[]);
            return;
        }
        renovateModel.state = YES;
        renovateModel.list = [MDHomeRenovateChannelModel mj_objectArrayWithKeyValuesArray:[[returnData objectForKey:@"result"] objectForKey:@"list"]];
        for (MDHomeRenovateChannelModel *channelModel in renovateModel.list) {
            channelModel.channelColumnDetails = [MDHomeRenovateChannelDetailModel mj_objectArrayWithKeyValuesArray:channelModel.channelColumnDetails];
        }
        completion(renovateModel.state,renovateModel.message,renovateModel.list);
    } failureBlock:^(LDReadResourceStateType stateType, NSString *msg) {
        completion(NO,msg,@[]);
    }];
}



#pragma mark bring cell methods
/**
 *  生成一个包含导航标题和一个按钮图片轮播控件的UITableViewCell
 *  用于铭道好店模块
 *  @param identifier cell的identifier
 *
 *  @return UITableViewCell
 */
-(UITableViewCell *)bringProductRecommendForCellWithIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //添加一个导航标题
    UIView *navView = [[UIView alloc] init];
    [cell addSubview: navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.top.equalTo(cell.mas_top).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
    }];
    
    UIButton *moreButton = [[UIButton alloc] init];
    [moreButton setTitle:@"更多＞" forState:UIControlStateNormal];
    [moreButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [moreButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(rmMoreTap:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navView.mas_right).with.offset(-8);
        make.centerY.equalTo(navView);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTag:1001];
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView.mas_left).with.offset(8);
        make.right.equalTo(moreButton.mas_left).with.offset(8);
        make.centerY.equalTo(navView);
        make.height.mas_equalTo(30);
    }];
    
    //添加一个图片
    UIButton *imageButton = [[UIButton alloc] init];
    imageButton.tag = 1002;
    [imageButton addTarget:self action:@selector(rmImageDetailTap:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview: imageButton];
    [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_imageHeight);
        make.top.equalTo(navView.mas_bottom).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
    }];
    
    //添加一个推荐产品行
    UIView *productsView = [[UIView alloc] init];
    [productsView setTag:1003];
    [cell addSubview: productsView];
    [productsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageButton.mas_bottom).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
        make.bottom.equalTo(cell.mas_bottom).with.offset(0);
    }];
    
    float width = SCREEN_WIDTH/3;
    float point_x = 0;
    UIButton *productButton = [[UIButton alloc] initWithFrame:CGRectMake(point_x, 0, width, _proImageHeight)];
    [productButton addTarget:self action:@selector(rmProductDetailTap:) forControlEvents:UIControlEventTouchUpInside];
    [productsView addSubview:productButton];
    point_x += width;
    productButton = [[UIButton alloc] initWithFrame:CGRectMake(point_x, 0, width, _proImageHeight)];
    [productButton addTarget:self action:@selector(rmProductDetailTap:) forControlEvents:UIControlEventTouchUpInside];
    [productsView addSubview:productButton];
    point_x += width;
    productButton = [[UIButton alloc] initWithFrame:CGRectMake(point_x, 0, width, _proImageHeight)];
    [productButton addTarget:self action:@selector(rmProductDetailTap:) forControlEvents:UIControlEventTouchUpInside];
    [productsView addSubview:productButton];
    
    return cell;
}

/**
 *  生成一个包含banner控件和由五个功能按钮组成的UIView的UITableViewCell
 *
 *  @param identifier cell 的 identifier
 *  @param array      banner控件的数据模型
 *
 *  @return UITableViewCell对象
 */
-(UITableViewCell *)bringBannerAndIconButtonForCellWithIdentifier:(NSString*)identifier array:(NSArray*)array{
    //获取图片路径集合
    NSMutableArray *imageURLStrings = [[NSMutableArray alloc] init];
    for (MDHomeRenovateChannelDetailModel *model in array) {
        [imageURLStrings addObject:model.picAddr];
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bannerHeight) imageURLStringsGroup:imageURLStrings];
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.autoScrollTimeInterval = 4.0;
    cycleScrollView.delegate = self;
    [cell addSubview:cycleScrollView];
    [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, _bannerHeight));
        make.top.equalTo(cell.mas_top).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
    }];
    
    UIView *view = [[UIView alloc] init];
    [cell addSubview: view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cycleScrollView.mas_bottom).with.offset(0);
        make.bottom.equalTo(cell.mas_bottom).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
    }];
    
    CGFloat width = SCREEN_WIDTH/3;
    CGFloat height = 60;
    CGFloat iconSize = 40;
    int point_x = 0;
    int point_y = 12;
    [self createIconAndTitleForControlWithSuperView:view title:@"面对面支付" icon:@"h_facespay" target:self action:@selector(functionTap:) rect:CGRectMake(point_x, point_y, width, height) iconSize:iconSize];
    point_x += width;
    [self createIconAndTitleForControlWithSuperView:view title:@"快乐购" icon:@"h_happlybuy" target:self action:@selector(functionTap:) rect:CGRectMake(point_x, point_y, width, height) iconSize:iconSize];
    point_x += width;
    [self createIconAndTitleForControlWithSuperView:view title:@"我要购卡" icon:@"h_buycard" target:self action:@selector(functionTap:) rect:CGRectMake(point_x, point_y, width, height) iconSize:iconSize];
    point_y += 72;
    point_x = 0;
    [self createIconAndTitleForControlWithSuperView:view title:@"开通资格" icon:@"h_opencerfiticate" target:self action:@selector(functionTap:) rect:CGRectMake(point_x, point_y, width, height) iconSize:iconSize];
    point_x += width;
    [self createIconAndTitleForControlWithSuperView:view title:@"铭道书院" icon:@"h_mdschool" target:self action:@selector(functionTap:) rect:CGRectMake(point_x, point_y, width, height) iconSize:iconSize];
    return cell;
}

/**
 *  生成一个包含标题的UITableViewCell
 *  用于显示您可能喜欢的商品模块
 *
 *  @param identifier cell 的identifier
 *
 *  @return UITableViewCell
 */
-(UITableViewCell*)bringLikeProductTitleCellWidthIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel *bglabel = [[UILabel alloc] init];
    [bglabel.layer setBorderWidth:0.5];
    [bglabel.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [cell addSubview:bglabel];
    [bglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
        make.centerY.equalTo(cell);
    }];
    
    UILabel *titlelabel = [[UILabel alloc] init];
    [titlelabel setFont:[UIFont systemFontOfSize:14]];
    [titlelabel setTextAlignment:NSTextAlignmentCenter];
    [titlelabel setText:@"您可能喜欢的商品"];
    [titlelabel setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:titlelabel];
    [cell bringSubviewToFront:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 30));
        make.center.equalTo(cell);
    }];
    
    return cell;
}

/**
 *  生成一个包含两个产品显示信息的UIControl的UITableViewCell
 *  你可能喜欢模块
 *
 *  @param identifier Cell的identifier
 *
 *  @return UITableViewCell对象
 */
-(UITableViewCell*)bringLikeProductCellWidthIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    float width = SCREEN_WIDTH/2 - 15;
    float pointX = 10;
    [self createImageAndTwoTextForControlWithSuperView:cell.contentView pointX:pointX width:width height:width+80];
    pointX += width + 10;
    [self createImageAndTwoTextForControlWithSuperView:cell.contentView pointX:pointX width:width height:width+80];
    
    return cell;
}

/**
 *  生成一个包含一个导航标题、一个轮播控件的UITableViewCell
 *  用于铭道好店模块
 *
 *  @param identifier cell的identifier
 *
 *  @return 返回UITableViewCell对象
 */
-(UITableViewCell*)bringRMShopCellWidthIdentifier:(NSString*)identifier{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //添加一个导航标题
    UIView *navView = [[UIView alloc] init];
    [cell addSubview: navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.top.equalTo(cell.mas_top).with.offset(0);
        make.left.equalTo(cell.mas_left).with.offset(0);
        make.right.equalTo(cell.mas_right).with.offset(0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTag:1001];
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView.mas_left).with.offset(8);
        make.right.equalTo(navView.mas_right).with.offset(8);
        make.centerY.equalTo(navView);
        make.height.mas_equalTo(30);
    }];
    
    ImageCarouselView *cycleScrollView = [[ImageCarouselView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 100)];
    [cycleScrollView setTag:1002];
    [cycleScrollView setBackgroundColor:[UIColor whiteColor]];
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.pageControlStyle = ImageCarouselViewPageContolStyleAnimated;
    cycleScrollView.showPageControl = NO;
    cycleScrollView.delegate = self;
    [cell addSubview:cycleScrollView];
    return cell;
}

/**
 *  创建一个包含图片和一个标题，一个价格的产品信息UIControl
 *  用于可能喜欢商品模块的商品显示
 *
 *  @param superView 所属父级
 *  @param pointX    x坐标
 *  @param width     控件宽度
 *  @param height    控件高度
 */
-(void)createImageAndTwoTextForControlWithSuperView:(UIView*)superView pointX:(float)pointX width:(float)width height:(float)height{
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(pointX, 0, width, height)];
    [control addTarget:self action:@selector(likeProductDetailTap:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:control];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setTag:1001];
    [control addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(control.mas_top).with.offset(15);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
        make.height.mas_equalTo(width);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setTag:1002];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [control addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(0);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setTag:1003];
    [priceLabel setFont:[UIFont systemFontOfSize:14]];
    [priceLabel setTextColor:[UIColor redColor]];
    [control addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(0);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    
}


#pragma mark bring control methods

/**
 *  创建一个包含一个UIImageView和一个UILabel，上下层级的UIControl
 *
 *  @param superView 所属父级
 *  @param title     显示的文本内容
 *  @param icon      图标路径
 *  @param target    目标
 *  @param action    事件
 *  @param rect      CGRect属性
 *  @param iconSize  图标大小
 */
-(void)createIconAndTitleForControlWithSuperView:(UIView*)superView title:(NSString*)title icon:(NSString*)icon target:(_Nullable id)target action:(SEL)action rect:(CGRect)rect iconSize:(float)iconSize {
    UIControl *control = [[UIControl alloc] initWithFrame:rect];
    [control addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:control];
    
    //添加一个imageview
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:icon]];
    [control addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(iconSize, iconSize));
        make.top.equalTo(control.mas_top).with.offset(0);
        make.centerX.equalTo(control);
    }];
    //添加一个文本label
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:14]];
    [control addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(21);
        make.top.equalTo(imageView.mas_bottom).with.offset(5);
        make.left.equalTo(control.mas_left).with.offset(0);
        make.right.equalTo(control.mas_right).with.offset(0);
    }];
}

@end
