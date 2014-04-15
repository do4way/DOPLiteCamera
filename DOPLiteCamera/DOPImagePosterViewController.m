//
//  DOPImagePosterViewController.m
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/14.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import "DOPImagePosterViewController.h"
#import <UIView+AutoLayout.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DOPImageCrossMarkerView.h"
#import "DOPTextViewWithPlaceHolder.h"

static CGFloat const PHOTO_WIDTH = 103.0;
static CGFloat const TOOLBAR_HEIGHT = 60.0;
static CGFloat const COMMENT_TEXT_MARGHIN_RELATED_TOP = 10.0;
static CGFloat const COMMENT_TEXT_HEIGHT = 100.0;
static CGFloat const PHOTOS_MARGIN_RELATED_TOP = 10.0;
static CGFloat const PHOTOS_CELL_PADDING = 10.0;
static NSInteger const PHOTO_PER_ROW = 3;
static CGFloat const COMPS_MARGIN_LEFT = 10;
static CGFloat const COMPS_MARGIN_RIGHT = 10;


@interface DOPImagePosterViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) NSArray *photoUrls;
@property (nonatomic, strong) UIView  *photos;
@property (nonatomic, strong) NSMutableArray *photoViews;
@property (nonatomic, strong) UIImageView *addImage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (nonatomic, assign) BOOL didUpdateConstraints;
@property (nonatomic, strong) DOPTextViewWithPlaceHolder *comment;

@end

@implementation DOPImagePosterViewController

- (instancetype) initWithData:(NSDictionary *) data
{
    if ( self = [super init]) {
        
        self.photoUrls = [data objectForKey:@"photoUrls"];
        self.photoViews = [[NSMutableArray alloc] initWithCapacity:[self.photoUrls count]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initToolbar];
    self.comment = [DOPTextViewWithPlaceHolder newAutoLayoutView];
    [self.comment setPlaceholder:NSLocalizedStringFromTable(@"CommentPlaceHolder",
                                                            @"DOPLiteCamera",
                                                            Nil)];
    self.photos = [[UIView alloc]
                   initWithFrame:CGRectMake(0,0,
                                            [self photosWidth],
                                            PHOTO_WIDTH + PHOTOS_CELL_PADDING * 2)];
    self.scrollView = [[UIScrollView alloc]
                       initWithFrame:[self scrollViewRect]];
    
    //disable scroll indicator style, via set white style in white background
    [self.scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [self.scrollView addSubview:self.photos];
    [self.view addSubview:self.comment];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = self.photos.bounds.size;
    [self initImageViewer];
    
    UIImage *addPhotoImg = [UIImage imageNamed:@"addPhoto"];
    self.addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addPhotoBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.addPhotoBtn setImage:addPhotoImg forState: UIControlStateNormal];
    [self.addPhotoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchDown];
    
    [self.photos addSubview:self.addPhotoBtn];

    if ([self.photoUrls count] > 2) {
        self.scrollView.contentOffset = CGPointMake(50,0);
    }
    
	// Do any additional setup after loading the view.
}

- (void) updateViewConstraints
{
    [super updateViewConstraints];
    if (self.didUpdateConstraints) return;
    [self.toolbar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.toolbar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.toolbar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.toolbar autoSetDimension:ALDimensionHeight toSize:TOOLBAR_HEIGHT];
    
    [self.comment autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.toolbar withOffset:COMMENT_TEXT_MARGHIN_RELATED_TOP];
    [self.comment autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:COMPS_MARGIN_LEFT];
    [self.comment autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:COMPS_MARGIN_RIGHT];
    [self.comment autoSetDimension:ALDimensionHeight toSize:COMMENT_TEXT_HEIGHT];
    
    [self updatePhotoViewsConstraints];
    self.didUpdateConstraints = YES;
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - user interactive method

- (void) doPost
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [data setObject:self.comment.text forKey:@"ownerComment"];
    [data setObject:self.photoUrls forKey:@"photoUrls"];
    NSLog(@"delegate:%@",self.delegate);
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate didDismissViewWith:data];
    }];
}

