//
//  UserViewCell.m
//  HealthConnect
//
//  Created by John Nguyen on 12/22/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import "UserViewCell.h"
#import "AppConstant.h"
#import <Parse/Parse.h>

#import "ProgressHUD.h"
#import "camera.h"
#import "messages.h"
#import "pushnotification.h"
#import "ChatView.h"


@implementation UserViewCell
@synthesize _lbTitle ,_lbAge ,_lbSex ,_lbStatus,_txtMyStory,_lbDistance ,_imageView ,_userDelegate;
- (void)awakeFromNib {
    // Initialization code
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGFloat screenWidth = screenRect.size.width;
    
    //create imageView
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 70)];
    _imageView.backgroundColor = [UIColor grayColor];
   
    [self addSubview:_imageView];
    
    _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(70 , 0, 150, 30)];
    _lbTitle.backgroundColor = [UIColor clearColor];
    _lbTitle.numberOfLines = 0;
    _lbTitle.textAlignment = NSTextAlignmentLeft;
    [_lbTitle setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_lbTitle];
    
    
    _lbDistance = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-105, 0, 100, 30)];
    _lbDistance.backgroundColor = [UIColor clearColor];
    _lbDistance.numberOfLines = 0;
    _lbDistance.textAlignment = NSTextAlignmentRight;
    [_lbDistance setFont:[UIFont systemFontOfSize:14]];
    
    [self addSubview:_lbDistance];
    _txtMyStory = [[UITextView alloc] initWithFrame:CGRectMake(70, 22, screenWidth-80, 60)];
    _txtMyStory.backgroundColor = [UIColor clearColor];

    _txtMyStory.textAlignment = NSTextAlignmentLeft;
    [_txtMyStory setFont:[UIFont systemFontOfSize:14]];
    _txtMyStory.editable = NO;
    _txtMyStory.selectable = NO ;
    
    _txtMyStory.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UserInfoClick:)];
    [_txtMyStory addGestureRecognizer:tapGesture];
    
    
    [self addSubview:_txtMyStory];
    _lbStatus = [[UILabel alloc] initWithFrame:CGRectMake(70, 75, 100, 30)];
    _lbStatus.backgroundColor = [UIColor clearColor];
    _lbStatus.numberOfLines = 0;
    _lbStatus.textAlignment = NSTextAlignmentLeft;
    _lbStatus.text = @"Status:Chat";
    [_lbStatus setFont:[UIFont systemFontOfSize:14]];
    
    [self addSubview:_lbStatus];
    _lbSex = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-5, 75, 80, 30)];
    _lbSex.backgroundColor = [UIColor clearColor];
    _lbSex.numberOfLines = 0;
    _lbSex.textAlignment = NSTextAlignmentLeft;
    [_lbSex setFont:[UIFont systemFontOfSize:14]];
    
    [self addSubview:_lbSex];
    _lbAge = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-80, 75, 90, 30)];
    _lbAge.backgroundColor = [UIColor clearColor];
    _lbAge.numberOfLines = 0;
    _lbAge.textAlignment = NSTextAlignmentLeft;
    _lbAge.text = @"Age:30";
    [_lbAge setFont:[UIFont systemFontOfSize:14]];
    
    [self addSubview:_lbAge];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)UserInfoClick :(id)sender{
    if (_userDelegate != nil && [_userDelegate conformsToProtocol:@protocol(UserDelegate)]) {
        if ([_userDelegate respondsToSelector:@selector(UserClick:cell:)]) {
            [_userDelegate UserClick:sender cell:self];
        }
    }
}

-(void)setDataCell :(PFUser *)object Longtitude :(NSString*)_longtitude Latitude :(NSString*)_latitude{
    _lbTitle.text =[NSString stringWithFormat:@"UserName : %@" ,object[PF_USER_PROFILE]];
      _lbDistance.text =object[PF_USER_COUNTRY];
    _txtMyStory.text =object[PF_USER_MYSTORY];
  
    _lbSex.text =object[PF_USER_SEX];
    _lbAge.text=object[PF_USER_BIRTHDATE];
    
    PFFile *fileThumbnail = object[PF_USER_PICTURE];
    if (fileThumbnail != nil) {
        
        [fileThumbnail getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             if (error == nil)
             {
                  _imageView.image  = [UIImage imageWithData:imageData];
                 
             }
         }];
    }
}
@end
