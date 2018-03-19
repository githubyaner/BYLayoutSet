//
//  BYGuideViewVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2016/12/13.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYGuideViewVC.h"
#import "BYTempWebVC.h"
#import "AwesomeIntroGuideView.h"
#import "UIImageView+WebCache.h"

static  NSString * const introGuideImgUrl = @"https://s10.mogucdn.com/p1/161027/idid_ifqtantemfstmzdemizdambqgyyde_483x337.png";


typedef NS_ENUM(NSUInteger, BYIntroGuideType) {
    BYIntroGuideType_0 = 0,
    BYIntroGuideType_1,
    BYIntroGuideType_2,
    BYIntroGuideType_3,
};

@interface BYGuideViewVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *introduceArray;
@property (nonatomic, strong) AwesomeIntroGuideView *coachMarksView;
@property (nonatomic, assign) BOOL coachMarksShown;
@property (nonatomic, assign) BYIntroGuideType type;
@end

@implementation BYGuideViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizedNavigation];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.coachMarksView.animationDuration = 0.3;
    [self.navigationController.view addSubview:self.coachMarksView];
    self.navigationItem.titleView =({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"界面指引";
        [label sizeToFit];
        label;
    });
}

- (void)customizedNavigation {
    UIBarButtonItem *detailBtn = ({
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeInfoLight];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *temp = [[UIBarButtonItem alloc] initWithCustomView:btn];
        temp;
    });
    self.navigationItem.rightBarButtonItems = @[detailBtn];
}

- (void)detail {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BYLayoutSet" message:@"使用\"AwesomeIntroguideView\"" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"前往GitHub" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BYTempWebVC *webVC = [[BYTempWebVC alloc] initWithUrl:@"https://github.com/Bupterambition/AwesomeIntroguideView" BYVCTYPE:BYVCTYPE_POP];
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.collectionView.layoutMargins = UIEdgeInsetsMake(30, 10, 0, 10);
}

- (void)viewDidLayoutSubviews {
    if (self.coachMarksShown == NO  && self.introduceArray.count) {
        // 展示引导层
        switch (self.type) {
            case BYIntroGuideType_0: {
                self.coachMarksView.guideShape = AwesomeIntroGuideShape_Square;
                
                break;
            }
            case BYIntroGuideType_1: {
                self.coachMarksView.guideShape = AwesomeIntroGuideShape_Circle;
                break;
            }
            case BYIntroGuideType_2: {
                self.coachMarksView.guideShape = AwesomeIntroGuideShape_Star;
                break;
            }
            case BYIntroGuideType_3: {
                self.coachMarksView.guideShape = AwesomeIntroGuideShape_Other;
                break;
            }
        }
        self.coachMarksShown = YES;
        /*
         *  设置views
         */
//        [self.introduceArray addObject:self.navigationItem.titleView];
//        [self.introduceArray addObject:[[self.navigationController.navigationBar valueForKey:@"itemStack"][0] valueForKey:@"backButtonView"]];
        [self.coachMarksView loadMarks:self.introduceArray];
        /*
         *  设置图片和点
         *  字典的参数为:image,point
         */
//        [self.coachMarksView loadGuideImageUrl:introGuideImgUrl withPoint:(CGPoint){70,100} redirectURL:@"http://www.mogujie.com/" withFrequency:0];
        NSArray *imageName = @[@"icon_footprint", @"icon_footprint", @"icon_footprint"];
        NSMutableArray *imageItems = [NSMutableArray array];
        for (int i = 0; i < imageName.count; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:[UIImage imageNamed:imageName[i]] forKey:@"image"];
            UIView *view = self.introduceArray[i];
            [dict setValue:[NSValue valueWithCGPoint:CGPointMake(view.frame.origin.x, view.frame.origin.y + 64)] forKey:@"point"];
            [imageItems addObject:dict];
        }
        [self.coachMarksView loadGuideImageItem:imageItems];
        
        self.coachMarksView.animationDuration = 0.2;
        [self.coachMarksView start];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    if (indexPath.row %5 == 0 && self.introduceArray.count <=3 && indexPath.row != 0) {
//        [self.introduceArray addObject:cell];
//    }
    if (1 == indexPath.row || 6 == indexPath.row || 8 == indexPath.row) {
        [self.introduceArray addObject:cell];
    }
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%100/100. green:arc4random()%100/100. blue:arc4random()%100/100. alpha:arc4random()%100/100.];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)/3 - 10;
    return (CGSize){width,width};
}

#pragma mark - getter Method
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSMutableArray *)introduceArray {
    if (_introduceArray == nil) {
        _introduceArray = [NSMutableArray array];
    }
    return _introduceArray;
}

- (AwesomeIntroGuideView *)coachMarksView {
    if (!_coachMarksView) {
        _coachMarksView = [[AwesomeIntroGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coachMarksView.completionBlock = ^(AwesomeIntroGuideView *guideView){
            NSLog(@"%@",guideView);
        };
        _coachMarksView.willCompletionBlock = ^(AwesomeIntroGuideView *guideView){
            NSLog(@"%@",guideView);
        };
        _coachMarksView.didNavgateBlock = ^(AwesomeIntroGuideView *guideView, NSUInteger indedx) {
            NSLog(@"%@",guideView);
        };
        _coachMarksView.willNavgateBlock = ^(AwesomeIntroGuideView *guideView, NSUInteger indedx) {
            NSLog(@"%@",guideView);
        };
        _coachMarksView.loadType = AwesomeIntroLoad_Sync;
    }
    return _coachMarksView;
}

@end
