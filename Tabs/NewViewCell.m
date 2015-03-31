//
//  NewViewCell.m
//  HealthConnect
//
//  Created by John Nguyen on 12/10/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import "NewViewCell.h"
#import <Parse/Parse.h>
#import "AppConstant.h"
@interface NewViewCell()
{
    PFObject *_newObject;
}


@end
@implementation NewViewCell
@synthesize _txtContentNewCell , _txtTitleNewCell  ;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)LoadData:(PFObject *)object{
        _newObject = object;
       _txtTitleNewCell.text =_newObject[PF_CLASS_NEW_HEADER];
       _txtContentNewCell.text =_newObject[PF_CLASS_NEW_CONTENT];
  
}
@end
