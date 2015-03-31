//
//  AgeView.h
//  HealthConnect
//
//  Created by John Nguyen on 2/28/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownViewCell.h"
#import "AgeCell.h"
@protocol _FAgeDelegate ;
@interface AgeView : UIView<UITableViewDataSource ,UITableViewDelegate ,KAgeDelegate>{

    NSMutableArray * _data ;
    UITableView * ageTableView ;

}
@property (nonatomic ,weak)IBOutlet id _fageDelegate ;
-(id)initWithFrame:(CGRect)frame data :(NSMutableArray*)data;
@end
@protocol _FAgeDelegate

@optional
-(void)fAgeDelegateClick:(NSString*)_age ;
@end
