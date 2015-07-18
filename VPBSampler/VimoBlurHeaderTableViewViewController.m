//
//  VimoBlurHeaderTableViewViewController.m
//  VPBSampler
//
//  Created by Jesus Cagide on 7/17/15.
//  Copyright © 2015 Jesus Cagide. All rights reserved.
//

#import "VimoBlurHeaderTableViewViewController.h"
#import "UIView+Utilities.h"

@interface VimoBlurHeaderTableViewViewController (){
    UITableView *_tableView;
}


@end

@implementation VimoBlurHeaderTableViewViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIView* view= [[NSBundle mainBundle] loadNibNamed:@"headerSample" owner:self options:nil][0];
    
    [self setHeaderView:view];
    [self setHeaderTitleHeigth:100];
    [self setBlurMaskColor:[UIColor blackColor]];
    [self setBlurDistance:100];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIScrollView *)contentView{
    return [self tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.text = @"Override me";
    cell.detailTextLabel.text = @"Please...";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
