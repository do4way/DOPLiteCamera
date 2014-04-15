//
//  DOPCameraFocusSquare.m
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/12.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import "DOPCameraFocusSquare.h"

@implementation DOPCameraFocusSquare

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setBorderWidth:2.0];
        [self.layer setCornerRadius:4.0];
        [self.layer setBorderColor:[UIColor whiteColor].CGColor];
        CAShapeLayer *line = [CAShapeLayer layer];
        UIBezierPath *linePath=[UIBezierPath bezierPath];
        CGFloat x = frame.size.width/2.0;
        CGFloat y = frame.size.width/2.0;
        [linePath moveToPoint: CGPointMake(0,y)];
        [linePath addLineToPoint: CGPointMake(10.0,y)];
        [linePath moveToPoint: CGPointMake(x, 0)];
        [linePath addLineToPoint: CGPointMake(x,10.0)];
        [linePath moveToPoint: CGPointMake(frame.size.width, y)];
        [linePath addLineToPoint: CGPointMake(frame.size.width-10,y)];
        [linePath moveToPoint: CGPointMake(x, frame.size.height)];
        [linePath addLineToPoint: CGPointMake(x,frame.size.height - 10)];
        line.path=linePath.CGPath;
        line.lineWidth = 2.0;
        line.fillColor = nil;
        line.opacity = 1.0;
        line.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:line];
        
        
        CABasicAnimation* selectionAnimation = [CABasicAnimation
                                                animationWithKeyPath:@"borderColor"];
        CABasicAnimation* lineAnimation = [CABasicAnimation
                                                animationWithKeyPath:@"strokeColor"];
        lineAnimation.toValue = (id) [UIColor yellowColor].CGColor;
        lineAnimation.repeatCount = 8;
        selectionAnimation.toValue = (id)[UIColor yellowColor].CGColor;
        selectionAnimation.repeatCount = 8;
        [self.layer addAnimation:selectionAnimation
                          forKey:@"selectionAnimation"];
        [line addAnimation:lineAnimation forKey:@"lineAnimation"];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
