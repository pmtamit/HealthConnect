//
//  AgeCell.h
//  HealthConnect
//
//  Created by John Nguyen on 2/28/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KAgeDelegate ;
@interface AgeCell : UITableViewCell{
    NSString * _dataGet ;
}
@property (nonatomic,retain)IBOutlet UILabel*title ;
-(void)setData :(NSString *)_age ;
@property (nonatomic ,weak)IBOutlet id _ageDelegate ;
@end

@protocol KAgeDelegate

@optional
-(void)kAgeDelegateClick:(UITableViewCell*)sender ;
@end
