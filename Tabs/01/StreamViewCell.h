//
//  StreamViewCell.h
//  HealthConnect
//
//  Created by John Nguyen on 12/10/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Common.h"
@protocol CellDelegate ;

@interface StreamViewCell : UITableViewCell <UITextViewDelegate>{
    Common *common ;

}
@property (retain, nonatomic) UILabel *_txtStream;
@property (retain, nonatomic)IBOutlet UIButton *_btLike;
@property (weak, nonatomic) IBOutlet UILabel *_lbLike;
@property (weak, nonatomic) IBOutlet UILabel *_lbMessage;
@property (weak, nonatomic) IBOutlet UILabel *_lbLocation;
@property (retain, nonatomic) IBOutlet UIImageView *_imageView;
-(void)setData :(PFObject *)_data userId :(NSString *)userId countMess:(NSString*)mess countLike:(NSString*)like;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)setlikeValue:(NSString*)value ;
-(IBAction)likeAction:(id)sender ;
-(IBAction)followAction:(id)sender ;

@property (nonatomic ,weak)IBOutlet id _cellDelegate ;
@end
@protocol CellDelegate

@optional
-(void)DelegateClick:(id)sender cell:(StreamViewCell*)cell;
-(void)likeActionDelegate :(id) sender cell :(StreamViewCell *)cell ;
-(void)followActionDelegate :(id) sender cell :(StreamViewCell * )cell ;
@end