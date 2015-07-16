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
    UIScrollView *_backgroundScrollView;
    UIScrollView *_contentView;
    UIView *_headerView;
    UIView *_floatingTitleHeaderView;
    UIView *_blurMask;
    UIView *_scrollViewContainer;
    
    NSMutableArray *_headerOverlayViews;
}

@end

static CGFloat INVIS_DELTA = 50.0f;
static CGFloat BLUR_DISTANCE = 200.0f;
static CGFloat HEADER_HEIGHT = 60.0f;
static CGFloat IMAGE_HEIGHT = 320.0f;

@implementation VimoParallaxViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    _headerOverlayViews = [NSMutableArray new];

    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = YES;
    _mainScrollView.alwaysBounceVertical = YES;
    _mainScrollView.contentSize = CGSizeMake(self.view.width, 1000);
    _mainScrollView.showsVerticalScrollIndicator = YES;
    _mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mainScrollView.autoresizesSubviews = YES;
    self.view = _mainScrollView;
    
    
    _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, IMAGE_HEIGHT)];
    _backgroundScrollView.scrollEnabled = NO;
    _backgroundScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _backgroundScrollView.autoresizesSubviews = YES;
    _backgroundScrollView.contentSize = CGSizeMake(self.view.width, 1000);
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,_backgroundScrollView.width,
                                                           _backgroundScrollView.height)];
    
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_headerView setContentMode:UIViewContentModeScaleAspectFill];
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_headerView setBackgroundColor:[UIColor redColor]];
    [_backgroundScrollView addSubview:_headerView];
    
    _blurMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                         _backgroundScrollView.width,
                                                         _backgroundScrollView.height)];
    
    [_blurMask setContentMode:UIViewContentModeScaleAspectFill];
    _blurMask.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_blurMask setBackgroundColor:[UIColor grayColor]];
    
    [_blurMask setAlpha:0.0f];

    _floatingTitleHeaderView = [[UIView alloc] initWithFrame:_backgroundScrollView.frame];
    _floatingTitleHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_floatingTitleHeaderView setBackgroundColor:[UIColor blueColor]];
    [_floatingTitleHeaderView setUserInteractionEnabled:NO];
    
    [_backgroundScrollView addSubview:_blurMask];
    
    _scrollViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, _backgroundScrollView.height, self.view.width, self.view.height - [self offsetHeight] )];
    
    _scrollViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, IMAGE_HEIGHT)];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_contentView setBackgroundColor:[UIColor greenColor]];
    
    [_scrollViewContainer addSubview:_contentView];
    
    [_mainScrollView addSubview:_backgroundScrollView];
    //[_mainScrollView addSubview:_floatingTitleHeaderView];
    [_mainScrollView addSubview:_scrollViewContainer];
}

- (CGFloat)navBarHeight{
    return 20.0f;
}

- (CGFloat)offsetHeight{
    return HEADER_HEIGHT + [self navBarHeight];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat delta = 0.0f;
    CGRect rect = CGRectMake(0, 0, _scrollViewContainer.width, IMAGE_HEIGHT);
    CGFloat backgroundScrollViewLimit = _backgroundScrollView.height - [self offsetHeight];
    
    if (scrollView.contentOffset.y < 0.0f) {
        //set alfa in floating title header
        delta = fabs(MIN(0.0f, _mainScrollView.contentOffset.y + [self navBarHeight]));
        _backgroundScrollView.frame = CGRectMake(CGRectGetMinX(rect) - delta / 2.0f, CGRectGetMinY(rect) - delta, _scrollViewContainer.width + delta, CGRectGetHeight(rect) + delta);
        [_floatingTitleHeaderView setAlpha:(INVIS_DELTA - delta) / INVIS_DELTA];
        
    } else {
        delta = _mainScrollView.contentOffset.y;
        
        //set alfas
        CGFloat newAlpha = 1 - ((BLUR_DISTANCE - delta)/ BLUR_DISTANCE);
        [_blurMask setAlpha:newAlpha];
        [_floatingTitleHeaderView setAlpha:1];
        
        // Here I check whether or not the user has scrolled passed the limit where I want to stick the header, if they have then I move the frame with the scroll view
        // to give it the sticky header look
        if (delta > backgroundScrollViewLimit) {
            _backgroundScrollView.frame = (CGRect) {.origin = {0, delta - _backgroundScrollView.frame.size.height + [self offsetHeight]}, .size = {CGRectGetWidth(_scrollViewContainer.frame), IMAGE_HEIGHT}};
            _floatingTitleHeaderView.frame = (CGRect) {.origin = {0, delta - _floatingTitleHeaderView.frame.size.height + [self offsetHeight]}, .size = {CGRectGetWidth(_scrollViewContainer.frame), IMAGE_HEIGHT}};
            _scrollViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(_backgroundScrollView.frame) + CGRectGetHeight(_backgroundScrollView.frame)}, .size = _scrollViewContainer.frame.size };
            _contentView.contentOffset = CGPointMake (0, delta - backgroundScrollViewLimit);
            CGFloat contentOffsetY = -backgroundScrollViewLimit * 0.5f;
            [_backgroundScrollView setContentOffset:(CGPoint){0,contentOffsetY} animated:NO];
        }
        else {
            _backgroundScrollView.frame = rect;
            _floatingTitleHeaderView.frame = rect;
            _scrollViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(rect) + CGRectGetHeight(rect)}, .size = _scrollViewContainer.frame.size };
            [_contentView setContentOffset:(CGPoint){0,0} animated:NO];
            [_backgroundScrollView setContentOffset:CGPointMake(0, -delta * 0.5f)animated:NO];
        }
    }
}


@end
