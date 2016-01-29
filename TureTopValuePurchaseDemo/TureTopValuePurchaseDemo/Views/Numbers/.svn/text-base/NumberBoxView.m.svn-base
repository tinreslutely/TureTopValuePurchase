//
//  NumberBoxView.m
//  MicroValuePurchase
//
//  Created by 李晓毅 on 15/12/3.
//  Copyright © 2015年 TureTop. All rights reserved.
//

#import "NumberBoxView.h"

@interface NumberBoxView()<UITextFieldDelegate>

@end

@implementation NumberBoxView{
    UITextField *_textField;
    UIButton *_reduceButton;
    UIButton *_addButton;
    
    int _maxValue;
    int _minValue;
}


-(id)initWithFrame:(CGRect)frame maxValue:(int)maxValue minValue:(int)minValue{
    if(self = [super initWithFrame:frame]){
        _maxValue = maxValue;
        _minValue = minValue;
        [self initView];
    }
    return self;
}

#pragma mark action methods
-(void)addTapped{
    [_textField resignFirstResponder];
    int num = [_textField.text intValue];
    num ++;
    if(num > _maxValue) return;
    [_textField setText:[NSString stringWithFormat:@"%d",num]];
    if([self.delegate respondsToSelector:@selector(numberBoxView:shouldValueChangedInNumber:)]){
        [self.delegate numberBoxView:self shouldValueChangedInNumber:num];
    }
}

-(void)reduceTapped{
    [_textField resignFirstResponder];
    int num = [_textField.text intValue];
    num --;
    if(num < _minValue) return;
    [_textField setText:[NSString stringWithFormat:@"%d",num]];
    if([self.delegate respondsToSelector:@selector(numberBoxView:shouldValueChangedInNumber:)]){
        [self.delegate numberBoxView:self shouldValueChangedInNumber:num];
    }
    
}


#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]{0,1}$"] evaluateWithObject:string]) {
        return NO;
    }
    if(range.location >= 4) return NO;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField.text intValue] <= 0){
        [textField setText:@"1"];
    }
    if([self.delegate respondsToSelector:@selector(numberBoxView:shouldValueChangedInNumber:)]){
        [self.delegate numberBoxView:self shouldValueChangedInNumber:[_textField.text intValue]];
    }
}


#pragma mark private methods
-(void)initView{
    int width = self.frame.size.width/3;
    int pre = width/5;
    [self.layer setBorderWidth:1];
    [self.layer setCornerRadius:self.frame.size.height/10];
    [self.layer setBorderColor:[UIColorFromRGB(134, 134, 134) CGColor]];
    [self.layer setMasksToBounds:YES];
    
    _reduceButton = [[UIButton alloc] init];
    [_reduceButton setTitle:@"-" forState:UIControlStateNormal];
    [_reduceButton setTitleColor:UIColorFromRGB(134, 134, 134) forState:UIControlStateNormal];
    [_reduceButton addTarget:self action:@selector(reduceTapped) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_reduceButton];
    [_reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width-pre, self.frame.size.height));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    [leftLabel.layer setBorderWidth:0.5];
    [leftLabel.layer setBorderColor:[UIColorFromRGB(134, 134, 134) CGColor]];
    [self addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, self.frame.size.height));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(_reduceButton.mas_right).with.offset(0);
    }];
    
    _textField = [[UITextField alloc] init];
    [_textField setText:@"1"];
    [_textField setKeyboardType:UIKeyboardTypeNumberPad];
    [_textField setDelegate:self];
    [_textField setTextColor:UIColorFromRGB(134, 134, 134)];
    [_textField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_textField setTextAlignment:NSTextAlignmentCenter];
    [self addSubview: _textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width+pre*2, self.frame.size.height));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(leftLabel.mas_right).with.offset(0);
    }];
    
    
    UILabel *rightLabel = [[UILabel alloc] init];
    [rightLabel.layer setBorderWidth:0.5];
    [rightLabel.layer setBorderColor:[UIColorFromRGB(134, 134, 134) CGColor]];
    [self addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, self.frame.size.height));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(_textField.mas_right).with.offset(0);
    }];
    
    _addButton = [[UIButton alloc] init];
    [_addButton setTitle:@"+" forState:UIControlStateNormal];
    [_addButton setTitleColor:UIColorFromRGB(134, 134, 134) forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addTapped) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_addButton];
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width-pre, self.frame.size.height));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(rightLabel.mas_right).with.offset(0);
    }];
}

-(void)setNumber:(int)number{
    if(number < _minValue || number > _maxValue) return;
    [_textField setText:[NSString stringWithFormat:@"%d",number]];
}

@end
