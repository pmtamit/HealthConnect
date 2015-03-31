//
//  CustomColor.h
//  HealthConnect
//
//  Created by John Nguyen on 12/29/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol colorDelegate ;
@interface CustomColor : UIView
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic ,weak)IBOutlet id colorDelegate ;
@end
@protocol ColorDelegate
@optional
-(void)ColorClick:(id)sender;
@end
