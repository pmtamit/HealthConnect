//
//  UserInfoController.h
//  HealthConnect
//
//  Created by John Nguyen on 12/24/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface UserInfoController : UIViewController
- (IBAction)BlockAction:(id)sender;
- (IBAction)ReportAction:(id)sender;
-(id)init :(PFUser *)object ;
@end
