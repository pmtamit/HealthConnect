//
//  StreamViewCell.m
//  HealthConnect
//
//  Created by John Nguyen on 12/10/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import "StreamViewCell.h"
#import "AppConstant.h"
@implementation StreamViewCell
@synthesize  _txtStream  ,_lbLocation ,_lbMessage  ,_cellDelegate ,_btLike ,_lbLike ,_imageView;

- (void)awakeFromNib {
    // Initialization code
    //   [self.delegate myClassDelegateMethod:self];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    common = [[Common alloc] init];
    
    CGFloat screenWidth = screenRect.size.width;
    _txtStream = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, screenWidth-10, 30)];
    _txtStream.backgroundColor = [UIColor clearColor];
    _txtStream.numberOfLines = 1000;
    _txtStream.textAlignment = NSTextAlignmentCenter;
    [_txtStream setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_txtStream];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, screenWidth-20, 30)];
    _imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageView];
    
    _txtStream.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
    [_txtStream addGestureRecognizer:tapGesture];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setData :(PFObject *)_data userId :(NSString *)userId countMess:(NSString*)mess countLike:(NSString*)like{
    
    _lbMessage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bubbleMine@2x.png"]];
    _txtStream.text = _data[PF_CHATROOMS_NAME];
    _lbMessage.text = mess ;
    _lbLocation.text =_data[PF_USER_COUNTRY];
    _lbLike.text =like;
    self.backgroundColor =[Common colorWithHexString:_data[PF_CHATROOMS_COLOR_BG]];
    _txtStream.textColor =[Common colorWithHexString:_data[PF_CHATROOMS_COLOR_TXT]];
    PFFile *photoFile  =   _data[PF_USER_PICTURE];
    UIImage *fullImage = [UIImage imageWithData:photoFile.getData];
    
    CGRect rc = [_imageView frame];
    if (photoFile != nil) {
        rc.size.height = 100;
    }else{
        rc.size.height = 40;
    }
    [_imageView setFrame:rc];
    _imageView.image = fullImage ;

}

- (NSString *)countMessage:(NSString *)groupId
{
    PFQuery *query = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
    [query whereKey:PF_CHAT_ROOMID equalTo:groupId];
    
    return  [NSString stringWithFormat:@"%ld", (long)[query countObjects]];
}
int countLike = 0 ;
- (NSString *)countLike:(NSString *)roomId
{
    PFQuery *query = [PFQuery queryWithClassName:PF_LIKE_CLASS_NAME];
    [query whereKey:PF_CHAT_ROOMID equalTo:roomId];
    return  [NSString stringWithFormat:@"%ld",(long)[query countObjects]];
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}
-(void)labelTap :(id) sender{
    
    NSLog(@"Text Action");
    if (_cellDelegate != nil && [_cellDelegate conformsToProtocol:@protocol(CellDelegate)]) {
        if ([_cellDelegate respondsToSelector:@selector(DelegateClick:cell:)]) {
            [_cellDelegate DelegateClick:sender cell:self];
        }
    }
}

-(IBAction)likeAction:(id)sender{
    NSLog(@"like action");
    if (_cellDelegate != nil && [_cellDelegate conformsToProtocol:@protocol(CellDelegate)]) {
        if ([_cellDelegate respondsToSelector:@selector(likeActionDelegate:cell:)]) {
            [_cellDelegate likeActionDelegate:sender cell:self];
        }
    }
}
-(void)setlikeValue:(NSString*)value {

    _lbLike.text = value ;
    NSLog(@"get %@",value);

}

-(IBAction)followAction:(id)sender{
    NSLog(@"Follow Action");
//    UIButton *bt = sender ;
    
    if (_cellDelegate != nil && [_cellDelegate conformsToProtocol:@protocol(CellDelegate)]) {
        if ([_cellDelegate respondsToSelector:@selector(followActionDelegate:cell:)]) {
            [_cellDelegate followActionDelegate:sender cell:self];
        }
    }
    
}

@end
