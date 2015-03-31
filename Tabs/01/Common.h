//
//  Common.h
//  HealthConnect
//
//  Created by John Nguyen on 12/30/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Common : UIView
@property  NSMutableArray *arrColor ;
+ (UIColor *)colorWithHexString:(NSString *)colorString;
@end
