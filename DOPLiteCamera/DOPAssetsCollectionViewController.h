//
//  DOPAssetsCollectionViewController.h
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/13.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define DOP_ASSETS_LIBRARY_SELECTED_DATA_KEY_FOR_PHOTOURLS @"photoUrls"

@protocol DOPAssetsCollectionViewControllerDelegate <NSObject>

- (void) didDismissViewWith:(NSDictionary *) userdata;

@end

@interface DOPAssetsCollectionViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
@property (nonatomic, weak) id<DOPAssetsCollectionViewControllerDelegate> delegate;

@end
