//
//  VimoParallaxViewController.m
//  VPBSampler
//
//  Created by Jesus Cagide on 7/15/15.
//  Copyright © 2015 Jesus Cagide. All rights reserved.
//

#import "VimoParallaxViewController.h"
#import "FXBlurView.h"
#import "UIView+Utilities.h"

@interface VimoParallaxViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_mainScrollView;
    
    UIView *_floatingTitleHeaderView;
    FXBlurView *_blurMask;
    
    UIView *_scrollViewContainer;

}
@property(nonatomic, strong) UIScrollView * headerScrollView;
@property(nonatomic, assign) CGFloat  headerTitleHeigth;

@end

static CGFloat INVIS_DELTA = 50.0f;
static CGFloat BLUR_DISTANCE = 200.0f;
static CGFloat IMAGE_HEIGHT = 300.0f;

@implementation VimoParallaxViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.headerTitleHeigth=100.0f;
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = YES;
    _mainScrollView.alwaysBounceVertical = YES;
    _mainScrollView.contentSize = CGSizeMake(self.view.width, 1000);
    _mainScrollView.showsVerticalScrollIndicator = YES;
    _mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mainScrollView.autoresizesSubviews = YES;
    
    [_mainScrollView setBackgroundColor:[UIColor redColor]];
    self.view = _mainScrollView;
    
    self.headerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, IMAGE_HEIGHT)];
    self.headerScrollView.scrollEnabled = NO;
    self.headerScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.headerScrollView.autoresizesSubviews = YES;
    //self.headerScrollView.contentSize = CGSizeMake(self.view.width, IMAGE_HEIGHT);
    [self.headerScrollView setBackgroundColor:[UIColor blueColor]];
    
    _floatingTitleHeaderView = [[UIView alloc] initWithFrame: self.headerScrollView.frame];
    _floatingTitleHeaderView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [_floatingTitleHeaderView setBackgroundColor:[UIColor clearColor]];
    _floatingTitleHeaderView.autoresizesSubviews = YES;
    [_floatingTitleHeaderView setUserInteractionEnabled:NO];
    
    _scrollViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0,  self.headerScrollView.height, self.view.width, self.view.height - [self offsetHeight] )];
    _scrollViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_scrollViewContainer setBackgroundColor:[UIColor greenColor]];
    _scrollViewContainer.autoresizesSubviews=YES;
    
    
    
    UIView* myview= [[NSBundle mainBundle] loadNibNamed:@"headerSample" owner:self options:nil][0];
    myview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myview.autoresizesSubviews= YES;
    
    UILabel* _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([self horizontalOffset], [self headerHeight] - 50, self.view.frame.size.width - 15 - [self horizontalOffset], 25)];
    [_titleLabel setBackgroundColor:[UIColor redColor]];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [_titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    
    [_titleLabel setText:@"Hello I'm a table"];
    
    [myview setWidth:_floatingTitleHeaderView.width];
    [myview setHeight:_floatingTitleHeaderView.height];
    _blurMask = [[FXBlurView alloc] initWithFrame:myview.frame];
    
    UIView * blurColorMask = [UIView new];
    [blurColorMask setContentMode:UIViewContentModeScaleAspectFill];
    blurColorMask.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [blurColorMask setOrigin:CGPointMake(0, 0) size:_blurMask.size];
    [blurColorMask setBackgroundColor:[UIColor blackColor]];
    [blurColorMask setAlpha:0.2];
   
    [_blurMask setContentMode:UIViewContentModeScaleAspectFill];
    _blurMask.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _blurMask.autoresizesSubviews = YES;
    [_blurMask setAlpha:0.0f];
    [_blurMask setBlurEnabled:YES];
    [_blurMask setBlurRadius:10];
    [_blurMask setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [_blurMask addSubview:blurColorMask];
    
    
    [_floatingTitleHeaderView addSubview:myview];
    [_floatingTitleHeaderView insertSubview:_blurMask aboveSubview:myview];
    [self.headerScrollView setAutoresizesSubviews:YES];
    
    [_mainScrollView addSubview: self.headerScrollView];//blue
    [_mainScrollView addSubview:_floatingTitleHeaderView];// red
    //[_mainScrollView addSubview:_scrollViewContainer];//green
}

- (CGFloat)horizontalOffset{
    return 15.0f;
}


- (CGFloat)headerHeight{
    return self.headerScrollView.height;
}

- (CGFloat)navBarHeight{
    if (self.navigationController && !self.navigationController.navigationBarHidden && self.navigationController.navigationBar.translucent) {
        return self.navigationController.navigationBar.height + 20;
    }
    return 0.0f;
}

- (CGFloat)offsetHeight{
    return self.headerTitleHeigth + [self navBarHeight];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat delta = 0.0f;
    CGRect rect = CGRectMake(0, 0, _scrollViewContainer.width, IMAGE_HEIGHT);
    CGFloat backgroundScrollViewLimit =  self.headerScrollView.height - [self offsetHeight];
    
    if (scrollView.contentOffset.y < 0.0f) {
       
        //set alfa in floating title header
        delta = fabs(MIN(0.0f, _mainScrollView.contentOffset.y + [self navBarHeight]));
        //set big the header view 
         self.headerScrollView.frame = CGRectMake(CGRectGetMinX(rect) - delta / 2.0f, CGRectGetMinY(rect) - delta, _scrollViewContainer.width + delta, CGRectGetHeight(rect) + delta);
        //[_floatingTitleHeaderView setAlpha:(INVIS_DELTA - delta) / INVIS_DELTA];
    } else {
        delta = _mainScrollView.contentOffset.y;
        //set alfas
        CGFloat newAlpha = 1 - ((BLUR_DISTANCE - delta)/ BLUR_DISTANCE);
        [_blurMask setAlpha:newAlpha];
        [_floatingTitleHeaderView setAlpha:1];
        [self stickHeaderViewInBaseOf:delta andBackgroundViewLimit:backgroundScrollViewLimit];
    }
}

// Here I check whether or not the user has scrolled passed the limit where I want to stick the header, if they have then I move the frame with the scroll view
// to give it the sticky header look
-(void) stickHeaderViewInBaseOf:(float)delta andBackgroundViewLimit:(float)backgroundScrollViewLimit
{
    CGRect rect = CGRectMake(0, 0, _scrollViewContainer.width, IMAGE_HEIGHT);
    if (delta > backgroundScrollViewLimit) {
        
         self.headerScrollView.frame = (CGRect) {.origin = {0, delta -  self.headerScrollView.height + [self offsetHeight]},
                                                 .size = {_scrollViewContainer.width, IMAGE_HEIGHT}};
        
        _floatingTitleHeaderView.frame = (CGRect) {.origin = {0, delta - _floatingTitleHeaderView.height + [self offsetHeight]},
                                                   .size = {_scrollViewContainer.width, IMAGE_HEIGHT}};
        
        _scrollViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY( self.headerScrollView.frame) +  self.headerScrollView.height},
                                              .size = _scrollViewContainer.frame.size };
        
        //_contentView.contentOffset = CGPointMake (0, delta - backgroundScrollViewLimit);
        
        CGFloat contentOffsetY = -backgroundScrollViewLimit * 0.5f;
        [ self.headerScrollView setContentOffset:(CGPoint){0,contentOffsetY} animated:NO];
    }
    else {
         self.headerScrollView.frame = rect;
        _floatingTitleHeaderView.frame = rect;
        _scrollViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(rect) + CGRectGetHeight(rect)}, .size = _scrollViewContainer.frame.size };
        //[_contentView setContentOffset:(CGPoint){0,0} animated:NO];
        [ self.headerScrollView setContentOffset:CGPointMake(0, -delta * 0.5f)animated:NO];
    }
}

@end
