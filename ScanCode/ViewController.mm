//
//  ViewController.m
//  ScanCode
//
//  Created by Do Ziv on 13-4-9.
//  Copyright (c) 2013年 Do Ziv. All rights reserved.
//

#import "ViewController.h"

#import <QRCodeReader.h>

//生成二维码
#import "QREncoder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanBtn setTitle:@"Scan" forState:UIControlStateNormal];
    [scanBtn setFrame:CGRectMake(60, 60, 50, 25)];
    [scanBtn addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
    
    UIButton *createCode = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [createCode setTitle:@"Create Code" forState:UIControlStateNormal];
    [createCode setFrame:CGRectMake(60, 100, 100, 40)];
    [createCode addTarget:self action:@selector(createCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createCode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scanAction{
    ZXingWidgetController *widgetController = [[ZXingWidgetController alloc]initWithDelegate:self showCancel:YES OneDMode:NO];
    NSMutableSet *readers = [[NSMutableSet alloc] init];
    QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];
    [readers addObject:qrcodeReader];
    widgetController.readers = readers;
    [self presentViewController:widgetController animated:YES completion:^{}];
}

- (void)createCodeAction{
    int qrcodeImageDimension = 250;
    NSString *codeStr = @"Hello iMadeFace! By Zivdo";
    DataMatrix *qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_ECLEVEL_AUTO string:codeStr];
    UIImage *qrCodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension];
    UIImageView *qrcodeImageView = [[UIImageView alloc] initWithImage:qrCodeImage];
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pressBackButton:)];
    [vc.navigationItem setRightBarButtonItem:rightButton];
    [vc.view addSubview:qrcodeImageView];
    [qrcodeImageView setCenter:vc.view.center];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{}];
}

#pragma mark - ZXingDelegate

- (void)zxingController:(ZXingWidgetController *)controller didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{[self outPutResult:result];}];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"cancel!");}];
}

- (void)outPutResult:(NSString *)result
{
    NSLog(@"result:%@", result);
//    self.textView.text = result;
}

@end
