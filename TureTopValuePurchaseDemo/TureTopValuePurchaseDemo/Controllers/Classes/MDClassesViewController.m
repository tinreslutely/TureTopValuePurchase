//
//  MDClassesViewController.m
//  TureTopValuePurchaseDemo
//  产品类目控制器
//  Created by 李晓毅 on 16/1/12.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDClassesViewController.h"
#import "MDClassesDataController.h"
#import "MultilevelMenu.h"

#import "MDGoodsViewController.h"

@interface MDClassesViewController ()<MultilvevlMenuDelegate>

@end

@implementation MDClassesViewController{
    MDClassesDataController *_dataController;
    MultilevelMenu * _mainMenuView;
    NSArray *_firstArray;
    NSMutableArray *_secondArray;
    
    rightMeun *_selectMeun;
}

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(_firstArray && _firstArray.count == 0){
        [self initDataWithCompletion:^{
            [self initMenu];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark MultilvevlMenuDelegate
-(void)multilvevlMenu:(id)menu tableSelectedWithTableView:(UITableView*)tableView collectionView:(UICollectionView*)collectionView selectIndex:(int)index{
    MDClassesModel *model = _firstArray[index];
    if(model != nil){
        [self.progressView show];
        [self requestDataForSecondWithTypeId:model.typeId categoryType:model.categoryType completion:^{
            [self.progressView hide];
            [collectionView reloadData];
        }];
    }
}

//collectionview选择后触发
-(void)multilvevlMenu:(id)menu collectionSelectedWithCollectionView:(UICollectionView*)collectionView rightMeun:(rightMeun*)rightMeun{
    _selectMeun = rightMeun;
    MDGoodsViewController *controller = [[MDGoodsViewController alloc] init];
    controller.categoryId = [_selectMeun.ID intValue];
    [self.navigationController pushViewController:controller animated:YES];
}

//设置右边的数据源
-(NSArray*)multilvevlMenu:(id)menu dataSourceWithRightCollection:(UICollectionView*)rightCollection{
    return [self convertDataForSecondArray];
}

#pragma mark private methods
-(void)initData{
    _dataController = [[MDClassesDataController alloc] init];
    _firstArray = [[NSArray alloc] init];
}
/**
 *  初始化视图
 */
-(void)initView{
    [self.navigationItem setTitle:@"类目"];
    [self.leftButton setHidden:YES];
    
}

/**
 *  初始化数据
 *
 *  @param success 获取数据成功时的回调
 */
-(void)initDataWithCompletion:(void(^)())completion{
    [self.progressView show];
    [_dataController requestFirstDataWithCompletion:^(BOOL state, NSString *msg, NSArray<MDClassesModel *> *list) {
        [self.progressView hide];
        if(state){
            _firstArray = [list copy];
            MDClassesModel *categoryModel = [_firstArray firstObject];
            if(categoryModel != nil){
                [self requestDataForSecondWithTypeId:categoryModel.typeId categoryType:categoryModel.categoryType completion:^{
                    if(completion) completion();
                }];
            }
        }
    }];
}


/**
 *  根据类目类型，类目编号的条件请求二、三级类目数据
 *
 *  @param typeId       类目类型
 *  @param categoryType 类目编号
 *  @param success      成功回调block
 */
-(void)requestDataForSecondWithTypeId:(int)typeId categoryType:(int)categoryType completion:(void(^)())completion{
    [_dataController requestSecondDataWithTypeId:typeId cType:categoryType completion:^(BOOL state, NSString *msg, NSArray<MDClassesModel *> *list) {
        if(state){
            _secondArray = [list copy];
        }
        completion();
    }];
}

/**
 *  初始化菜单
 */
-(void)initMenu{
    //默认是 选中第一行
    _mainMenuView=[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-108) tableData:[self convertDataForFirstArray] collectionData:[self convertDataForSecondArray] ];
    _mainMenuView.needToScorllerIndex=0;
    _mainMenuView.isRecordLastScroll=YES;
    _mainMenuView.delegate = self;
    [self.view addSubview:_mainMenuView];
}

/**
 *  将左侧数据转换指定的rightMeun数据结构
 *
 *  @return 返回数组
 */
-(NSArray*)convertDataForFirstArray{
    NSMutableArray * tableArray=[NSMutableArray arrayWithCapacity:0];
    rightMeun * meun;
    for (MDClassesModel *model in _firstArray) {
        meun=[[rightMeun alloc] init];
        meun.meunName = model.sysTypeName;
        if(model.typeCover != nil) meun.urlName = model.typeCover;
        meun.ID = [NSString stringWithFormat:@"%d",model.typeId];
        [tableArray addObject:meun];
    }
    return tableArray;
}

/**
 *  将右侧数据转换指定的rightMeun数据结构
 *
 *  @return 返回数组
 */
-(NSArray*)convertDataForSecondArray{
    NSMutableArray *collectionArray = [[NSMutableArray alloc] init];
    rightMeun *meun;
    for (MDClassesModel *model in _secondArray) {
        meun=[[rightMeun alloc] init];
        meun.meunName = model.sysTypeName;
        if(model.typeCover != nil) meun.urlName = model.typeCover;
        meun.ID = [NSString stringWithFormat:@"%d",model.typeId];
        
        NSMutableArray *nextArray = [[NSMutableArray alloc] init];
        rightMeun *smeun = [[rightMeun alloc] init];
        for (MDClassesModel *smodel in model.secondTypes) {
            smeun=[[rightMeun alloc] init];
            smeun.meunName = smodel.sysTypeName;
            if(smodel.typeCover != nil) smeun.urlName = smodel.typeCover;
            smeun.ID = [NSString stringWithFormat:@"%d",smodel.typeId];
            [nextArray addObject:smeun];
            
        }
        meun.nextArray = nextArray;
        [collectionArray addObject:meun];
    }
    return collectionArray;
}


@end
