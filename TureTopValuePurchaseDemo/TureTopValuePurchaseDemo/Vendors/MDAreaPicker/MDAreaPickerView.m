//
//  MDAreaPickerView.m
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/11/4.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import "MDAreaPickerView.h"
@interface MDAreaPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong) NSString *province;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *district;
@property(nonatomic,copy)  void (^confirmBlock)(NSString* province,NSString* city,NSString* district);
@property(nonatomic,copy)  void (^cancelBlock)();
@end

@implementation MDAreaPickerView{
    NSMutableArray *provinces;
    NSMutableArray *cities;
    NSMutableArray *districts;
    UIPickerView *mainPickerView;
    
    int provinceIndex;
    int cityIndex;
    int districtIndex;
}

-(id)initWithProvince:(NSString*)province city:(NSString*)city district:(NSString*)district confirmBlock:(void(^)(NSString*,NSString*,NSString*))confirmBlock cancelBlock:(void(^)())cancelBlock{
    if(self = [super initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)]){
        _province = province;
        _city = city;
        _district = district;
        _confirmBlock = confirmBlock;
        _cancelBlock = cancelBlock;
        
        NSDictionary *dic = [MDCommon readDataForJsonFileWithPath:@"chinaRegion.json"];
        provinces = dic[@"province"];
        
        if([_province isEqualToString:@""]){
            cities = [[provinces objectAtIndex:0] objectForKey:@"city"];
            districts = [[cities objectAtIndex:0] objectForKey:@"district"];
            _province = [[provinces objectAtIndex:0] objectForKey:@"name"];
            _city = [[cities objectAtIndex:0] objectForKey:@"name"];
            if (districts.count > 0) {
                _district = [districts objectAtIndex:0];
            } else{
                _district = @"";
            }
        }
        [self initData];
        [self initView];
    }
    return self;
}

#pragma mark UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            return [districts count];
            break;
    }
    return 0;
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    return 5;
//}

#pragma mark UIPickerViewDataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[provinces objectAtIndex:row] objectForKey:@"name"];
            break;
        case 1:
            return [[cities objectAtIndex:row] objectForKey:@"name"];
            break;
        case 2:
            if ([districts count] > 0) {
                return [districts objectAtIndex:row];
                break;
            }
        default:
            return  @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            cities = [[provinces objectAtIndex:row] objectForKey:@"city"];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:1];
            
            districts = [[cities objectAtIndex:0] objectForKey:@"district"];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            
            _province = [[provinces objectAtIndex:row] objectForKey:@"name"];
            _city = [[cities objectAtIndex:0] objectForKey:@"name"];
            if ([districts count] > 0) {
                _district = [[districts objectAtIndex:0] objectForKey:@"name"];
            } else{
                _district = @"";
            }
            break;
        case 1:
            districts = [[cities objectAtIndex:row] objectForKey:@"district"];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            
            _city = [[cities objectAtIndex:row] objectForKey:@"name"];
            if ([districts count] > 0) {
                _district = [[districts objectAtIndex:0] objectForKey:@"name"];
            } else{
                _district = @"";
            }
            break;
        case 2:
            if ([districts count] > 0) {
                _district = [[districts objectAtIndex:row] objectForKey:@"name"];
            } else{
                _district = @"";
            }
            break;
        default:
            break;
    }
    
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(!view){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 20)];
    }
    NSString *title = @"";
    switch (component) {
        case 0:
            title = [[provinces objectAtIndex:row] objectForKey:@"name"];
            break;
        case 1:
            title = [[cities objectAtIndex:row] objectForKey:@"name"];
            break;
        case 2:
            if ([districts count] > 0) title = [[districts objectAtIndex:row] objectForKey:@"name"];
            break;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:[UIColor blackColor]];
    [label setText:title];
    [label setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:label];
    return view;
}


#pragma mark - animation

- (void)showInView:(UIView *) view
{
    [self setBackgroundColor:UIColorFromRGBA(0, 0, 0, 0.5)];
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [APPDELEGATE.window addSubview:self];
    [APPDELEGATE.window bringSubviewToFront:self];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)]];
    [UIView animateWithDuration:0 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    [self initSelected];
}

