//
//  UserImage.h
//  HealthConnect
//
//  Created by John Nguyen on 1/3/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface UserImage : UIViewController
-(id)init :(PFUser *)user;
@end
