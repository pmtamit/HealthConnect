//
//  LoginController.h
//  HealthConnect
//
//  Created by John Nguyen on 12/16/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterController.h"
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
@interface LoginController : UIViewController <UITextFieldDelegate,CLLocationManagerDelegate ,UIScrollViewDelegate, UIGestureRecognizerDelegate>{
    CLLocationManager *locationManager;
}
- (void)registerAction:(id)sender;
- (void)loginAction:(id)sender;
@property (retain, nonatomic) UITextField *_txtUser;
@property (retain, nonatomic) UITextField *_txtPass;

@property (retain, nonatomic) UILabel *_healthConnect;
@property (retain, nonatomic) UILabel *_cancer;
@property (retain, nonatomic) UIImageView *_line;
@property (retain, nonatomic) UIButton *_btSignup;
@property (retain, nonatomic) UIButton *_btLogin;
@property(nonatomic ,retain)IBOutlet UIScrollView * _scrollView ;

@end
