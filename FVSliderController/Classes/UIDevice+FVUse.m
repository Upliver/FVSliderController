//
//  UIDevice+FVUse.m
//  FVSliderController
//
//  Created by iforvert on 2018/2/11.
//  Copyright © 2018年 iforvert. All rights reserved.
//

#import "UIDevice+FVUse.h"
#import <sys/utsname.h>

@implementation UIDevice (FVUse)

+ (BOOL)fv_isIphoneX
{
    static BOOL iPhoneX = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if TARGET_OS_EMBEDDED
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *machine = @(systemInfo.machine);
        iPhoneX = ([machine isEqualToString:@"iPhone10,3"]
                   || [machine isEqualToString:@"iPhone10,6"]);
#else // TARGET_OS_SIMULATOR
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        iPhoneX = ABS(MAX(screenSize.width, screenSize.height) - 812.0) <= CGFLOAT_MIN;
#endif
    });
    return iPhoneX;
}

+ (BOOL)fv_isIpad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

@end
