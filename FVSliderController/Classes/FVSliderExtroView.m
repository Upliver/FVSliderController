//
//  FVSliderExtroView.m
//  FVSliderController
//
//  Created by iforvert on 2017/11/30.
//  Copyright © 2017年 iforvert. All rights reserved.
//

#import "FVSliderExtroView.h"
#import "Masonry.h"
#import "FVSliderExtroCell.h"
#import "FVSliderController.h"

static NSString * const kSliderExtroCellID = @"kSliderExtroCellID";

@interface FVSliderExtroView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *containerView;
@property (nonatomic, strong) UIView *topContainerView;

@end

@implementation FVSliderExtroView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView
{
    [self addSubview:self.topContainerView];
    [self addSubview:self.containerView];
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0.f);
        make.height.mas_equalTo(44.f);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44.f);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)arrowButtonClick
{
    if (self.arrowBtnClickBlock)
        self.arrowBtnClickBlock();
}

- (void)setChannelList:(NSArray *)channelList
{
    _channelList = channelList;
    [self.containerView reloadData];
}

- (void)setCurrentSelectIndex:(NSInteger)currentSelectIndex
{
    _currentSelectIndex = currentSelectIndex;
    [self.containerView reloadData];
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _channelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FVSliderExtroCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSliderExtroCellID forIndexPath:indexPath];
    UIViewController <FVSliderProtocol>*vc = self.channelList[indexPath.row];
    NSString *name = [vc sliderContentString];
    [cell.button setTitle:name forState:UIControlStateNormal];
    [cell.button addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == _currentSelectIndex)
    {
        cell.button.selected = YES;
    }
    else
    {
        cell.button.selected = NO;
    }
    return cell;
}

#pragma mark - action

- (void)cellButtonClick:(UIButton *)sender
{
    if (self.cellButtonClick)
        self.cellButtonClick(sender);
}

#pragma mark - Getter

- (UICollectionView *)containerView
{
    if (!_containerView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        layout.itemSize = CGSizeMake(70, 30);
        layout.minimumInteritemSpacing = 10.f;
        layout.minimumLineSpacing = 10.f;
        _containerView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                              collectionViewLayout:layout];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.dataSource = self;
        _containerView.delegate = self;
        [_containerView registerClass:[FVSliderExtroCell class] forCellWithReuseIdentifier:kSliderExtroCellID];
    }
    return _containerView;
}

- (UIView *)topContainerView
{
    if (!_topContainerView)
    {
        _topContainerView = [[UIView alloc] init];
        _topContainerView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"请选择地区";
        label.font = [UIFont systemFontOfSize:15];
        [label sizeToFit];
        [_topContainerView addSubview:label];
        
        UIButton *closeBtn = [[UIButton alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FVSliderAssets" ofType:@"bundle"];
        UIImage *image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"danti_up@2x"]];
        [closeBtn setImage:image forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(arrowButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_topContainerView addSubview:closeBtn];
        UILabel *seperatorLine = [[UILabel alloc] init];
        seperatorLine.backgroundColor = [UIColor lightGrayColor];
        [_topContainerView addSubview:seperatorLine];
        
        [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(0.f);
            make.height.mas_equalTo(1.f/[UIScreen mainScreen].scale);
        }];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_offset(0.f);
            make.width.height.mas_equalTo(44.f);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(15.f);
        }];
    }
    return _topContainerView;
}

@end
