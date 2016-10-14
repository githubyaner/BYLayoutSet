//
//  BYGuevaraVC.m
//  Xcode8TestSet
//
//  Created by SunShine.Rock on 16/10/12.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYGuevaraVC.h"
#import "BYGuevaraCell.h"
#import "BYGuevaraContentVC.h"
#import "BYGuevaraTransition.h"
#import "UIViewController+BYGuevaraTransitionExtension.h"

@interface BYGuevaraVC () <UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>
@property (nonatomic, strong) BYGuevaraTransition *animate;
@property (strong, nonatomic) UICollectionView *collectionView;
@end

@implementation BYGuevaraVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"格拉瓦电影转场效果";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *goBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"]  style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItems = @[goBackBtn];
    [self customizedCollectionView];
    
    self.animate = [[BYGuevaraTransition alloc] initWithTransitionType:BYGuevaraTransitionPush];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)customizedCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake([UIScreen mainScreen].bounds.size.width / 3 - 20, ([UIScreen mainScreen].bounds.size.width / 3 - 20) * 1.3)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [layout setMinimumInteritemSpacing:20];
    [layout setMinimumLineSpacing:20];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[BYGuevaraCell class] forCellWithReuseIdentifier:@"BYGuevaraCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigationcontroller delegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0) {
    if (operation == UINavigationControllerOperationPush) {
        return self.animate;
    } else {
        return nil;
    }
}

#pragma mark - collectionview delegate & datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BYGuevaraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BYGuevaraCell" forIndexPath:indexPath];
    CGFloat red = (arc4random() % 255 / 255.0);
    CGFloat blue = (arc4random() % 255 / 255.0);
    CGFloat green = (arc4random() % 255 / 255.0);
    cell.backgroundColor = [UIColor colorWithRed:red green:blue blue:green alpha:1.0];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BYGuevaraCell *cell = (BYGuevaraCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.sf_targetView = cell;
    BYGuevaraContentVC *contentVC = [[BYGuevaraContentVC alloc] init];
    contentVC.iconColor = cell.backgroundColor;
    [self.navigationController pushViewController:contentVC animated:YES];
}

@end
