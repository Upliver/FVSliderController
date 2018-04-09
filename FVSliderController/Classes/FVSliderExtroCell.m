//
//  FVSliderExtroCell.m
//  FVSliderController
//
//  Created by iforvert on 2017/11/30.
//  Copyright © 2017年 iforvert. All rights reserved.
//

#import "FVSliderExtroCell.h"

@implementation FVSliderExtroCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FVSliderAssets" ofType:@"bundle"];
        UIImage *normalImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"set_entitle_cell_bg@2x"]];
        UIImage *seleImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"set_entitle_cell_sele_bg@2x"]];
        [_button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [_button setBackgroundImage:seleImage forState:UIControlStateSelected];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        _button.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_button];
    }
    return self;
}

@end
