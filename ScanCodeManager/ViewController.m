//
//  ViewController.m
//  ScanCodeManager
//
//  Created by 莫名 on 17/3/10.
//  Copyright © 2017年 hy. All rights reserved.
//

#import "ViewController.h"
#import "ScanCodeManager.h"
#import <AVFoundation/AVFoundation.h>
#import "MaskView.h"
#import "ImageScanViewController.h"

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic, strong) UIButton *resetBtn; // 重置扫描状态按钮
@property (nonatomic, strong) UIButton *torchBtn; // 闪光灯按钮
@property (nonatomic, strong) UIButton *photoBtn; // 相册按钮
@property (nonatomic, strong) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupUI];
}

- (void)setupUI {
    
    CGRect scanRect = CGRectMake(30, 100, 200, 140);
    UIView *scanView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 400)];
    scanView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:scanView];
    
    MaskView *mv = [[MaskView alloc] initWithFrame:scanView.bounds];
    mv.maskRect = scanRect;
    [scanView addSubview:mv];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    self.label.textColor = [UIColor orangeColor];
    [mv addSubview:self.label];
    
    if ([self canOpenCamera]) {
        [[ScanCodeManager manager] scanCodeWithType:ScanTypeQRCode|ScanTypeBarCode scanView:scanView scanRect:scanRect completeHandler:^(NSString *code) {
            
            self.label.text = code;
            NSLog(@"viewController -code ==>: %@", code);
        }];
    } else {
        NSLog(@"不能访问相机");
    }
    
    [self setupButtons];
}

- (void)setupButtons {
    self.resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 100, 80, 30)];
    [self.resetBtn setBackgroundColor:[UIColor orangeColor]];
    self.resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.resetBtn setTitle:@"重置状态" forState:UIControlStateNormal];
    [self.view addSubview:self.resetBtn];
    [self.resetBtn addTarget:self action:@selector(resetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.torchBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, SCREEN_HEIGHT - 100, 80, 30)];
    [self.torchBtn setBackgroundColor:[UIColor orangeColor]];
    self.torchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.torchBtn setTitle:@"打开闪关灯" forState:UIControlStateNormal];
    [self.torchBtn setTitle:@"关闭闪关灯" forState:UIControlStateSelected];
    [self.view addSubview:self.torchBtn];
    [self.torchBtn addTarget:self action:@selector(torchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 50, 120, 30)];
    [self.photoBtn setBackgroundColor:[UIColor orangeColor]];
    self.photoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.photoBtn setTitle:@"识别图片中的二维码" forState:UIControlStateNormal];
    [self.view addSubview:self.photoBtn];
    [self.photoBtn addTarget:self action:@selector(photoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - button action

- (void)resetBtnAction:(UIButton *)btn {
    
    self.label.text = @"";
    [[ScanCodeManager manager] resetScanState];
}

- (void)torchBtnAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [[ScanCodeManager manager] onTorch];
    } else {
        [[ScanCodeManager manager] offTorch];
    }
}

- (void)photoBtnAction:(UIButton *)btn {
    
    ImageScanViewController *vc = [[ImageScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)canOpenCamera{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-照片“选项中，允许%@访问你的相机",NSLocalizedString(@"AppName",@"EnnNew")];
        //无权限 做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:tips delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return NO;
    }
    return YES;
}

- (void)dealloc {
    
    [[ScanCodeManager manager] stopScan];
}

@end
