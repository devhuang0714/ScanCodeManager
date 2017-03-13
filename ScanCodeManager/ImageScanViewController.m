//
//  ImageScanViewController.m
//  ScanCodeManager
//
//  Created by 莫名 on 17/3/13.
//  Copyright © 2017年 hy. All rights reserved.
//

#import "ImageScanViewController.h"
#import "ScanCodeManager.h"

@interface ImageScanViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ImageScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.image = [UIImage imageNamed:@"test.jpg"];
    [self.view addSubview:self.imageView];
    
    self.label = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.label.textColor = [UIColor orangeColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    
    [[ScanCodeManager manager] scanQRCodeFormImage:self.imageView.image completeHandler:^(NSString *code) {
        
        self.label.text = code;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    NSLog(@"ImageScanViewController delloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
