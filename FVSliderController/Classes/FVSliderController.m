//
//  FVSliderControllerler.m
//  FVSliderController
//
//  Created by iforvert on 2017/11/29.
//  Copyright © 2017年 iforvert. All rights reserved.
//

#import "FVSliderController.h"
#import "FVSliderLabel.h"
#import "FVSliderContentCell.h"
#import "FVSliderExtroView.h"
#import "UIView+Extension.h"
#import "UIDevice+FVUse.h"

static NSString * const kCellID = @"kCellID";

@interface FVSliderControllerler ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *sliderView;
@property (nonatomic, strong) UICollectionView *containerView;
@property (nonatomic, strong) UIView *underline;
@property (nonatomic, strong) FVSliderExtroView *extroView;
@property (nonatomic, strong) UIView *seperatorLine;

@end

@implementation FVSliderControllerler
{
    NSMutableDictionary<NSNumber*, UIViewController*>* _controllerCache;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _showExtroBtn = YES;
    _showTabBar = NO;
    _controllerCache = [NSMutableDictionary dictionary];
}

- (void)_setupChildView
{
    if (@available(iOS 11.0, *))
        self.containerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    else
        self.automaticallyAdjustsScrollViewInsets = NO;
    if (![self.sliderView.subviews containsObject:self.sliderView])
        [self.view addSubview:self.sliderView];
    if (![self.sliderView.subviews containsObject:self.containerView])
        [self.view addSubview:self.containerView];
    if (![self.sliderView.subviews containsObject:self.extroBtn] && _showExtroBtn)
        [self.view addSubview:self.extroBtn];
    if (![self.sliderView.subviews containsObject:self.seperatorLine])
        [self.view addSubview:self.seperatorLine];
}

#pragma mark - interface

- (void)reloadPages
{
    [self refreshCache];
    [self resetChannelLabel];
    [self.containerView reloadData];
}

