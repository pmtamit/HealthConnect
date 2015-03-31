//
//  UserCommon.h
//  HealthConnect
//
//  Created by John Nguyen on 1/24/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface UserCommon : NSObject
-(void)BlockUser :(PFUser*)userBlock :(PFUser*)user;
@end
