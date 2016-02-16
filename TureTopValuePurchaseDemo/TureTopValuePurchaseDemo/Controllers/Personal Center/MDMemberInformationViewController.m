//
//  MDMemberInformationViewController.m
//  TureTopValuePurchaseDemo
//
//  Created by 李晓毅 on 16/2/15.
//  Copyright © 2016年 铭道超值购. All rights reserved.
//

#import "MDMemberInformationViewController.h"
#import "MDMemberDataController.h"
#import "MDMemberNormalTableViewCell.h"
#import "MDMemberAvatarTableViewCell.h"

#import "MDAreaPickerView.h"
#import "PhotoTweaksViewController.h"

@interface MDMemberInformationViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoTweaksViewControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@end

@implementation MDMemberInformationViewController{
    UITableView *_mainTableView;
    MDMemberDataController *_dataController;
    UIAlertController *_alertTextController;
    UIAlertController *_alertActionController;
    MDAreaPickerView *_areaPickerView;
    
    MDMemberInfomationModel *_memberInformationModel;
    
    int _alertType;
    NSString *_alertTitle;
    NSString *_alertContent;
    NSString *_alertTextPlaceholder;
    int _userId;
    
}

#pragma mark life cycle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        UITextField *textField = [alertView textFieldAtIndex:0];
        [self alterInformationWithTextField:textField];
    }
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString* buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"男"]){
        [self submitDataWtihName:@"sex" value:@"0" success:^{
            _memberInformationModel.sex = 0;
        }];
    }else if([buttonTitle isEqualToString:@"女"]){
        [self submitDataWtihName:@"sex" value:@"1" success:^{
            _memberInformationModel.sex = 1;
        }];
    }else if([buttonTitle isEqualToString:@"从相机拍摄"]){
        [self alertPickerMessageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }else if([buttonTitle isEqualToString:@"从相册选择"]){
        [self alertPickerMessageWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            [self baseInformationSelectedEventWithRow:indexPath.row];
            break;
        case 1:
            [MDCommon reshipWebURLWithNavigationController:self.navigationController pageType:MDWebPageURLTypeReceiveAddress title:@"收货地址" parameters:@{} isNeedLogin:YES loginTipBlock:nil];
            break;
        case 2:
            [self expandInformationSelectedEventWithRow:indexPath.row];
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0) return 0.001;
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 && indexPath.row == 0 ? 100 : 40;
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 6 : (section == 1 ? 1 : 2);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if(indexPath.section == 0 && indexPath.row == 0){
        static NSString *avatarCellIdenfitier = @"AvatarCell";
        cell = [tableView dequeueReusableCellWithIdentifier:avatarCellIdenfitier];
        if(cell == nil){
            cell = [[MDMemberAvatarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:avatarCellIdenfitier];
        }
    }else if(indexPath.section == 0 && indexPath.row == 1){
        static NSString *fixedCellIdentifier = @"FixedCell";
        cell = [tableView dequeueReusableCellWithIdentifier:fixedCellIdentifier];
        if(cell == nil){
            cell = [[MDMemberNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:fixedCellIdentifier];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [((MDMemberNormalTableViewCell*)cell).detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).with.offset(-30);
            }];
        }
    }else{
        static NSString *normalCellIdenfitier = @"NormalCell";
        cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdenfitier];
        if(cell == nil){
            cell = [[MDMemberNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCellIdenfitier];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    MDMemberNormalTableViewCell *normalCell = (MDMemberNormalTableViewCell*)cell;
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                MDMemberAvatarTableViewCell *avatarCell = (MDMemberAvatarTableViewCell*)cell;
                [avatarCell.textLabel setText:@"头像"];
                if(_memberInformationModel && ![_memberInformationModel.headPortrait isEqualToString:@""]) [avatarCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_memberInformationModel.headPortrait] placeholderImage:[UIImage imageNamed:@"activity_main_mylinli_bannerhead"]];
            }
                break;
            case 1:
                [cell.textLabel setText:@"手机"];
                if(_memberInformationModel && _memberInformationModel.phone && ![_memberInformationModel.phone isEqualToString:@""]){
                    [normalCell.detailLabel setText:_memberInformationModel.phone];
                }
                break;
            case 2:
                [normalCell.textLabel setText:@"昵称"];
                if(_memberInformationModel && _memberInformationModel.nickName && ![_memberInformationModel.nickName isEqualToString:@""]){
                    [normalCell.detailLabel setText:_memberInformationModel.nickName];
                }
                break;
            case 3:
                [normalCell.textLabel setText:@"真实姓名"];
                if(_memberInformationModel && _memberInformationModel.realname && ![_memberInformationModel.realname isEqualToString:@""]){
                    [normalCell.detailLabel setText:_memberInformationModel.realname];
                }
                break;
            case 4:
                [normalCell.textLabel setText:@"邮箱"];
                if(_memberInformationModel && _memberInformationModel.email && ![_memberInformationModel.email isEqualToString:@""]){
                    [normalCell.detailLabel setText:_memberInformationModel.email];
                }
                break;
            case 5:
                [normalCell.textLabel setText:@"固定号码"];
                if(_memberInformationModel && _memberInformationModel.tel && ![_memberInformationModel.tel isEqualToString:@""]){
                    [normalCell.detailLabel setText:_memberInformationModel.tel];
                }
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                [cell.textLabel setText:@"收货地址"];
                break;
        }
    }else if(indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
                [normalCell.textLabel setText:@"性别"];
                [normalCell.detailLabel setText:[MDCommon sexTextWithValue:_memberInformationModel.sex]];
                break;
            case 1:
                [normalCell.textLabel setText:@"地区"];
                if(_memberInformationModel && _memberInformationModel.area && ![_memberInformationModel.area isEqualToString:@""]){
                    [normalCell.detailLabel setText:_memberInformationModel.area];
                }
                break;
        }
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [((RDVTabBarController*)APPDELEGATE.window.rootViewController) setTabBarHidden:NO];
    [picker dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark PhotoTweaksViewControllerDelegate
-(void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage{
    [controller dismissViewControllerAnimated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [_dataController uploadImageWithImage:[MDCommon scaleToSize:croppedImage size:CGSizeMake(200, 200)] userId:APPDATA.userId token:APPDATA.token name:@"headPic" completion:^(BOOL state, NSString * _Nullable msg, MDUploadPicModel * _Nullable model) {
        if(state){
            [weakSelf showAlertDialog:@"修改成功"];
            _memberInformationModel.headPortrait = model.relativeUrl;
            [_mainTableView reloadData];
        }else{
            [weakSelf showAlertDialog:@"修改失败"];
        }
    }];
}
-(void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark event methods
/**
 *  返回上一个界面
 */
-(void)backTapped{
    if(_areaPickerView != nil){
        [_areaPickerView hideView];
        _areaPickerView = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshData{
    [_dataController requestDataWithUserId:APPDATA.userId token:APPDATA.token completion:^(BOOL state, NSString *msg, MDMemberInfomationModel *model) {
        _memberInformationModel = model;
        [_mainTableView reloadData];
    }];
}

#pragma mark private methods
-(void)initData{
    _dataController = [[MDMemberDataController alloc] init];
    
}
/**
 *  初始化界面
 */
-(void)initView{
    [self.navigationItem setTitle:@"个人信息"];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_mainTableView setDataSource:self];
    [_mainTableView setDelegate:self];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    [self refreshData];
}
/**
 *  基本信息设置，头像独立上传请求，其他的都是固定key-value上传
 *
 *  @param row tableview的行数
 */
-(void)baseInformationSelectedEventWithRow:(NSInteger)row{
    if(row == 0){
        _alertType = 0;
        _alertTitle = @"选择头像";
        _alertContent = @"头像";
        
    }else if(row == 1){
        return;
    }else if(row == 2){
        _alertType = 2;
        _alertTitle = @"编辑昵称";
        _alertContent = @"不能少于2个且多于20个中文或字母";
        _alertTextPlaceholder =@"昵称";
        
    }else if(row == 3){
        _alertType = 3;
        _alertTitle = @"编辑真实姓名";
        _alertContent = @"真实姓名不能少于2个中文";
        _alertTextPlaceholder =@"真实姓名";
        
    }else if(row == 4){
        _alertType = 4;
        _alertTitle = @"编辑邮箱";
        _alertContent = @"(例如：xxxx@explame.com)";
        _alertTextPlaceholder =@"邮箱";
        
    }else if(row == 5){
        _alertType = 5;
        _alertTitle = @"编辑电话号码";
        _alertContent = @"中国大陆的固定电话号码";
        _alertTextPlaceholder =@"电话号码";
        
    }
    if(_alertType == 0) {
        [self showAlertActionMessageForPhoto];
        return;
    }
    [self alertTextInputMessage];
}
/**
 *  点击tableview的第三分组的行触发
 *
 *  @param row 行数
 */
-(void)expandInformationSelectedEventWithRow:(NSInteger)row{
    if(row == 0){//性别
        [self showAlertActionMessageForSex];
    }else if(row == 1){//地区
        _alertType = 7;
        _alertTitle = @"编辑地区";
        _alertContent = @"";
        NSArray *array = [_memberInformationModel.area componentsSeparatedByString:@" "];
        NSString *p = array.count >= 1 ? array[0] : @"";
        NSString *c = array.count >= 2 ? array[1] : @"";
        NSString *d = array.count >= 3 ? array[2] : @"";
        __weak typeof(self) weakSelf = self;
        _areaPickerView = [[MDAreaPickerView alloc] initWithProvince:p city:c district:d confirmBlock:^(NSString* province,NSString* city,NSString* district){
            NSString *area = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
            [_dataController submitMemberAreaDataWithUserId:APPDATA.userId token:APPDATA.token province:province city:city district:district completion:^(BOOL state, NSString * _Nullable msg) {
                if(state){
                    [weakSelf showAlertDialog:@"修改成功"];
                    _memberInformationModel.area = area;
                    [_mainTableView reloadData];
                }else{
                    [weakSelf showAlertDialog:@"修改失败"];
                }
            }];
            _areaPickerView = nil;
        } cancelBlock:^{
            _areaPickerView = nil;
        }];
        [_areaPickerView showInView:self.view];
    }
    
}
/**
 *  弹出文本输入框类型的消息框
 */
-(void)alertTextInputMessage{
    NSString* defaultValue = @"";
    switch (_alertType) {
        case 2:
            defaultValue = _memberInformationModel.nickName;
            break;
        case 3:
            defaultValue = _memberInformationModel.realname;
            break;
        case 4:
            defaultValue = _memberInformationModel.email;
            break;
        case 5:
            defaultValue = _memberInformationModel.tel;
            break;
    }
    [self showAlertTextMessageWithTitle:_alertTitle message:_alertContent textFieldWithConfigurationHandler:^(UITextField * __nonnull textField) {
        textField.text = defaultValue;
        textField.placeholder = _alertTextPlaceholder;
    }];
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

-(void)alterInformationWithTextField:(UITextField*)textField{
    NSString *name = @"";
    switch (_alertType) {
        case 2:
            name = @"nickName";
            break;
        case 3:
            name = @"realName";
            break;
        case 4:
            name = @"email";
            break;
        case 5:
            name = @"tel";
            break;
    }
    [self submitDataWtihName:name value:textField.text success:^{
        switch (_alertType) {
            case 2:
                _memberInformationModel.nickName = textField.text;
                break;
            case 3:
                _memberInformationModel.realname = textField.text;
                break;
            case 4:
                _memberInformationModel.email = textField.text;
                break;
            case 5:
                _memberInformationModel.tel = textField.text;
                break;
        }
        [_mainTableView reloadData];
    }];
}

/**
 *  post请求提交数据到服务器
 *
 *  @param name    参数名
 *  @param value   参数值
 *  @param success 成功回调函数
 */
-(void)submitDataWtihName:(NSString*)name value:(NSString*)value success:(void(^)())success{
    __weak typeof(self) weakSelf = self;
    [_dataController submitMemberInformationDataWithUserId:APPDATA.userId token:APPDATA.token name:name value:value completion:^(BOOL state, NSString * _Nullable msg) {
        if(state){
            if(success) success();
            [weakSelf showAlertDialog:@"修改成功"];
        }else{
            [weakSelf showAlertDialog:@"修改失败"];
        }
    }];
}

-(void)showAlertTextMessageWithTitle:(NSString*)title message:(NSString*)message textFieldWithConfigurationHandler:(void(^)(UITextField * __nonnull textField))textFieldWithConfigurationHandler{
    if(__IPHONE_SYSTEM_VERSION >= 8.0){
        _alertTextController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [_alertTextController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [_alertTextController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
            UITextField *textField = _alertTextController.textFields.firstObject;
            [self alterInformationWithTextField:textField];
        }]];
        [_alertTextController addTextFieldWithConfigurationHandler:textFieldWithConfigurationHandler];
        [self presentViewController:_alertTextController animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *textField = [alertView textFieldAtIndex:0];
        textFieldWithConfigurationHandler(textField);
        [alertView show];
    }
}

-(void)showAlertActionMessageForSex{
    if(__IPHONE_SYSTEM_VERSION >= 8.0){
        _alertActionController = [UIAlertController alertControllerWithTitle:@"编辑性别" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [_alertActionController addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
            [self submitDataWtihName:@"sex" value:@"0" success:^{
                _memberInformationModel.sex = 0;
                [_mainTableView reloadData];
            }];
        }]];
        [_alertActionController addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
            [self submitDataWtihName:@"sex" value:@"1" success:^{
                _memberInformationModel.sex = 1;
                [_mainTableView reloadData];
            }];
        }]];
        [_alertActionController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
            
        }]];
        [self presentViewController:_alertActionController animated:YES completion:nil];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"编辑性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [actionSheet showInView:self.view];
    }
}

-(void)showAlertActionMessageForPhoto{
    if(__IPHONE_SYSTEM_VERSION >= 8.0){
        _alertActionController = [UIAlertController alertControllerWithTitle:_alertTitle message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [_alertActionController addAction:[UIAlertAction actionWithTitle:@"从相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
            [self alertPickerMessageWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }]];
        [_alertActionController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * __nonnull action) {
            [self alertPickerMessageWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }]];
        [_alertActionController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:_alertActionController animated:YES completion:nil];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:_alertTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相机拍摄",@"从相册选择", nil];
        [actionSheet showInView:self.view];
    }
}

@end
