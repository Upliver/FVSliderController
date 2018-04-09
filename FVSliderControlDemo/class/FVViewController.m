//
//  FVViewController.m
//  FVSliderController
//
//  Created by iforvert on 2018/2/11.
//  Copyright © 2018年 iforvert. All rights reserved.
//

#import "FVViewController.h"
#import "FVChildViewController.h"

@interface FVViewController ()

@end

@implementation FVViewController
{
    NSArray *_dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    [self setupChildView];
}

- (void)setupChildView
{
    NSMutableArray *childVCS = [NSMutableArray array];
    for (int i = 0; i < _dataArray.count; i++)
    {
        [childVCS addObject:[self configChildViewControllerWithTitle:_dataArray[i]]];
    }
    self.childSliderControllers = childVCS;
}

- (FVChildViewController *)configChildViewControllerWithTitle:(NSString *)title
{
    return [[FVChildViewController alloc] initWithTitle:title];
}

- (void)loadData
{
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"SliderData" ofType:@"plist"];
    _dataArray = [NSArray arrayWithContentsOfFile:dataPath];
}

@end
