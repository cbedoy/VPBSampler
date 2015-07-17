//
//  VimoParallaxViewController.h
//  VPBSampler
//
//  Created by Jesus Cagide on 7/15/15.
//  Copyright © 2015 Jesus Cagide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface VimoParallaxViewController : UIViewController

@property(nonatomic, assign) CGFloat  headerTitleHeigth;
@property(nonatomic, assign) CGFloat  blurDistance;
@property(nonatomic, assign) CGFloat  headerHeight;


-(void) setBlurMaskColor:(UIColor *)blurMaskColor;

-(void) setHeaderView:(UIView *)headerView;

@end
