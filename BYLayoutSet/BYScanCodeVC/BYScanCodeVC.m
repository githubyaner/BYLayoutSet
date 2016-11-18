//
//  BYScanCodeVC.m
//  BYLayoutSet
//
//  Created by SunShine.Rock on 2016/11/18.
//  Copyright © 2016年 Berton. All rights reserved.
//

#import "BYScanCodeVC.h"
#import <AVFoundation/AVFoundation.h>

#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
#define XCenter self.view.center.x
#define YCenter self.view.center.y

#define SHeight 20

#define SWidth (XCenter+30)

@interface BYScanCodeVC () <UIAlertViewDelegate, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, assign) BOOL isResult;
@property (nonatomic, strong) UISwitch *lightSwitch;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation BYScanCodeVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self start];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"二维码扫描";
    [self customizedNavigation];
    self.imageView.image = [UIImage imageNamed:@"scanscanBg.png"];
    self.lineView.image = [UIImage imageNamed:@"scanLine.png"];
    BOOL success = [self createReading];
    if (success) {
        [self start];
    }
    [self setOverView];
    [self.view bringSubviewToFront:self.imageView];
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
    [self bootomView];
}

#pragma mark - 扫描
//创建扫描
- (BOOL)createReading {
    //获取AVCaptureDevice实例
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    //创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    //添加输入流
    [_captureSession addInput:input];
    //初始化输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //添加输出流
    [_captureSession addOutput:output];
    output.rectOfInterest = [self rectOfInterestByScanViewRect:_imageView.frame];
    //设置代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置元数据类型AVMetadataObjectTypeQRCode - 二维码
    [output setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer insertSublayer:_videoPreviewLayer atIndex:0];
    
    return YES;
}
//清除扫描
- (void)clearReading {
    [_captureSession stopRunning];
    _captureSession = nil;
}
//开启会话
- (void)start {
    [_captureSession startRunning];
}
//关闭会话
- (void)stop {
    [_captureSession stopRunning];
    if (self.lightSwitch.on) {
        [self.lightSwitch setOn:NO animated:YES];
    }
}

#pragma mark - other views
//设置导航条
- (void)customizedNavigation {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    CGRect frame = self.navigationController.navigationBar.frame;
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, frame.size.width, frame.size.height+20)];
    alphaView.backgroundColor = [UIColor lightGrayColor];
    alphaView.alpha = 0.6;
    alphaView.userInteractionEnabled = NO;
    [self.navigationController.navigationBar insertSubview: alphaView atIndex:0];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_down"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
}
//扫描框
- (UIImageView *)imageView {
    if (!_imageView) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake((Width - SWidth) / 2, (Height - SWidth) / 2, SWidth, SWidth)];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (UIImageView *)lineView {
    if (!_lineView) {
        self.lineView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, SWidth - 10, 2)];
        [_imageView addSubview:_lineView];
    }
    return _lineView;
}

//设置底部view
- (void)bootomView {
    UIView *bootomView = [[UIView alloc] initWithFrame:CGRectMake(0, Height - 50, Width, 50)];
    bootomView.backgroundColor = [UIColor lightGrayColor];
    bootomView.alpha = 0.6;
    [self.view addSubview:bootomView];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, (50 - 31) / 2, 31, 31)];
    title.text = @"闪光";
    title.font = [UIFont systemFontOfSize:12];
    title.textAlignment = NSTextAlignmentCenter;
    [bootomView addSubview:title];
    self.lightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(40, (50 - 31) / 2, 51, 31)];
    [_lightSwitch setOn:NO animated:YES];
    [_lightSwitch addTarget:self action:@selector(systemLightSwitch:) forControlEvents:UIControlEventValueChanged];
    [bootomView addSubview:_lightSwitch];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(Width - 60, 5, 50, 40);
    [button setTitle:@"相册" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(photoLibrary) forControlEvents:UIControlEventTouchUpInside];
    [bootomView addSubview:button];
}

#pragma mark - other function

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)lineAnimation {
    _lineView.frame = CGRectMake(5, 5, SWidth - 10, 2);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.lineView.frame = CGRectMake(5, weakSelf.imageView.frame.size.height - 7, SWidth - 10, 2);
    }];
}
//相册识别二维码 -- iOS 8支持
- (void)photoLibrary {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self stop];//取消检测
        //1.初始化相册拾取器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        //2.设置代理
        controller.delegate = self;
        //3.设置资源：
        controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //4.随便给他一个转场动画
        controller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:controller animated:YES completion:NULL];
    } else {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - 其他效果

- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = CGRectGetMinX(_imageView.frame);
    CGFloat y = CGRectGetMinY(_imageView.frame);
    CGFloat w = CGRectGetWidth(_imageView.frame);
    CGFloat h = CGRectGetHeight(_imageView.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}

- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.5;
    UIColor *backColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
}

- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    
    return CGRectMake(x, y, w, h);
}

//闪光灯
- (void)systemLightSwitch:(UISwitch *)lightSwitch {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (lightSwitch.on) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
            _isResult = YES;
        } else {
            NSLog(@"不是二维码");
            _isResult = NO;
        }
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}

- (void)reportScanResult:(NSString *)result {
    if (!_isResult) {
        return;
    }
    [self stop];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag = 888;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (888 == alertView.tag) {
        [self start];
        _isResult = NO;
    }
}

#pragma mark - image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //2.进行图片检测
    [self photoDetection:image];
}

- (void)photoDetection:(UIImage *)image {
        //初始化一个监测器
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh}];
        //监测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >= 1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:scannedResult delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
}

#pragma mark - dealloc

- (void)dealloc {
    [self clearReading];
}

@end
