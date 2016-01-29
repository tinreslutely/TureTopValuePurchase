//
//  MultilevelMenu.m
//  MultilevelMenu
//  类目菜单
//  Created by gitBurning on 15/3/13.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "MultilevelMenu.h"
#import "MultilevelTableViewCell.h"
#import "MultilevelCollectionViewCell.h"
#import "UIImageView+WebCache.h"

#define kCellRightLineTag 100
#define kImageDefaultName @"tempShop"
#define kMultilevelCollectionViewCell @"MultilevelCollectionViewCell"
#define kMultilevelCollectionHeader   @"CollectionHeader"//CollectionHeader
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MultilevelMenu()

@property(strong,nonatomic ) UITableView * leftTablew;
@property(strong,nonatomic ) UICollectionView * rightCollection;

@property(assign,nonatomic) BOOL isReturnLastOffset;

@end
@implementation MultilevelMenu


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame tableData:(NSArray *)tableData collectionData:(NSArray*)collectionData
{
    self=[super initWithFrame:frame];
    if (self) {
        if (tableData.count==0) {
            return nil;
        }
        self.leftSelectColor=[UIColor redColor];//左边选中的颜色
        self.leftSelectBgColor=[UIColor whiteColor];//背景色
        self.leftBgColor=UIColorFromRGBValue(0xF3F4F6);
        self.leftSeparatorColor=UIColorFromRGBValue(0xE5E5E5);
        self.leftUnSelectBgColor=UIColorFromRGBValue(0xF3F4F6);
        self.leftUnSelectColor=[UIColor blackColor];
        
        _isRefreshData = NO;
        _selectIndex=0;
        _tableData = [[NSMutableArray alloc] initWithArray:tableData];
        _collectionData = [[NSMutableArray alloc] initWithArray:collectionData];
        
        /**
         左边的视图
        */
        self.leftTablew=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftWidth, frame.size.height)];
        self.leftTablew.dataSource=self;
        self.leftTablew.delegate=self;
        
        self.leftTablew.tableFooterView=[[UIView alloc] init];
        [self addSubview:self.leftTablew];
        self.leftTablew.backgroundColor=self.leftBgColor;
        if ([self.leftTablew respondsToSelector:@selector(setLayoutMargins:)]) {
            self.leftTablew.layoutMargins=UIEdgeInsetsZero;
        }
        if ([self.leftTablew respondsToSelector:@selector(setSeparatorInset:)]) {
            self.leftTablew.separatorInset=UIEdgeInsetsZero;
        }
        self.leftTablew.separatorColor=self.leftSeparatorColor;
        
        
        /**
         右边的视图
         */
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing=0.f;//左右间隔
        flowLayout.minimumLineSpacing=0.f;
        float leftMargin =0;
        self.rightCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(kLeftWidth+leftMargin,0,kScreenWidth-kLeftWidth-leftMargin*2,frame.size.height) collectionViewLayout:flowLayout];
        
        self.rightCollection.delegate=self;
        self.rightCollection.dataSource=self;
        
        UINib *nib=[UINib nibWithNibName:kMultilevelCollectionViewCell bundle:nil];
        
        [self.rightCollection registerNib: nib forCellWithReuseIdentifier:kMultilevelCollectionViewCell];
        
        
        UINib *header=[UINib nibWithNibName:kMultilevelCollectionHeader bundle:nil];
        [self.rightCollection registerNib:header forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMultilevelCollectionHeader];
        
        [self addSubview:self.rightCollection];
        
      
        self.isReturnLastOffset=YES;
        
        self.rightCollection.backgroundColor=self.leftSelectBgColor;

        self.backgroundColor=self.leftSelectBgColor;
        
    }
    return self;
}

