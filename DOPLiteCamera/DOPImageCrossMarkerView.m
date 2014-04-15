//
//  DOPImageCrossMarkerView.m
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/15.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import "DOPImageCrossMarkerView.h"

@implementation DOPImageCrossMarkerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Border
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillEllipseInRect(context, self.bounds);
    
    // Body
    CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 1.0);
    CGContextFillEllipseInRect(context, CGRectInset(self.bounds, 1.0, 1.0));
    
    // Checkmark
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextMoveToPoint(context, 3.76,3.76);
    CGContextAddLineToPoint(context, 12.24,12.24);
    CGContextMoveToPoint(context, 3.76,12.24);
    CGContextAddLineToPoint(context, 12.24,3.76);
    
    CGContextStrokePath(context);
}

@end
