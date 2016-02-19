//
//  MDShopManageViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/17.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//


#import "MDShopManageViewController.h"
#import "MDShopManageDataController.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "MDAreaPickerView.h"
#import "PhotoTweaksViewController.h"
#import "MDUploadPicModel.h"

@interface  MDShopManageViewController()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoTweaksViewControllerDelegate,UIActionSheetDelegate>

@end

@implementation MDShopManageViewController{
    MDShopManageDataController *_dataController;
    MDAreaPickerView *areaPickerView;
    UIAlertController *_alertActionController;
    
    MDShopInformationModel *_mainModel;
    int _uploadTag;
}

#pragma mark life cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString* buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"从相机拍摄"]){
        [self alertPickerMessageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }else if([buttonTitle isEqualToString:@"从相册选择"]){
        [self alertPickerMessageWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString*,id>*)info{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *image = (UIImage*)info[UIImagePickerControllerOriginalImage];
    PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image touches:NO cropSize:CGSizeMake(200, 200)];
    photoTweaksViewController.delegate = self;
    [self presentViewController:photoTweaksViewController animated:YES completion:nil];
}

#pragma mark PhotoTweaksViewControllerDelegate
-(void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage{
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self.progressView show];
    __weak typeof(self) weakSelf = self;
    [_dataController uploadImageWithImage:[MDCommon scaleToSize:croppedImage size:CGSizeMake(640, 200)] userId:APPDATA.userId token:APPDATA.token completion:^(BOOL state, NSString * _Nullable msg, MDUploadPicModel * _Nullable model) {
        [weakSelf.progressView hide];
        if(state){
            UIButton *button = [weakSelf.view viewWithTag:_uploadTag];
            [button sd_setImageWithURL:[NSURL URLWithString:model.absoluteUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"camera"]];
            if(_uploadTag == 1000){
                _mainModel.shopNavigationPic = model.relativeUrl;
            }else if(_uploadTag == 1002){
                _mainModel.shopLogo = model.relativeUrl;
            }
            [weakSelf showAlertDialog:@"上传成功"];
        }else{
            [weakSelf showAlertDialog:@"上传失败"];
        }
    }];
}

-(void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark action methods
/**
 *  返回上一个界面
 */
-(void)backTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  上传图片点击触发事件
 */
-(void)uploadTapped:(UIButton*)button{
    _uploadTag = (int)button.tag;
    [self showAlertActionMessageForPhoto];
}

/**
 *  地区点击触发事件
 */
-(void)areaTapped{
    
    UIButton *_districtLabel = (UIButton*)[self.view viewWithTag:1003];
    NSArray *array = [_districtLabel.titleLabel.text componentsSeparatedByString:@" "];
    NSString *p = array.count >= 1 ? array[0] : @"";
    NSString *c = array.count >= 2 ? array[1] : @"";
    NSString *d = array.count >= 3 ? array[2] : @"";
    __weak typeof(self) weakSelf = self;
    areaPickerView = [[MDAreaPickerView alloc] initWithProvince:p city:c district:d confirmBlock:^(NSString* province,NSString* city,NSString* district){
        NSString *area = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
        [_dataController submitMemberAreaDataWithUserId:APPDATA.userId token:APPDATA.token province:province city:city district:district completion:^(BOOL state, NSString * _Nullable msg) {
            if(state){
                [weakSelf showAlertDialog:@"修改成功"];
                [_districtLabel setTitle:area forState:UIControlStateNormal];
            }else{
                [weakSelf showAlertDialog:@"修改失败"];
            }
        }];
        areaPickerView = nil;
    } cancelBlock:^{
        areaPickerView = nil;
    }];
    [areaPickerView showInView:self.view];
}

-(void)submitTap{
    
    UITextField *textField = [self.view viewWithTag:1001];
    _mainModel.shopName = textField.text;
    
    UIButton *button = [self.view viewWithTag:1003];
    _mainModel.address = button.titleLabel.text;
    
    textField = [self.view viewWithTag:1004];
    _mainModel.street = textField.text;
    
    textField = [self.view viewWithTag:1005];
    _mainModel.serviceQq = textField.text;
    
    textField = [self.view viewWithTag:1006];
    _mainModel.serviceTel = textField.text;
    
    textField = [self.view viewWithTag:1007];
    _mainModel.businessHours = textField.text;
    
    [_dataController submitShopInformationDataWithUserId:APPDATA.userId token:APPDATA.token shopNavigationPic:_mainModel.shopNavigationPic shopLogo:_mainModel.shopLogo shopName:_mainModel.shopName businessHours:_mainModel.businessHours serviceQq:_mainModel.serviceQq serviceTel:_mainModel.serviceTel street:_mainModel.street isModified:1 area:_mainModel.address completion:^(BOOL state, NSString * _Nullable msg) {
        if(state){
            
        }else{
            
        }
    }];
}

#pragma mark event methods

#pragma mark private methods

-(void)initData{
    _dataController = [[MDShopManageDataController alloc] init];
}

/**
 *  初始化界面
 */
-(void)initView{
    [self.navigationItem setTitle:@"店铺管理"];
    //[MDCommon navigateBackButtonWithNavigateItem:self.navigationItem target:self action:@selector(backTapped)];
    
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    UIView *scrollContentView = [[UIView alloc] init];
    [scrollView addSubview:scrollContentView];
    [scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView).with.insets(UIEdgeInsetsMake(10, 0, 0, 0));
        make.width.equalTo(scrollView.mas_width);//必须要加
    }];
    
    //  添加店铺banner
    UIButton *bannerButton = [[UIButton alloc] init];
    [bannerButton setTag:1000];
    [bannerButton setContentMode:UIViewContentModeScaleAspectFit];
    [bannerButton addTarget:self action:@selector(uploadTapped:) forControlEvents:UIControlEventTouchDown];
    [scrollContentView addSubview:bannerButton];
    
    [bannerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollContentView.mas_top).with.offset(64);
        make.left.equalTo(scrollContentView.mas_left).with.offset(0);
        make.right.equalTo(scrollContentView.mas_right).with.offset(0);
        make.height.mas_equalTo(80);
    }];
    
    
    
    int tag = 1001;
    UIView *view = [self createNameToInputForViewWithSuperView:scrollContentView tag:tag++ topView:bannerButton name:@"店铺名称：" placeholder:@"编辑店铺名称"];
    view = [self createNameToUploadForViewWithSuperView:scrollContentView tag:tag++  topView:view name:@"店铺logo：" placeholder:@"点击右侧上传添加logo" icon:@"camera" action:@selector(uploadTapped:)];
    view = [self createNameToTappedForViewWithSuperView:scrollContentView tag:tag++  topView:view name:@"店铺区域：" value:@"广东省 中山市 西区" action:@selector(areaTapped)];
    view = [self createNameToInputForViewWithSuperView:scrollContentView tag:tag++  topView:view name:@"详细地址：" placeholder:@"请输入店铺的详细地址"];
    view = [self createNameToInputForViewWithSuperView:scrollContentView tag:tag++  topView:view name:@"客服QQ：" placeholder:@"请输入联系客服qq号"];
    view = [self createNameToInputForViewWithSuperView:scrollContentView tag:tag++ topView:view name:@"客服电话：" placeholder:@"请输入联系客服电话"];
    view = [self createNameToInputForViewWithSuperView:scrollContentView tag:tag++  topView:view name:@"营业时间：" placeholder:@"请输入营业时间，如9:00-21:00"];
    view = [self createButtonForViewWithSuperView:scrollContentView topView:view name:@"提交" action:@selector(submitTap)];
    [scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom);
    }];
}