- (void)scrollToIndex:(NSInteger)index {
    [self.containerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)resetChannelLabel
{
    for (UIView * view  in [_sliderView subviews]) {
        [view removeFromSuperview];
    }
    [_sliderView removeFromSuperview];
    _sliderView = nil;
    
    if (![self.sliderView.subviews containsObject:self.sliderView])
        [self.view addSubview:self.sliderView];

    if (![self.sliderView.subviews containsObject:self.containerView])
        [self.view addSubview:self.containerView];

    if (![self.sliderView.subviews containsObject:self.extroBtn] && _showExtroBtn)
        [self.view addSubview:self.extroBtn];

    if (![self.sliderView.subviews containsObject:self.seperatorLine])
        [self.view addSubview:self.seperatorLine];
}

- (void)refreshCache
{
    for (UIViewController* controller in _controllerCache.allValues)
    {
        [controller willMoveToParentViewController:nil];
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
    }
    [_controllerCache removeAllObjects];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    UIViewController* result = _controllerCache[@(index)];
    if (result == nil)
    {
        result = self.childSliderControllers[index];
        _controllerCache[@(index)] = result;
    }
    return result;
}

- (void)removeViewControllerAtIndex:(NSInteger)index
{
    UIViewController* controller = _controllerCache[@(index)];
    if (controller)
    {
        [controller willMoveToParentViewController:nil];
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
        [_controllerCache removeObjectForKey:@(index)];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childSliderControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FVSliderContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    if (cell.indexPath)
    {
        UIViewController* controller = _controllerCache[@(cell.indexPath.item)];
        if (controller != nil && [cell isOwnerOfViewController:controller])
        {
            [self removeViewControllerAtIndex:cell.indexPath.item];
        }
    }
    UIViewController* page = [self viewControllerAtIndex:indexPath.item];
    [cell configureWithViewController:page parentViewController:self];
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (value < 0)
        return;
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    if (rightIndex >= [self getLabelArrayFromSubviews].count)
        rightIndex = [self getLabelArrayFromSubviews].count - 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft  = 1 - scaleRight;
    FVSliderLabel *labelLeft  = [self getLabelArrayFromSubviews][leftIndex];
    FVSliderLabel *labelRight = [self getLabelArrayFromSubviews][rightIndex];
    labelLeft.scale  = scaleLeft;
    labelRight.scale = scaleRight;
    if (scaleLeft == 1 && scaleRight == 0)
        return;
    
    _underline.centerX = labelLeft.centerX + (labelRight.centerX - labelLeft.centerX) * scaleRight;
    _underline.width = labelLeft.textWidth + (labelRight.textWidth - labelLeft.textWidth) * scaleRight;
}

/** 手指滑动containerView，滑动结束后调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.containerView])
    {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

/** 手指点击sliderView */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / self.containerView.width;
    FVSliderLabel *titleLable = [self getLabelArrayFromSubviews][index];
    CGFloat offsetx = titleLable.center.x - _sliderView.width * 0.5;
    CGFloat offsetMax = fabs(_sliderView.contentSize.width - _sliderView.width);
    if (offsetx < 0)
        offsetx = 0;
    if (offsetx > offsetMax)
        offsetx = offsetMax;
    [_sliderView setContentOffset:CGPointMake(offsetx, 0) animated:YES];
    for (FVSliderLabel *label in [self getLabelArrayFromSubviews])
        label.textColor = [UIColor blackColor];
    [UIView animateWithDuration:0.35 animations:^{
        _underline.width = titleLable.textWidth;
        _underline.centerX = titleLable.centerX;
        titleLable.textColor = [UIColor redColor];
    }];
    _currentIndex = index;
    if (self.sliderDelegate)
        [self.sliderDelegate sliderViewDidChangedCurrentIndex:_currentIndex];
}

#pragma mark - Setter

- (void)setChildSliderControllers:(NSArray<__kindof UIViewController *> *)childSliderControllers
{
    _childSliderControllers = childSliderControllers;
    [self _setupChildView];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    NSAssert(self.childSliderControllers.count > _currentIndex, @"Can't set currentIndex beyong the number of childSliderControllers");
    _currentIndex = currentIndex;
    [_containerView setContentOffset:CGPointMake(_currentIndex * _containerView.frame.size.width, 0)];
    [self scrollViewDidEndScrollingAnimation:self.containerView];
}

#pragma mark - Getter

- (UIView *)seperatorLine
{
    if (!_seperatorLine)
    {
        _seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.sliderView.maxY - 0.5, ScrW, 0.5)];
        _seperatorLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _seperatorLine;
}

- (UIScrollView *)sliderView
{
    if (_sliderView == nil)
    {
        CGFloat sliderY = self.navigationController ? 64 : 0;
        _sliderView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, sliderY, ScrW, 44)];
        _sliderView.backgroundColor = [UIColor whiteColor];
        _sliderView.showsHorizontalScrollIndicator = NO;
        [self setupChannelLabel];
        // 设置下划线
        if ([self getLabelArrayFromSubviews].count != 0)
        {
            [_sliderView addSubview:({
                FVSliderLabel *firstLabel = [self getLabelArrayFromSubviews][0];
                firstLabel.textColor = [UIColor redColor];
                _underline = [[UIView alloc] initWithFrame:CGRectMake(0, 42, firstLabel.textWidth, 2)];
                _underline.centerX = firstLabel.centerX;
                _underline.backgroundColor = [UIColor redColor];
                _underline;
            })];
        }
    }
    return _sliderView;
}

- (UICollectionView *)containerView
{
    if (_containerView == nil)
    {
        CGFloat tabBarH = [UIDevice fv_isIphoneX] ? 49+34 : 49;
        CGFloat naviBarH = [UIDevice fv_isIphoneX] ? 88.f : 64.f;
        CGFloat h = ScrH - naviBarH - self.sliderView.height;
        if (_showTabBar)
            h -= tabBarH;
        CGRect frame = CGRectMake(0, self.sliderView.maxY, ScrW, h);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _containerView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.delegate = self;
        _containerView.dataSource = self;
        [_containerView registerClass:[FVSliderContentCell class] forCellWithReuseIdentifier:kCellID];
        // 设置cell的大小和细节
        flowLayout.itemSize = _containerView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _containerView.pagingEnabled = YES;
        _containerView.showsHorizontalScrollIndicator = NO;
    }
    return _containerView;
}

