//
//  VimoBlurHeaderTableViewViewController.h
//  VPBSampler
//
//  Created by Jesus Cagide on 7/17/15.
//  Copyright © 2015 Jesus Cagide. All rights reserved.
//

#import "VimoParallaxViewController.h"

@interface VimoBlurHeaderTableViewViewController : VimoParallaxViewController<UITableViewDelegate, UITableViewDataSource>

@property (readonly) UITableView *tableView;

@end
