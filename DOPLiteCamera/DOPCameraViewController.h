//
//  DOPCameraViewController.h
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/11.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  DOPCameraViewControllerDelegate <NSObject>

- (void) didDismissViewWith:(NSDictionary *) userData;

@end

@interface DOPCameraViewController : UIViewController

@property (nonatomic,weak) id<DOPCameraViewControllerDelegate> delegate;

@end
