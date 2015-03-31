//
//  AddStreamController.h
//  HealthConnect
//
//  Created by John Nguyen on 12/11/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomColor.h"
#import <CoreLocation/CoreLocation.h>
@interface AddStreamController : UIViewController <ColorDelegate, CLLocationManagerDelegate,UITextViewDelegate ,UIActionSheetDelegate, UIImagePickerControllerDelegate >{
   CLLocationManager *locationManager ;
}

@property (weak, nonatomic) IBOutlet UITextView *_txtAddStream;


@property (weak, nonatomic) UIButton * btbgrColor ;
@property (weak, nonatomic) UIButton * btImage ;
@property (weak, nonatomic) UIButton * btTextColor ;
@property (retain, nonatomic) UILabel * textImage ;
@property (retain, nonatomic) UILabel * textColor ;
@property (retain, nonatomic) UILabel *  textBg  ;
@property (retain, nonatomic) UIImageView * imageView  ;


@end
