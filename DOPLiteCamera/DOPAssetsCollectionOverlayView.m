//
//  DOPAssetsCollectionOverlayView.m
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/13.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import "DOPAssetsCollectionOverlayView.h"
#import "DOPAssetsCollectionOverlayCheckmarkView.h"

@interface DOPAssetsCollectionOverlayView ()

@property (nonatomic,strong) DOPAssetsCollectionOverlayCheckmarkView *checkmarkView;

@end

@implementation DOPAssetsCollectionOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // View settings
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        
        // Create a checkmark view
        DOPAssetsCollectionOverlayCheckmarkView *checkmarkView = [[DOPAssetsCollectionOverlayCheckmarkView alloc]
                                                                  initWithFrame:CGRectMake(self.bounds.size.width - (4.0 + 24.0),
                                                                                           self.bounds.size.height - (4.0 + 24.0),
                                                                                           24.0,
                                                                                           24.0)];
        checkmarkView.autoresizingMask = UIViewAutoresizingNone;
        
        checkmarkView.layer.shadowColor = [[UIColor grayColor] CGColor];
        checkmarkView.layer.shadowOffset = CGSizeMake(0, 0);
        checkmarkView.layer.shadowOpacity = 0.6;
        checkmarkView.layer.shadowRadius = 2.0;
        
        [self addSubview:checkmarkView];
        self.checkmarkView = checkmarkView;
    }
    
    return self;
}


@end
