//
//  DOPImagePosterViewController.h
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/14.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DOPImagePosterViewControllerDelegate<NSObject>

- (void) didDismissViewWith:(NSDictionary *) userData;

@end

@interface DOPImagePosterViewController : UIViewController

@property (nonatomic,weak) id<DOPImagePosterViewControllerDelegate> delegate;

- (instancetype) initWithData: (NSDictionary *) data;

@end
