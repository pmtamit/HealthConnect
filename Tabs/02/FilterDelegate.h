//
//  FilterDelegate.m
//  HealthConnect
//
//  Created by Phan Minh Tam on 3/31/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FilterDelegate <NSObject>
- (void)clickFilterwithGender:(NSString *)gender withPatient:(NSString*)patient;
@end
