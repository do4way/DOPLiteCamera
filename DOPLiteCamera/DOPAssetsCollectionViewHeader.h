//
//  DOPAssetsCollectionViewHeader.h
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/14.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DOPAssetsCollectionHeaderDelegate <NSObject>

- (void) selectionCanceled;
- (void) selectionDone;

@end

@interface DOPAssetsCollectionViewHeader : UICollectionReusableView

@property (nonatomic,weak) id<DOPAssetsCollectionHeaderDelegate> delegate;
@end
