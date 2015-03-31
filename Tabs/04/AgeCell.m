//
//  AgeCell.m
//  HealthConnect
//
//  Created by John Nguyen on 2/28/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//

#import "AgeCell.h"

@implementation AgeCell
@synthesize title ,_ageDelegate;
- (void)awakeFromNib {
    // Initialization code
    title.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AgeClick:)];
    [title addGestureRecognizer:tapGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData :(NSString *)_age {

    title.text =_age ;

}

-(void)AgeClick :(id) sender{
    
    NSLog(@"AgeClick Action");
    if (_ageDelegate != nil && [_ageDelegate conformsToProtocol:@protocol(KAgeDelegate)]) {
        if ([_ageDelegate respondsToSelector:@selector(kAgeDelegateClick:)]) {
            [_ageDelegate kAgeDelegateClick:self];
        }
    }
}
@end
