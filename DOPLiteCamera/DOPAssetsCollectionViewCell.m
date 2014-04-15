//
//  DOPAssetsCollectionViewCell.m
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/13.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import "DOPAssetsCollectionViewCell.h"
#import "DOPAssetsCollectionOverlayView.h"


@interface DOPAssetsCollectionViewCell ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) DOPAssetsCollectionOverlayView *overlayView;

@end

@implementation DOPAssetsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.showsOverlayViewWhenSelected = YES;
        
        // Create a image view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Show/hide overlay view
    if (selected && self.showsOverlayViewWhenSelected) {
        [self hideOverlayView];
        [self showOverlayView];
    } else {
        [self hideOverlayView];
    }
}

- (void)showOverlayView
{
    DOPAssetsCollectionOverlayView *overlayView = [[DOPAssetsCollectionOverlayView alloc] initWithFrame:self.contentView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.contentView addSubview:overlayView];
    self.overlayView = overlayView;
}

- (void)hideOverlayView
{
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
}


#pragma mark - Accessors

- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    
    // Update view
    self.imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
}

@end
