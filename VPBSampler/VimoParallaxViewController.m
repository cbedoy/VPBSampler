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
    UIScrollView *_contentView;
    
}
@property(nonatomic, strong) UIScrollView * headerScrollView;
@property(nonatomic,strong) FXBlurView *blurMaskView;
@property(nonatomic,strong) UIView *blurColorView;
@property(nonatomic, assign) UIView * headerView;
@property(nonatomic, assign) UIView * bodyView;
@property(nonatomic,strong)UIView* scrollViewContainer;

@end

static CGFloat INVIS_DELTA = 50.0f;

@implementation VimoParallaxViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.headerTitleHeigth=100.0f;
    self.headerHeight=300.0f;
    self.blurDistance = 200.0f;
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = YES;
    _mainScrollView.alwaysBounceVertical = YES;
    //_mainScrollView.contentSize = CGSizeMake(self.view.width, 1000);
    _mainScrollView.showsVerticalScrollIndicator = YES;
    _mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mainScrollView.autoresizesSubviews = YES;
    
    [_mainScrollView setBackgroundColor:[UIColor redColor]];
    self.view = _mainScrollView;
    
    self.headerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.headerHeight)];
    self.headerScrollView.scrollEnabled = NO;
    self.headerScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.headerScrollView.autoresizesSubviews = YES;
    self.headerScrollView.contentSize = CGSizeMake(self.view.width, self.headerHeight);
    [self.headerScrollView setBackgroundColor:[UIColor blueColor]];
    
    _floatingTitleHeaderView = [[UIView alloc] initWithFrame: self.headerScrollView.frame];
    _floatingTitleHeaderView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    [_floatingTitleHeaderView setBackgroundColor:[UIColor clearColor]];
    _floatingTitleHeaderView.autoresizesSubviews = YES;
    [_floatingTitleHeaderView setUserInteractionEnabled:YES];
    
    _scrollViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0,  self.headerScrollView.height, self.view.width, self.view.height - [self offsetHeight] )];
    _scrollViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_scrollViewContainer setBackgroundColor:[UIColor greenColor]];
    _scrollViewContainer.autoresizesSubviews=YES;
    
    
    _contentView = [self contentView];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_scrollViewContainer addSubview:_contentView];
    
    [_mainScrollView addSubview: self.headerScrollView];//blue
    [_mainScrollView addSubview:_floatingTitleHeaderView];// red
    [_mainScrollView addSubview:_scrollViewContainer];//green
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_contentView setFrame:CGRectMake(0, 0, _scrollViewContainer.width, self.view.height - [self offsetHeight] )];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setNeedsScrollViewAppearanceUpdate];
}

//Important for the correct render of tableView scroll size
- (void)setNeedsScrollViewAppearanceUpdate
{
    _mainScrollView.contentSize = CGSizeMake(self.view.width, _contentView.contentSize.height + self.headerScrollView.height);
}

- (UIScrollView*)contentView{
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    contentView.scrollEnabled = NO;
    return contentView;
}

- (CGFloat)horizontalOffset{
    return 15.0f;
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
    CGRect rect = CGRectMake(0, 0, _scrollViewContainer.width, self.headerHeight);
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
        CGFloat newAlpha = 1 - ((self.blurDistance - delta)/ self.blurDistance);
        [self.blurMaskView setAlpha:newAlpha];
        [_floatingTitleHeaderView setAlpha:1];
        [self stickHeaderViewInBaseOf:delta andBackgroundViewLimit:backgroundScrollViewLimit];
    }
}

// Here I check whether or not the user has scrolled passed the limit where I want to stick the header, if they have then I move the frame with the scroll view
// to give it the sticky header look
-(void) stickHeaderViewInBaseOf:(float)delta andBackgroundViewLimit:(float)backgroundScrollViewLimit
{
    CGRect rect = CGRectMake(0, 0, _scrollViewContainer.width, self.headerHeight);
    if (delta > backgroundScrollViewLimit) {
        
         self.headerScrollView.frame = (CGRect) {.origin = {0, delta -  self.headerScrollView.height + [self offsetHeight]},
                                                 .size = {_scrollViewContainer.width, self.headerHeight}};
        
        _floatingTitleHeaderView.frame = (CGRect) {.origin = {0, delta - _floatingTitleHeaderView.height + [self offsetHeight]},
                                                   .size = {_scrollViewContainer.width, self.headerHeight}};
        
        _scrollViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY( self.headerScrollView.frame) +  self.headerScrollView.height},
                                              .size = _scrollViewContainer.frame.size };
        
        _contentView.contentOffset = CGPointMake (0, delta - backgroundScrollViewLimit);
        
        CGFloat contentOffsetY = -backgroundScrollViewLimit * 0.5f;
        
        [ self.headerScrollView setContentOffset:(CGPoint){0,contentOffsetY} animated:NO];
    }
    else {
         self.headerScrollView.frame = rect;
        _floatingTitleHeaderView.frame = rect;
        _scrollViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(rect) + CGRectGetHeight(rect)}, .size = _scrollViewContainer.frame.size };
        [_contentView setContentOffset:(CGPoint){0,0} animated:NO];
        [ self.headerScrollView setContentOffset:CGPointMake(0, -delta * 0.5f)animated:NO];
    }
}


-(void) setBlurMaskColor:(UIColor *)blurMaskColor
{
    [self.blurColorView setBackgroundColor:blurMaskColor];
}



-(void) setHeaderView:(UIView *)headerView
{
    _headerView= headerView;
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.headerView.autoresizesSubviews= YES;
    
    [self.headerView setWidth:_floatingTitleHeaderView.width];
    [self.headerView setHeight:_floatingTitleHeaderView.height];
    
    self.blurMaskView = [[FXBlurView alloc] initWithFrame:self.headerView.frame];
    
    self.blurColorView = [UIView new];
    [self.blurColorView setContentMode:UIViewContentModeScaleAspectFill];
    self.blurColorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.blurColorView setOrigin:CGPointMake(0, 0) size:self.blurMaskView.size];
    [self.blurColorView setBackgroundColor:[UIColor blackColor]];
    [self.blurColorView setAlpha:0.2];
    
    [self.blurMaskView setContentMode:UIViewContentModeScaleAspectFill];
    self.blurMaskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.blurMaskView.autoresizesSubviews = YES;
    [self.blurMaskView setAlpha:0.0f];
    [self.blurMaskView setBlurEnabled:YES];
    [self.blurMaskView setBlurRadius:20];
    [self.blurMaskView setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [self.blurMaskView addSubview:self.blurColorView];
    
    [_floatingTitleHeaderView addSubview:self.headerView];
    [_floatingTitleHeaderView insertSubview:self.blurMaskView aboveSubview:self.headerView];
    [self.headerScrollView setAutoresizesSubviews:YES];
    
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, [self headerHeight] - 44, self.view.frame.size.width, 44)];
    [self.textField setBackgroundColor:[UIColor whiteColor]];
    [self.textField setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [self.textField setPlaceholder:@"Hello I'm a the headerLabel"];

    [self.textField setUserInteractionEnabled:YES];

    
    [_floatingTitleHeaderView insertSubview:self.textField aboveSubview:self.blurMaskView];
    [_floatingTitleHeaderView setUserInteractionEnabled:YES];
}

@end
