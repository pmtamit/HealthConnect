//
//  CustomColor.m
//  HealthConnect
//
//  Created by John Nguyen on 12/29/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import "CustomColor.h"
#import "Common.h"
@implementation CustomColor
@synthesize colorDelegate ;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        Common *common = [[Common alloc] init];
        int checkx = 0 ;
        int checky = 0 ;
        CGFloat x ;
        CGFloat y ;
        int tag = -1 ;
        UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        scroll.contentSize = CGSizeMake(self.frame.size.width, 1800);
        for (int i = 0 ; i< 36; i ++) {
            y = checky*50 ;
            for (int j = 0; j< 4; j++) {
                 tag ++ ;
                x = checkx * 50 ;
                UIButton * _btColor = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [_btColor addTarget:self
                             action:@selector(colorAction:)
                   forControlEvents:UIControlEventTouchUpInside];
                _btColor.frame = CGRectMake(x, y, 50, 50);
                _btColor.tag = tag;
                _btColor.backgroundColor =[Common colorWithHexString:[common.arrColor objectAtIndex:tag]];
                [scroll addSubview:_btColor];
                checkx ++ ;
               
            }
            checkx = 0 ;
            checky ++ ;
        }
        [self addSubview:scroll];
    }
    return self;
}
-(void)colorAction :(id) sender{
    if (colorDelegate != nil && [colorDelegate conformsToProtocol:@protocol(ColorDelegate)]) {
        if ([colorDelegate respondsToSelector:@selector(ColorClick:)]) {
            [colorDelegate ColorClick:sender];
        }
    }
}



@end
