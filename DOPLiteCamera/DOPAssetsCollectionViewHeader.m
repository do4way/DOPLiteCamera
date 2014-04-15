//
//  DOPAssetsCollectionViewHeader.m
//  DOPLiteCamera
//
//  Created by Yongwei Dou on 2014/04/14.
//  Copyright (c) 2014年 DODOPIPE LIMITED. All rights reserved.
//

#import "DOPAssetsCollectionViewHeader.h"
#import <UIView+AutoLayout.h>

@interface DOPAssetsCollectionViewHeader ()

@property (nonatomic,strong) UIToolbar *toolbar;
@end
@implementation DOPAssetsCollectionViewHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.toolbar = [UIToolbar newAutoLayoutView];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        NSString *cancel = NSLocalizedStringFromTable(@"Cancel", @"DOPLiteCamera", Nil);
        NSString *use = NSLocalizedStringFromTable(@"Use Photos", @"DOPLiteCamera", Nil);
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:cancel style:UIBarButtonItemStyleBordered target:self action:@selector(doCancel)];
        [cancelBtn setTintColor:[UIColor whiteColor]];
        UIBarButtonItem *useBtn = [[UIBarButtonItem alloc]initWithTitle:use style:UIBarButtonItemStyleBordered target:self action:@selector(doUse)];
        [useBtn setTintColor:[UIColor whiteColor]];
        UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.toolbar.items = @[cancelBtn,flexibleSpace,flexibleSpace,flexibleSpace,useBtn];
        [self addSubview:self.toolbar];
        [self.toolbar setBarStyle:UIBarStyleBlackOpaque];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void) updateConstraints
{
    [super updateConstraints];
    [self.toolbar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.toolbar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.toolbar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.toolbar autoSetDimension:ALDimensionHeight toSize:60];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) doCancel
{
    
    [self.delegate selectionCanceled];
}

- (void) doUse
{
    
    [self.delegate selectionDone];
}
@end