- (UIButton *)extroBtn
{
    if (_extroBtn == nil)
    {
        _extroBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScrW - 44, self.sliderView.y, 44, 44)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FVSliderAssets" ofType:@"bundle"];
        UIImage *image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"danti_down@2x"]];
        [_extroBtn setImage:image forState:UIControlStateNormal];
        _extroBtn.backgroundColor = [UIColor whiteColor];
        _extroBtn.layer.shadowColor = [UIColor whiteColor].CGColor;
        _extroBtn.layer.shadowOpacity = 1;
        _extroBtn.layer.shadowRadius = 5;
        _extroBtn.layer.shadowOffset = CGSizeMake(-10, 0);
        [_extroBtn addTarget:self action:@selector(extroButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _extroBtn;
}

- (FVSliderExtroView *)extroView
{
    if (!_extroView)
    {
        _extroView = [[FVSliderExtroView alloc] init];
        _extroView.channelList = self.childSliderControllers;
        _extroView.backgroundColor = [UIColor redColor];
        _extroView.frame = self.view.frame;
        // 箭头点击回调
        __weak typeof(self) weakSelf = self;
        _extroView.arrowBtnClickBlock = ^{
            [UIView animateWithDuration:0.35 animations:^{
                weakSelf.extroView.y = -ScrH;
//                weakSelf.tabBarController.tabBar.y = ScrH - 49;
            } completion:^(BOOL finished) {
                [weakSelf.extroView removeFromSuperview];
            }];
        };
        _extroView.cellButtonClick = ^(UIButton *button){
            for (FVSliderLabel *label in [weakSelf getLabelArrayFromSubviews])
            {
                if ([label.text isEqualToString:button.titleLabel.text]) {
                    weakSelf.extroView.arrowBtnClickBlock();
                    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
                    [tap setValue:label forKey:@"view"];
                    [weakSelf labelClick:tap];
                }
            }
        };
    }
    return _extroView;
}

- (void)setupChannelLabel
{
    CGFloat margin = 20.0;
    CGFloat x = 8;
    CGFloat h = _sliderView.bounds.size.height;
    int i = 0;
    for (UIViewController <FVSliderProtocol>* vc  in self.childSliderControllers)
    {
        FVSliderLabel *label = [FVSliderLabel sliderLabelWithTitle:[vc sliderContentString]];
        label.frame = CGRectMake(x, 0, label.width + margin, h);
        [_sliderView addSubview:label];
        x += label.bounds.size.width;
        label.tag = i++;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
    if (_showExtroBtn)
        x += margin + self.extroBtn.width;
    _sliderView.contentSize = CGSizeMake(x, 0);
}

/** Label点击事件 */
- (void)labelClick:(UITapGestureRecognizer *)recognizer
{
    FVSliderLabel *label = (FVSliderLabel *)recognizer.view;
    [_containerView setContentOffset:CGPointMake(label.tag * _containerView.frame.size.width, 0)];
    [self scrollViewDidEndScrollingAnimation:self.containerView];
}

/** 获取sliderview中所有的label，合成一个数组，因为sliderview.subViews中有其他非Label元素 */
- (NSArray *)getLabelArrayFromSubviews
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (FVSliderLabel *label in _sliderView.subviews)
    {
        if ([label isKindOfClass:[FVSliderLabel class]])
            [arrayM addObject:label];
    }
    return arrayM.copy;
}

/** extr按钮点击事件 */
- (void)extroButtonClick
{
    [self.view addSubview:self.extroView];
    _extroView.y = -ScrH;
    self.extroView.currentSelectIndex = self.currentIndex;
    [UIView animateWithDuration:0.35 animations:^{
        _extroView.y = _sliderView.y;
    }];
}

- (void)setExtroWidth:(CGFloat)extroWidth
{
    CGFloat x = _sliderView.contentSize.width;
    if (_showExtroBtn)
        x += (extroWidth - 44);
    _sliderView.contentSize = CGSizeMake(x, 0);
}

@end
