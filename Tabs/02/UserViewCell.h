//
//  UserViewCell.h
//  HealthConnect
//
//  Created by John Nguyen on 12/22/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol UserDelegate ;
@interface UserViewCell : UITableViewCell{
    

    
}
@property (retain ,nonatomic)UIImageView *_imageView ;
@property (retain ,nonatomic)UILabel *_lbTitle ;
@property (retain ,nonatomic)UILabel *_lbDistance ;
@property (retain ,nonatomic)UITextView *_txtMyStory ;
@property (retain ,nonatomic)UILabel *_lbStatus ;
@property (retain ,nonatomic)UILabel *_lbSex ;
@property (retain ,nonatomic)UILabel *_lbAge ;
@property (nonatomic ,weak)IBOutlet id _userDelegate ;
-(void)setDataCell :(PFUser *)object Longtitude :(NSString*)longtitude Latitude :(NSString*)latitude;
-(void)UserInfoClick :(id)sender;
@end

@protocol UserDelegate
@optional
-(void)UserClick:(id)sender cell:(UserViewCell*)cell;
@end
