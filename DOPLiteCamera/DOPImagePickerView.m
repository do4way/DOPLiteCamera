//
//  DOPImagePickerView.m
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/12.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "DOPImagePickerView.h"

@interface DOPImagePickerView ()

@property (nonatomic,strong) UIImageView *imageView;

@end


@implementation DOPImagePickerView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize size = frame.size;
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,size.width,size.height)];
        [self.imageView setContentMode: UIViewContentModeScaleAspectFill];
        self.imageView.layer.cornerRadius = size.width / 2.0;
        self.imageView.layer.masksToBounds = YES;
        [self showLatestSavedImage];
        [self setClipsToBounds:YES];
        [self addSubview:self.imageView];
        
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [tap setNumberOfTapsRequired :1 ];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void) showImage:(UIImage *)image
{
    [self.imageView setImage:image];
}

- (void) onTap:(UIGestureRecognizer *) gesture
{
    NSLog(@"tap detected");
    [self.delegate onImagePickerTapped];
}

#pragma  mark - private methods
- (void) showLatestSavedImage
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        // Chooses the photo at the last index
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            // The end of the enumeration is signaled by asset == nil.
            if (alAsset) {
                UIImage *latestPhoto = [UIImage imageWithCGImage:[alAsset thumbnail]];
                
                [self showImage:latestPhoto];
            }
        }];
    } failureBlock: ^(NSError *error) {
        NSLog(@"No groups");
    }];
}





@end
