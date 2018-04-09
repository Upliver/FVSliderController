//
//  FVSliderControllerler.h
//  FVSliderController
//
//  Created by iforvert on 2017/11/29.
//  Copyright © 2017年 iforvert. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FVSliderControllerlerDelegate<NSObject>

- (void)sliderViewDidChangedCurrentIndex:(NSInteger)index;

@end

@protocol FVSliderProtocol <NSObject>

@required
- (NSString *)sliderContentString;

@end

@interface FVSliderControllerler : UIViewController

@property (nonatomic, strong) NSArray <__kindof UIViewController<FVSliderProtocol> *>*childSliderControllers;

- (void)reloadPages;

/** Slider Bar Right extro Btn Default is YES */
@property (nonatomic, assign) BOOL showExtroBtn;
/** Slider Bar Controller bottom bar show or not. Default is NO */
@property (nonatomic, assign) BOOL showTabBar;
/** extroBtn Temp....尽量不要用 */
@property (nonatomic, strong) UIButton *extroBtn;
/** extro width */
@property (nonatomic, assign) CGFloat extroWidth;

/** The index of current display view controller */
@property (nonatomic, assign) NSInteger currentIndex;
/** index changed action will called throught delegte property */
@property (nonatomic, weak) id<FVSliderControllerlerDelegate>sliderDelegate;

- (void)scrollToIndex:(NSInteger)index;

@end