-(void)setNeedToScorllerIndex:(NSInteger)needToScorllerIndex{
    
        /**
         *  滑动到 指定行数
         */
        [self.leftTablew selectRowAtIndexPath:[NSIndexPath indexPathForRow:needToScorllerIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

        _selectIndex=needToScorllerIndex;
        
        [self.rightCollection reloadData];

    _needToScorllerIndex=needToScorllerIndex;
}
-(void)setLeftBgColor:(UIColor *)leftBgColor{
    _leftBgColor=leftBgColor;
    self.leftTablew.backgroundColor=leftBgColor;
   
}
-(void)setLeftSelectBgColor:(UIColor *)leftSelectBgColor{
    
    _leftSelectBgColor=leftSelectBgColor;
    self.rightCollection.backgroundColor=leftSelectBgColor;
    
    self.backgroundColor=leftSelectBgColor;
}
-(void)setLeftSeparatorColor:(UIColor *)leftSeparatorColor{
    _leftSeparatorColor=leftSeparatorColor;
    self.leftTablew.separatorColor=leftSeparatorColor;
}
-(void)reloadData{
    
    [self.leftTablew reloadData];
    [self.rightCollection reloadData];
    
}
-(void)setLeftTablewCellSelected:(BOOL)selected withCell:(MultilevelTableViewCell*)cell
{
    UILabel * line=(UILabel*)[cell viewWithTag:kCellRightLineTag];
    if (selected) {
        
        line.backgroundColor=cell.backgroundColor;
        cell.titile.textColor=self.leftSelectColor;
        cell.backgroundColor=self.leftSelectBgColor;
    }
    else{
        cell.titile.textColor=self.leftUnSelectColor;
        cell.backgroundColor=self.leftUnSelectBgColor;
        line.backgroundColor=_leftTablew.separatorColor;
    }
   

}

#pragma mark---左边的tablew 代理
#pragma mark--deleagte
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableData.count;
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * Identifier=@"MultilevelTableViewCell";
    MultilevelTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    if (!cell) {
        cell=[[NSBundle mainBundle] loadNibNamed:@"MultilevelTableViewCell" owner:self options:nil][0];
        
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(kLeftWidth-0.5, 0, 0.5, 44)];
        label.backgroundColor=tableView.separatorColor;
        [cell addSubview:label];
        label.tag=kCellRightLineTag;
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    rightMeun * title=self.tableData[indexPath.row];
    
    cell.titile.text=title.meunName;
    
    
    if (indexPath.row==self.selectIndex) {
        [self setLeftTablewCellSelected:YES withCell:cell];
    }
    else{
        [self setLeftTablewCellSelected:NO withCell:cell];

    }
    

    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins=UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset=UIEdgeInsetsZero;
    }
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MultilevelTableViewCell * cell=(MultilevelTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    MultilevelTableViewCell * BeforeCell=(MultilevelTableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]];
    [self setLeftTablewCellSelected:NO withCell:BeforeCell];
    _selectIndex=indexPath.row;
    [self setLeftTablewCellSelected:YES withCell:cell];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.isReturnLastOffset=NO;
    rightMeun * title=self.tableData[indexPath.row];
    [self.delegate multilvevlMenu:self tableSelectedWithTableView:tableView collectionView:self.rightCollection selectIndex:_selectIndex];
    _isRefreshData = YES;
    if (self.isRecordLastScroll) {
        [self.rightCollection scrollRectToVisible:CGRectMake(0, title.offsetScorller, self.rightCollection.frame.size.width, self.rightCollection.frame.size.height) animated:self.isRecordLastScrollAnimated];
    }
    else{
        
         [self.rightCollection scrollRectToVisible:CGRectMake(0, 0, self.rightCollection.frame.size.width, self.rightCollection.frame.size.height) animated:self.isRecordLastScrollAnimated];
    }
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MultilevelTableViewCell * cell=(MultilevelTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.titile.textColor=self.leftUnSelectColor;
    UILabel * line=(UILabel*)[cell viewWithTag:100];
    line.backgroundColor=tableView.separatorColor;
    [self setLeftTablewCellSelected:NO withCell:cell];
    cell.backgroundColor=self.leftUnSelectBgColor;
}

#pragma mark---imageCollectionView--------------------------

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(_isRefreshData){
        [self.collectionData removeAllObjects];
        [self.collectionData addObjectsFromArray: [self.delegate multilvevlMenu:self dataSourceWithRightCollection:collectionView]];
    }
    return self.collectionData == nil ? 0 : self.collectionData.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    rightMeun *title = self.collectionData[section];
    return title.nextArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    rightMeun * title=self.collectionData[indexPath.section];
    rightMeun * meun = title.nextArray[indexPath.row];
    [self.delegate multilvevlMenu:self collectionSelectedWithCollectionView:collectionView rightMeun:meun];
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MultilevelCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kMultilevelCollectionViewCell forIndexPath:indexPath];
    rightMeun * title=self.collectionData[indexPath.section];
    rightMeun * meun=title.nextArray[indexPath.row];
    cell.titile.text=meun.meunName;
    cell.backgroundColor=[UIColor clearColor];
    cell.imageView.backgroundColor=UIColorFromRGBValue(0xF8FCF8);
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:meun.urlName] placeholderImage:[UIImage imageNamed:kImageDefaultName]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = @"footer";
    }else{
        reuseIdentifier = kMultilevelCollectionHeader;
    }
    
    rightMeun * title=self.collectionData[indexPath.section];
    
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[view viewWithTag:1];
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=UIColorFromRGBValue(0x686868);
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        if (title.nextArray.count>0) {
            rightMeun * meun;
            meun=title.nextArray[indexPath.row];
            label.text=meun.meunName;
        }
        else{
            label.text=@"暂无";
        }
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        view.backgroundColor = [UIColor lightGrayColor];
        label.text = [NSString stringWithFormat:@"这是footer:%ld",(long)indexPath.section];
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(60, 90);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={kScreenWidth,44};
    return size;
}


#pragma mark---记录滑动的坐标
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    if ([scrollView isEqual:self.rightCollection]) {
//
//        
//        self.isReturnLastOffset=YES;
//    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if ([scrollView isEqual:self.rightCollection]) {
//        
//        rightMeun * title=self.tableData[self.selectIndex];
//        title.offsetScorller=scrollView.contentOffset.y;
//        self.isReturnLastOffset=NO;
//        
//    }

 }

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if ([scrollView isEqual:self.rightCollection]) {
//        
//        rightMeun * title=self.tableData[self.selectIndex];
//        title.offsetScorller=scrollView.contentOffset.y;
//        self.isReturnLastOffset=NO;
//    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    if ([scrollView isEqual:self.rightCollection] && self.isReturnLastOffset) {
//        rightMeun * title=self.tableData[self.selectIndex];
//        title.offsetScorller=scrollView.contentOffset.y;
//    }
}



#pragma mark--Tools
-(void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end



@implementation rightMeun



@end
