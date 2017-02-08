//
//  ViewController.m
//  CityChoose
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 desn. All rights reserved.
//

#import "ViewController.h"
#import "CityChoose.h"
@interface ViewController ()
@property (nonatomic, strong) UILabel *label;            /** 显示地址 */
@property (nonatomic, strong) CityChoose *cityChoose;    /** 城市选择 */
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"城市选择" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 40)];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
}

- (void)buttonClick{

    self.cityChoose = [[CityChoose alloc] init];
    __weak typeof(self) weakSelf = self;
    self.cityChoose.config = ^(NSString *province, NSString *city, NSString *town){
        weakSelf.label.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,town];
    };
    [self.view addSubview:self.cityChoose];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
