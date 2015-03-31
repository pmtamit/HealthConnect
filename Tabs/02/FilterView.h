//
//  FilterView.h
//  HealthConnect
//
//  Created by John Nguyen on 3/27/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterDelegate.h"

@interface FilterView : UIView{
    NSString *gender, *patient;
}
- (id)initWithFrame:(CGRect)frame ;

@property (nonatomic, retain) id<FilterDelegate> delegate;
@end
