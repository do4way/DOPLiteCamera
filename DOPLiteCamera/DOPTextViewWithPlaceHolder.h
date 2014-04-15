//
//  DOPTextViewWithPlaceHolder.h
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/15.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOPTextViewWithPlaceHolder : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