- (void) doCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) addPhoto
{
    
}

#pragma mark - private methods
- (void) initToolbar
{
    self.toolbar = [UIToolbar newAutoLayoutView];
    NSString *cancel = NSLocalizedStringFromTable(@"Cancel", @"DOPLiteCamera", Nil);
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                                  initWithTitle:cancel
                                          style:UIBarButtonItemStylePlain
                                         target:self action:@selector(doCancel)];
    [cancelBtn setTintColor:[UIColor whiteColor]];
    NSString *post = NSLocalizedStringFromTable(@"Post", @"DOPLiteCamera", Nil);
    UIBarButtonItem *postBtn = [[UIBarButtonItem alloc] initWithTitle:post
                                                                style:UIBarButtonItemStylePlain
                                                               target:self action:@selector(doPost)];
    [postBtn setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:Nil
                                                                                   action:Nil];
    self.toolbar.items = @[cancelBtn,flexibleSpace,postBtn];
    
    [self.toolbar setBarStyle:UIBarStyleBlackOpaque];
    [self.view addSubview:self.toolbar];
}

- (void) initImageViewer
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    
    for (NSInteger idx=0,len=[self.photoUrls count]; idx<len; idx++ ) {
        __block UIImageView *imageView = [UIImageView newAutoLayoutView];
        DOPImageCrossMarkerView *crossMarker = [[DOPImageCrossMarkerView alloc]initWithFrame:CGRectMake(-8,-8, 16,16)];
        [imageView addSubview:crossMarker];
        [imageView setTag:idx];
        [self.photoViews addObject:imageView];
        [self.photos addSubview:imageView];
        [library assetForURL:self.photoUrls[idx]
                 resultBlock:^(ALAsset *asset) {
                     
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
                imageView.image = image;
            }
        }
                failureBlock:^(NSError *error) {
                    
            NSLog(@"faile to load image from : %@", error);
        }];
    }
    
}

- (void) updatePhotoViewsConstraints
{
    CGFloat width = PHOTO_WIDTH;
    for (NSInteger idx=0, len=[self.photoViews count];idx<len;idx++) {
        
        UIImageView *view = [self.photoViews objectAtIndex:idx];
        CGFloat x = idx * (width + PHOTOS_CELL_PADDING) + PHOTOS_CELL_PADDING;
        CGFloat y = PHOTOS_CELL_PADDING;
        [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:y];
        [view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:x];
        [view autoSetDimension:ALDimensionHeight toSize:width];
        [view autoSetDimension:ALDimensionWidth toSize:width];
        
    }
    
    CGFloat left = [self.photoUrls count] * (width + PHOTOS_CELL_PADDING) + PHOTOS_CELL_PADDING;
    [self.addPhotoBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:PHOTOS_CELL_PADDING];
    [self.addPhotoBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:left];
    [self.addPhotoBtn autoSetDimension:ALDimensionWidth toSize:width];
    [self.addPhotoBtn autoSetDimension:ALDimensionHeight toSize:width];
}

- (CGRect) scrollViewRect
{
    return (CGRect) {
        .origin.x = 0,
        .origin.y = 180,
        .size.width = [self currentDeviceSizeDependsOnOrientation].width,
        .size.height = PHOTO_WIDTH + PHOTOS_CELL_PADDING * 2
    };
}

- (CGSize) currentDeviceSizeDependsOnOrientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ( UIDeviceOrientationIsLandscape(orientation) ) {
        return (CGSize) {
            .width = size.height,
            .height = size.width
        };
    }
    return size;
    
}


- (CGFloat) photosWidth
{
    return ([self.photoUrls count] + 1) * (PHOTOS_CELL_PADDING + PHOTO_WIDTH);
}
@end
