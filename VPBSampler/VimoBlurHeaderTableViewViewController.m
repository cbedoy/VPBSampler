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
    BOOL isKeyboardShowing;
}


@end

@implementation VimoBlurHeaderTableViewViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIView* view= [[NSBundle mainBundle] loadNibNamed:@"headerSample" owner:self options:nil][0];
    
    [self setHeaderView:view];
    [self setHeaderTitleHeigth:44];
    [self setBlurMaskColor:[UIColor blackColor]];
    [self setBlurDistance:44];
    [[self textField] setDelegate:self];

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
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    isKeyboardShowing = YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    isKeyboardShowing = YES;
}



- (void)killScroll
{
    CGPoint offset = self.tableView.contentOffset;
    [[self contentView] setContentOffset:offset animated:NO];
}

@end
