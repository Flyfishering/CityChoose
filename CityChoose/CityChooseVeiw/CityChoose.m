//
//  CityChoose.m
//  CityChoose
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 desn. All rights reserved.
//

#import "CityChoose.h"

static CGFloat bgViewHeith = 240;
static CGFloat cityPickViewHeigh = 200;
static CGFloat toolsViewHeith = 40;
static CGFloat animationTime = 0.25;
@interface CityChoose()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *cityPickerView;/** 城市选择器 */
@property (nonatomic, strong) UIButton *sureButton;        /** 确认按钮 */
@property (nonatomic, strong) UIButton *canselButton;      /** 取消按钮 */
@property (nonatomic, strong) UIView *toolsView;           /** 自定义标签栏 */
@property (nonatomic, strong) UIView *bgView;              /** 背景view */

//省  市 县 变量
@property (nonatomic, strong) NSDictionary *allCityInfo;   /** 所有省市县信息 */
@property (nonatomic, strong) NSArray *provinceArr;        /** 省 数组 */
@property (nonatomic, strong) NSArray *cityArr;            /** 市 数组 */
@property (nonatomic, strong) NSArray *townArr;            /** 县城 数组 */
@property (nonatomic, strong) NSDictionary *provinceDic;   /** 省下面所有的市县 */
@property (nonatomic, strong) NSDictionary *cityDic;       /** 市下面所有的区县 */

@end

@implementation CityChoose


// init 会调用 initWithFrame
- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        [self initBaseData];
    }
    return self;
}

- (void)initSubViews{
    
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.toolsView];
    [self.toolsView addSubview:self.canselButton];
    [self.toolsView addSubview:self.sureButton];
    
    [self.bgView addSubview:self.cityPickerView];
    
    [self showPickView];
    
}

- (void)initBaseData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    self.allCityInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i=0; i<self.allCityInfo.count; i++) {
        NSDictionary *dic = [self.allCityInfo valueForKey:[@(i) stringValue]];
        [tempArr addObject:dic.allKeys[0]];
    }
    self.provinceArr    = [tempArr copy];
    self.provinceDic    = [[self.allCityInfo valueForKey:[@(0) stringValue]] valueForKey:self.provinceArr[0]];
    self.cityArr        = [self getNameforProvince:0];
    self.townArr        = [[self.provinceDic valueForKey:[@(0) stringValue]] valueForKey:self.cityArr[0]];
    
    self.province   = self.provinceArr[0];
    self.city       = self.cityArr[0];
    self.town       = self.townArr[0];
    
    
}

#pragma event menthods
- (void)canselButtonClick{
    [self hidePickView];
    if (self.config) {
        self.config(self.province,self.city,self.town);
    }
}

- (void)sureButtonClick{
    [self hidePickView];
    if (self.config) {
        self.config(self.province,self.city,self.town);
    }
}

#pragma mark private methods
- (void)showPickView{
    [UIView animateWithDuration:animationTime animations:^{
        self.bgView.frame = CGRectMake(0, self.frame.size.height - bgViewHeith, self.frame.size.width, bgViewHeith);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hidePickView{
    
    [UIView animateWithDuration:animationTime animations:^{
        
        self.bgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, bgViewHeith);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

- (NSArray *)getNameforProvince:(NSInteger)row{
    self.provinceDic = [[self.allCityInfo valueForKey:[@(row) stringValue]] objectForKey:self.provinceArr[row]];
    NSMutableArray *temp2 = [[NSMutableArray alloc] init];
    for (int i=0; i<self.provinceDic.allKeys.count; i++) {
        NSDictionary *dic = [self.provinceDic valueForKey:[@(i) stringValue]];
        [temp2 addObject:dic.allKeys[0]];
    }
    return temp2;
}

#pragma mark - pickerViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArr.count;
    }
    else if(component == 1){
        return  self.cityArr.count;
    }
    else if(component == 2){
        return self.townArr.count;
    }
    return 0;
}

#pragma mark - pickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/3.0, 30)];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        label.text =  self.provinceArr[row];
    }else if (component == 1){
        label.text =  self.cityArr[row];
    }else if (component == 2){
        label.text =  self.townArr[row];
    }
    return label;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    if (component == 0) {
//        return self.provinceArr[row];
//    }else if (component == 1){
//        return self.cityArr[row];
//    }else if (component == 2){
//        return self.townArr[row];
//    }
//    return @"";
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {//选择省
        self.cityArr = [self getNameforProvince:row];
        self.townArr = [[self.provinceDic valueForKey:[@(0) stringValue]] valueForKey:self.cityArr[0]];
        
        [self.cityPickerView reloadComponent:1];
        [self.cityPickerView selectRow:0 inComponent:1 animated:YES];
        [self.cityPickerView reloadComponent:2];
        [self.cityPickerView selectRow:0 inComponent:2 animated:YES];
        
        self.province   = self.provinceArr[row];
        self.city       = self.cityArr[0];
        self.town       = self.townArr[0];
    }else if (component == 1){//选择城市
        self.townArr = [[self.provinceDic valueForKey:[@(row) stringValue]] valueForKey:self.cityArr[row]];
        [self.cityPickerView reloadComponent:2];
        [self.cityPickerView selectRow:0 inComponent:2 animated:YES];
        
        self.city = self.cityArr[row];
        self.town = self.townArr[0];
    }else if (component == 2){
        self.town = self.townArr[row];
    }
    if (self.config) {
        self.config(self.province, self.city, self.town);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if ([touches.anyObject.view isKindOfClass:[self class]]) {
        [self hidePickView];
    }
}

#pragma mark - lazy 

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, bgViewHeith)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIPickerView *)cityPickerView{
    if (!_cityPickerView) {
        _cityPickerView = ({
            UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, toolsViewHeith, self.frame.size.width, cityPickViewHeigh)];
            pickerView.backgroundColor = [UIColor whiteColor];
            //            [pickerView setShowsSelectionIndicator:YES];
            pickerView.delegate = self;
            pickerView.dataSource = self;
            pickerView;
        });
    }
    return _cityPickerView;
}

- (UIView *)toolsView{
    
    if (!_toolsView) {
        _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, toolsViewHeith)];
        _toolsView.layer.borderWidth = 0.5;
        _toolsView.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return _toolsView;
}

- (UIButton *)canselButton{
    if (!_canselButton) {
        _canselButton = ({
            UIButton *canselButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 50, toolsViewHeith)];
            [canselButton setTitle:@"取消" forState:UIControlStateNormal];
            [canselButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [canselButton addTarget:self action:@selector(canselButtonClick) forControlEvents:UIControlEventTouchUpInside];
            canselButton;
        });
    }
    return _canselButton;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = ({
            UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 20 - 50, 0, 50, toolsViewHeith)];
            [sureButton setTitle:@"确定" forState:UIControlStateNormal];
            [sureButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
            sureButton;
        });
    }
    return _sureButton;
}

@end
