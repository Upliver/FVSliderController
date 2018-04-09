//
//  FVChildViewController.m
//  FVSliderController
//
//  Created by iforvert on 2018/2/11.
//  Copyright © 2018年 iforvert. All rights reserved.
//

#import "FVChildViewController.h"
#import "FVSliderController.h"
#import "Masonry.h"

@interface FVChildViewController ()<FVSliderProtocol>

@property (nonatomic, strong) UILabel *centerLabel;

@end

@implementation FVChildViewController
{
    NSString *_title;
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self)
    {
        _title = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupChildView];
}

- (void)setupChildView
{
    [self.view addSubview:self.centerLabel];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    self.centerLabel.text = _title;
}

#pragma mark - <FVSliderControllerlerDelegate>

- (NSString *)sliderContentString
{
    return _title;
}

- (UILabel *)centerLabel
{
    return _centerLabel ? : (_centerLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    }));
}

@end
