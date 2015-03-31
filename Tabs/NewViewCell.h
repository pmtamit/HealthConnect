//
//  NewViewCell.h
//  HealthConnect
//
//  Created by John Nguyen on 12/10/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface NewViewCell : UITableViewCell
{}
@property (weak, nonatomic) IBOutlet UILabel *_txtTitleNewCell;
@property (weak, nonatomic) IBOutlet UILabel *_txtContentNewCell;
- (void)LoadData:(PFObject *)object;
@end
