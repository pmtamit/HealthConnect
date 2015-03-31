//
//  RegisterController.h
//  HealthConnect
//
//  Created by John Nguyen on 12/16/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface RegisterController : UIViewController <UITextFieldDelegate  ,CLLocationManagerDelegate>{
CLLocationManager *locationManager ;

}
@property(nonatomic ,retain)IBOutlet UIScrollView * _scrollView ;
@property (retain, nonatomic) UILabel *_healthConnect;
@property (retain, nonatomic) UILabel *_cancer;
@property (retain, nonatomic) UIImageView *_line;

@property (retain, nonatomic) UITextField *_profileName;
@property (retain, nonatomic) UITextField *_email;
@property (retain, nonatomic) UITextField *_passWord;
@property (retain, nonatomic) UITextField *_cpassWord;
@property (retain, nonatomic) UITextField *_birthdate;
@property (retain, nonatomic) UIButton *_btSexMale;
@property (retain, nonatomic) UIButton *_btSexFemale;
@property (retain, nonatomic) UIButton *_btSeeMale;
@property (retain, nonatomic) UIButton *_btSeeFemale;
@property (retain, nonatomic) UIButton *_btSignup;
@property (retain, nonatomic) NSString *_birthDate ;
- (IBAction)showCalendar:(id)sender;
- (id)initWithFrame:(CGRect)frame;
@end
