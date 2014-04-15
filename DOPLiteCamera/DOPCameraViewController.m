//
//  DOPCameraViewController.m
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/11.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIView+AutoLayout.h>
#import "DOPCameraViewController.h"
#import "DOPAssetsCollectionViewController.h"
#import "DOPAssetsCollectionViewLayout.h"
#import "DOPCameraView.h"
#import "DOPImagePickerView.h"

@interface DOPCameraViewController () <DOPCameraDelegate, DOPImagePickerDelegate, DOPAssetsCollectionViewControllerDelegate>

@property (nonatomic,strong) DOPCameraView *cameraView;
@property (nonatomic,strong) DOPImagePickerView *picker;
@property (nonatomic,strong) UIToolbar *toolBar;


@end

@implementation DOPCameraViewController

- (instancetype) init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDOPCameraView];
    [self initToolBar];
    [self.view setNeedsUpdateConstraints];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.cameraView autoFocus];
}

- (void) updateViewConstraints
{
    [super updateViewConstraints];
    [self.toolBar autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.toolBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.toolBar autoPinEdgeToSuperviewEdge:ALEdgeRight  withInset:0];
    [self.toolBar autoSetDimension:ALDimensionHeight toSize:80];
}


- (void) initDOPCameraView
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.cameraView = [[DOPCameraView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                            self.view.bounds.size.width,
                                            self.view.bounds.size.height )];
    [self.cameraView setDelegate:self];
    
    [self.view addSubview:self.cameraView];
}

- (void) initToolBar
{
    self.toolBar = [UIToolbar newAutoLayoutView];
    
    [self.toolBar setBackgroundImage:[[UIImage alloc]init] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.view addSubview:self.toolBar];
    [self.toolBar setClipsToBounds:YES];
    UIImage *shutterIcon = [UIImage imageNamed:@"shutter"];
    UIButton *shutter = [UIButton buttonWithType:UIButtonTypeCustom];
    shutter.bounds = CGRectMake( 0, 0, shutterIcon.size.width, shutterIcon.size.height );
    [shutter setImage:shutterIcon forState:UIControlStateNormal];
    UIBarButtonItem *shutterBtn = [[UIBarButtonItem alloc] initWithCustomView:shutter];
    [shutter addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.picker = [[DOPImagePickerView alloc]initWithFrame:CGRectMake(0,0,40,40)];
    UIBarButtonItem *pickerBtn = [[UIBarButtonItem alloc] initWithCustomView:self.picker];
    self.picker.translatesAutoresizingMaskIntoConstraints = NO;
    [self.picker setDelegate:self];
    
    //[self.toolBar addSubview: self.picker];
    
    
    
    //UIBarButtonItem *shutter = [[UIBarButtonItem alloc] initWithImage:shutterIcon style:UIBarButtonItemStyleDone target:self action:@selector(takePhoto:)];
    self.toolBar.items = @[pickerBtn, flexibleSpace,shutterBtn, flexibleSpace];
}

- (void) takePhoto:(id) sender
{
    [self.cameraView takePhoto:sender];
}

- (BOOL) shouldAutorotate
{
    return NO;
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark - DOPCamera view delegate

- (void) didImageSaved:(UIImage *) image
{
    [self.picker showImage:image];
}

#pragma  mark - DOPAssetsCollectionViewContrller delegate

- (void) didDismissViewWith:(NSDictionary *)userdata
{
    [self dismissViewControllerAnimated:YES completion:Nil];
    [self.delegate didDismissViewWith:userdata];
}

#pragma mark - DOPImagePicker view delegate

- (void) onImagePickerTapped
{
    NSLog(@"image picker");
    //[self.navigationController pushViewController:self.assetsCollection animated:YES];
    DOPAssetsCollectionViewController *assetsCollection = [[DOPAssetsCollectionViewController alloc]
                             initWithCollectionViewLayout:[DOPAssetsCollectionViewLayout layout]];
    
    [assetsCollection setDelegate:self];
    [self  presentViewController:assetsCollection animated:YES completion:nil];
}


@end
