//
//  VimoHResizeHeaderView.h
//  VPBSampler
//
//  Created by Jesus Cagide on 7/17/15.
//  Copyright © 2015 Jesus Cagide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VimoHResizeHeaderView : UIViewController

@property(nonatomic, assign) CGFloat  headerTitleHeigth;
@property(nonatomic, assign) CGFloat  blurDistance;
@property(nonatomic, assign) CGFloat  headerHeight;
@property(nonatomic, assign) UIScrollView *contentView;

-(void) setBlurMaskColor:(UIColor *)blurMaskColor;

-(void) setHeaderView:(UIView *)headerView;

@end
