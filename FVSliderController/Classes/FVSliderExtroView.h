//
//  FVSliderExtroView.h
//  FVSliderController
//
//  Created by iforvert on 2017/11/30.
//  Copyright © 2017年 iforvert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FVSliderExtroView : UIView

@property (nonatomic, strong) NSArray *channelList;

@property (nonatomic, copy) void(^arrowBtnClickBlock)(void);
@property (nonatomic, copy) void(^cellButtonClick)(UIButton *button);

@property (nonatomic, assign) NSInteger currentSelectIndex;

@end
