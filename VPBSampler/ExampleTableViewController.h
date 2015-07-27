//
//  ExampleTableViewController.h
//  VPBSampler
//
//  Created by Jesus Cagide on 7/19/15.
//  Copyright © 2015 Jesus Cagide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExampleTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UITableView* table;

@end
