//
//  DOPImagePickerView.h
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/12.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DOPImagePickerDelegate <NSObject>

- (void) onImagePickerTapped;

@end

@interface DOPImagePickerView : UIView

@property (nonatomic,weak) id<DOPImagePickerDelegate> delegate;

- (void) showImage:(UIImage *) image;

@end