/**
 *  创建一个包含一个标题显示UILabel、一个文本输入框UITextField的UIView控件
 *
 *  @param superView   父级控件
 *  @param tag         输入框的tag值
 *  @param view        上一个控件
 *  @param name        标题控件显示的内容
 *  @param placeholder 文本输入框显示的提示内容
 *
 *  @return UIView
 */
-(UIView*)createNameToInputForViewWithSuperView:(UIView*)superView tag:(int)tag topView:(UIView*)view name:(NSString*)name placeholder:(NSString*)placeholder{
    UIView *nameView = [[UIView alloc] init];
    [nameView.layer setBorderWidth:0.25];
    [nameView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [superView addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).with.offset(0);
        make.left.equalTo(superView.mas_left).with.offset(-0.5);
        make.right.equalTo(superView.mas_right).with.offset(0.5);
        make.height.mas_equalTo(50);
    }];
    UILabel *nameTipLabel = [[UILabel alloc] init];
    [nameTipLabel setText:name];
    [nameTipLabel setFont:[UIFont systemFontOfSize:14]];
    [nameView addSubview:nameTipLabel];
    [nameTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameView.mas_left).with.offset(8);
        make.centerY.equalTo(nameView);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    UITextField *nameTextField = [[UITextField alloc] init];
    [nameTextField setTag:tag];
    [nameTextField setFont:[UIFont systemFontOfSize:14]];
    [nameTextField setPlaceholder:placeholder];
    [nameView addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameTipLabel.mas_right).with.offset(8);
        make.right.equalTo(nameView.mas_right).with.offset(-8);
        make.centerY.equalTo(nameView);
        make.height.mas_equalTo(30);
    }];
    return nameView;
}

/**
 *  创建一个包含一个标题显示UILabel、一个提示UILabel、一个显示图片、点击触发action事件的UIButton的UIView控件
 *
 *  @param superView   父级控件
 *  @param tag         button的tag值
 *  @param view        上一个控件对象
 *  @param name        标题显示内容
 *  @param placeholder 提示UILabel的text
 *  @param iconPath    button的image内容
 *  @param action      action事件
 *
 *  @return UIView
 */
