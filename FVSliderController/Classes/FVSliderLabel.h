//
//  FVSliderLabel.h
//  FVSliderController
//
//  Created by iforvert on 2017/11/29.
//  Copyright © 2017年 iforvert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FVSliderLabel : UILabel

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat textWidth;

+ (instancetype)sliderLabelWithTitle:(NSString *)title;

@end
