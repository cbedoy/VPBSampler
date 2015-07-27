//
//  ExampleTableViewController.m
//  VPBSampler
//
//  Created by Jesus Cagide on 7/19/15.
//  Copyright © 2015 Jesus Cagide. All rights reserved.
//

#import "ExampleTableViewController.h"

@interface ExampleTableViewController ()

@end




@implementation ExampleTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
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