-(UIView*)createNameToUploadForViewWithSuperView:(UIView*)superView tag:(int)tag topView:(UIView*)view name:(NSString*)name placeholder:(NSString*)placeholder icon:(NSString*)iconPath action:(SEL)action{
    UIView *nameView = [[UIView alloc] init];
    [nameView.layer setBorderWidth:0.25];
    [nameView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [superView addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).with.offset(0);
        make.left.equalTo(superView.mas_left).with.offset(-0.5);
        make.right.equalTo(superView.mas_right).with.offset(0.5);
        make.height.mas_equalTo(50);
    }];
    UILabel *nameTipLabel = [[UILabel alloc] init];
    [nameTipLabel setText:name];
    [nameTipLabel setFont:[UIFont systemFontOfSize:14]];
    [nameView addSubview:nameTipLabel];
    [nameTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameView.mas_left).with.offset(8);
        make.centerY.equalTo(nameView);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    
    UIButton  *uploadButton = [[UIButton alloc] init];
    [uploadButton setTag: tag];
    [uploadButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [uploadButton addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    [nameView addSubview:uploadButton];
    [uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nameView.mas_right).with.offset(-8);
        make.centerY.equalTo(nameView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UILabel *namePlaceholderLabel = [[UILabel alloc] init];
    [namePlaceholderLabel setText:placeholder];
    [namePlaceholderLabel setFont:[UIFont systemFontOfSize:14]];
    [namePlaceholderLabel setTextColor:[UIColor grayColor]];
    [nameView addSubview:namePlaceholderLabel];
    [namePlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameTipLabel.mas_right).with.offset(8);
        make.right.equalTo(uploadButton.mas_left).with.offset(8);
        make.centerY.equalTo(nameView);
    }];
    return nameView;
}

/**
 *  创建一个包含一个标题显示的UILabel、一个显示内容、点击触发action事件的UIButton的UIView控件
 *
 *  @param superView 父级控件
 *  @param tag       button的tag值
 *  @param view      上一个控件
 *  @param name      标题显示的内容
 *  @param value     button显示的文本内容
 *  @param action    button点击触发的action事件
 *
 *  @return UIView控件
 */
-(UIView*)createNameToTappedForViewWithSuperView:(UIView*)superView tag:(int)tag topView:(UIView*)view name:(NSString*)name value:(NSString*)value action:(SEL)action{
    UIView *nameView = [[UIView alloc] init];
    [nameView.layer setBorderWidth:0.25];
    [nameView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [superView addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).with.offset(0);
        make.left.equalTo(superView.mas_left).with.offset(-0.5);
        make.right.equalTo(superView.mas_right).with.offset(0.5);
        make.height.mas_equalTo(50);
    }];
    UILabel *nameTipLabel = [[UILabel alloc] init];
    [nameTipLabel setText:name];
    [nameTipLabel setFont:[UIFont systemFontOfSize:14]];
    [nameView addSubview:nameTipLabel];
    [nameTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameView.mas_left).with.offset(8);
        make.centerY.equalTo(nameView);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    
    UIButton  *button = [[UIButton alloc] init];
    [button setTag:tag];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setTitle:value forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    [nameView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameTipLabel.mas_right).with.offset(8);
        make.right.equalTo(nameView.mas_right).with.offset(-8);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(nameView);
    }];
    return nameView;
}

/**
 *  创建一个包含一个显示内容、点击触发action事件的UIButton的UIView控件
 *
 *  @param superView 父级控件
 *  @param view      上一个控件对象
 *  @param name      button显示的文本内容
 *  @param action    button点击触发的action事件
 *
 *  @return UIView控件对象
 */
-(UIView*)createButtonForViewWithSuperView:(UIView*)superView topView:(UIView*)view name:(NSString*)name action:(SEL)action{
    UIView *nameView = [[UIView alloc] init];
    [nameView.layer setBorderWidth:0.25];
    [nameView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [superView addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).with.offset(0);
        make.left.equalTo(superView.mas_left).with.offset(-0.5);
        make.right.equalTo(superView.mas_right).with.offset(0.5);
        make.height.mas_equalTo(50);
    }];
    
    UIButton  *button = [[UIButton alloc] init];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    [nameView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameView.mas_left).with.offset(8);
        make.right.equalTo(nameView.mas_right).with.offset(-8);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(nameView);
    }];
    return nameView;
}

/**
 *  根据图片来源类型显示相关的选择图片视图
 *
 *  @param sourceType 来源类型  相册选择和相机拍摄
 */
-(void)alertPickerMessageWithSourceType:(int)sourceType{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)showAlertActionMessageForPhoto{
    if(__IPHONE_SYSTEM_VERSION >= 8.0){
        _alertActionController = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [_alertActionController addAction:[UIAlertAction actionWithTitle:@"从相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
            [self alertPickerMessageWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }]];
        [_alertActionController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
            [self alertPickerMessageWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }]];
        [_alertActionController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:_alertActionController animated:YES completion:nil];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相机拍摄",@"从相册选择", nil];
        [actionSheet showInView:self.view];
    }
}


@end