-(void)confirmPicker{
    _confirmBlock(_province,_city,_district);
    [self hideView];
}

- (void)hideView
{
    UIView *view = [self viewWithTag:1001];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self setBackgroundColor:UIColorFromRGBA(0, 0, 0, 0)];
                         view.frame = CGRectMake(0, view.frame.origin.y+view.frame.size.height, view.frame.size.width, view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}


-(void)initView{
    
    UIView *view = [[UIView alloc] init];
    [view setTag:1001];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 200));
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    UILabel *separateLabel = [[UILabel alloc] init];
    separateLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    separateLabel.layer.borderWidth = 0.5f;
    [self addSubview:separateLabel];
    [separateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        make.left.equalTo(view.mas_left).with.offset(0);
        make.top.equalTo(view.mas_top).with.offset(0);
    }];
    
    UIView *btnGroupView = [[UIView alloc] init];
    //[view setBackgroundColor:[UIColor blackColor]];
    [view addSubview:btnGroupView];
    [btnGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateLabel.mas_bottom).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
        make.left.equalTo(view.mas_left).with.offset(0);
    }];
    
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchDown];
    [btnGroupView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnGroupView);
        make.left.equalTo(btnGroupView.mas_left).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    
    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmPicker) forControlEvents:UIControlEventTouchDown];
    [btnGroupView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnGroupView);
        make.right.equalTo(btnGroupView.mas_right).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(50, 30));
        
    }];
    
    mainPickerView = [[UIPickerView alloc] init];
    mainPickerView.delegate = self;
    mainPickerView.dataSource = self;
    [view addSubview:mainPickerView];
    [mainPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnGroupView.mas_bottom).with.offset(0);
        make.left.equalTo(view.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 170));
    }];
}

-(void)initData{
    int index = 0;
    for (NSDictionary * dic in provinces) {
        if([dic[@"name"] extensionWithContainsString:_province]) break;
        index ++;
    }
    provinceIndex = index;
    cities = [[provinces objectAtIndex:index] objectForKey:@"city"];
    index = 0;
    for (NSDictionary * dic in cities) {
        if([dic[@"name"] extensionWithContainsString:_city]) break;
        index ++;
    }
    cityIndex = index;
    districts = [[cities objectAtIndex:index] objectForKey:@"district"];
    index = 0;
    for (NSDictionary * dic in districts) {
        if([dic[@"name"] extensionWithContainsString:_district]) break;
        index ++;
    }
    districtIndex = index;
    
}

-(void)initSelected{
//    int index = 0;
//    for (NSDictionary * dic in provinces) {
//        if([dic[@"name"] isEqualToString:_province]) break;
//        index ++;
//    }
//    if(index >= provinces.count) return;
//    [mainPickerView selectRow:index inComponent:0 animated:YES];
//    [mainPickerView reloadComponent:0];
//    
//    cities = [[provinces objectAtIndex:index] objectForKey:@"city"];
//    index = 0;
//    for (NSDictionary * dic in cities) {
//        if([dic[@"name"] isEqualToString:_city]) break;
//        index ++;
//    }
//    if(index >= cities.count) return;
//    [mainPickerView selectRow:index inComponent:1 animated:YES];
//    [mainPickerView reloadComponent:1];
//    
//    districts = [[cities objectAtIndex:index] objectForKey:@"district"];
//    index = 0;
//    for (NSDictionary * dic in districts) {
//        if([dic[@"name"] isEqualToString:_district]) break;
//        index ++;
//    }
//    if(index >= districts.count) return;
//    [mainPickerView selectRow:index inComponent:2 animated:YES];
//    [mainPickerView reloadComponent:2];
    if(provinceIndex >= provinces.count) return;
    [mainPickerView selectRow:provinceIndex inComponent:0 animated:YES];
    [mainPickerView reloadComponent:0];
    
    if(cityIndex >= cities.count) return;
    [mainPickerView selectRow:cityIndex inComponent:1 animated:YES];
    [mainPickerView reloadComponent:1];
    
    if(districtIndex >= districts.count) return;
    [mainPickerView selectRow:districtIndex inComponent:2 animated:YES];
    [mainPickerView reloadComponent:2];
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture

{
    [self hideView];
}
@end
