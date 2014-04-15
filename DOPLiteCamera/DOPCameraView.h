//
//  DOPCameraView.h
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/11.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DOPCameraDelegate <NSObject>

@optional

-(void) didImageSaved:(UIImage *) image;

@end

@interface DOPCameraView : UIView

@property (nonatomic, weak) id<DOPCameraDelegate> delegate;

- (void) autoFocus;
- (void) takePhoto: (id) sender;

@end
