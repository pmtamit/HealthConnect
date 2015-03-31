//
//  StreamController.h
//  HealthConnect
//
//  Created by John Nguyen on 12/10/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StreamViewCell.h"
#import "SliderSwitch.h"
@protocol KStreamViewDelegate ;
@interface StreamController : UIViewController <UITableViewDataSource, UITableViewDelegate ,CellDelegate ,SliderSwitchDelegate>
{
    BOOL isLoading ;
    BOOL isReLoad ;
}
@property(nonatomic,retain) SliderSwitch *slideSwitchH;
@property (nonatomic ,weak)IBOutlet id kStreamViewDelegate ;
-(void) LogoutSys ;
@end
@protocol KStreamViewDelegate

@optional
-(void)getTopPicChatFromStream:(NSString*)_topPic ;
@end

