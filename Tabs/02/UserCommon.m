//
//  UserCommon.m
//  HealthConnect
//
//  Created by John Nguyen on 1/24/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//

#import "UserCommon.h"
#import "AppConstant.h"
#import "ProgressHUD.h"
@implementation UserCommon
-(void)BlockUser :(PFUser*)userBlock :(PFUser*)userUnLock{
    PFQuery *query = [PFQuery queryWithClassName:PF_CLASS_BLOCK];
    [query whereKey:PF_CLASS_USER_LOCK equalTo:userBlock.objectId];
    [query whereKey:PF_CLASS_USER_BLOCK equalTo:userUnLock.objectId];
    if ([query countObjects]==0) {
        PFObject *object = [PFObject objectWithClassName:PF_CLASS_BLOCK];
        object[PF_CLASS_USER_LOCK] = userBlock.objectId;
        object[PF_CLASS_USER_BLOCK] = userUnLock.objectId;
        
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error == nil)
             {
                 [ProgressHUD showSuccess:@"Blok user"];
             }
             else [ProgressHUD showError:@"Network error."];
         }];

    }
}
@end
