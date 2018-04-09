//
//  FVSliderContentCell.m
//  FVSliderController
//
//  Created by iforvert on 2017/11/30.
//  Copyright © 2017年 iforvert. All rights reserved.
//

#import "FVSliderContentCell.h"

@interface FVSliderContentCell()

@end

@implementation FVSliderContentCell

- (void)configureWithViewController:(UIViewController *)childVC parentViewController:(UIViewController *)parentVC
{
    [parentVC addChildViewController:childVC];
    [self.contentView addSubview:childVC.view];
    childVC.view.frame = self.contentView.bounds;
    childVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [childVC didMoveToParentViewController:parentVC];
}

- (BOOL)isOwnerOfViewController:(UIViewController *)viewController
{
    return viewController.view.superview == self.contentView;
}

@end
