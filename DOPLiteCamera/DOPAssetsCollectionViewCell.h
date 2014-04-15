//
//  DOPAssetsCollectionViewCell.h
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/13.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface DOPAssetsCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) BOOL showsOverlayViewWhenSelected;

@end
