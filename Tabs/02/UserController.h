//
//  UserController.h
//  HealthConnect
//
//  Created by John Nguyen on 12/22/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "FilterDelegate.h"
@interface UserController : UIViewController <UITableViewDataSource ,UITableViewDelegate ,UISearchBarDelegate ,UserDelegate, FilterDelegate>{

    NSString *     longitude ;
    NSString *    latitude ;
}
@property (retain ,nonatomic)IBOutlet UITableView * _tableView ;
@property (retain ,nonatomic)IBOutlet UISearchBar * searchBar ;
@end
