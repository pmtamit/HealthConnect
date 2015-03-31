//
//  RegisterController.m
//  HealthConnect
//
//  Created by John Nguyen on 12/16/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import "RegisterController.h"
#import "DXPopover.h"
#import <Parse/Parse.h>
#import "AppConstant.h"
#import "pushnotification.h"
#import "ProgressHUD.h"
#import "utilities.h"
#import "ProfileRegist.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface RegisterController (){
    CGFloat screenWidth  ;
    NSString * sex ;
    int see ;
    BOOL checkMSee ;
    BOOL checkFSee ;
    UIPickerView *age ;
    NSArray *_pickerData;
    CLLocationCoordinate2D currentCoordinates ;
    NSString *country ;
    PFFile *fileIcon ;
    PFFile *fileThumbnail ;
    
}

@end

@implementation RegisterController
@synthesize _scrollView  ,_healthConnect  ,_cancer , _cpassWord ,_email ,_line ,_passWord ,_profileName
,_btSeeFemale , _btSeeMale ,_btSexFemale ,_btSexMale ,_birthdate ,_btSignup ,_birthDate
;
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    
    CGFloat screenHeight = screenRect.size.height;
    _scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    _scrollView.contentSize = CGSizeMake(screenWidth, 500);
    
    [self LoadInitalSignup];
    _profileName.delegate = self ;
    _email.delegate = self ;
    _passWord.delegate = self ;
    _cpassWord.delegate = self ;
    _birthdate.delegate = self ;
    checkMSee = FALSE ;
    checkFSee = FALSE ;
    sex = @"Male";
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self ;
    [locationManager startUpdatingLocation];
    if (IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_scrollView addGestureRecognizer:tapGesture];
}
-(void)hideKeyboard{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)LoadInitalSignup{
    
    CGFloat withItem = screenWidth - 60 ;
    
    _healthConnect = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, withItem, 40)];
    _healthConnect.backgroundColor = [UIColor clearColor];
    _healthConnect.numberOfLines = 0;
    _healthConnect.textAlignment = NSTextAlignmentRight;
    _healthConnect.text = @"HealthConnect";
    [_healthConnect setFont:[UIFont systemFontOfSize:30]];
    [_scrollView addSubview:_healthConnect];
    
    //set lable cancer
    _cancer = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, withItem, 40)];
    _cancer.backgroundColor = [UIColor clearColor];
    _cancer.numberOfLines = 0;
    _cancer.textAlignment = NSTextAlignmentRight;
    _cancer.text = @"cancer";
    [_cancer setFont:[UIFont systemFontOfSize:14]];
    [_scrollView addSubview:_cancer];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 80, withItem, 2)];
    _line.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:_line];
    
    
    UILabel * lbSignup = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, withItem, 40)];
    lbSignup.backgroundColor = [UIColor clearColor];
    lbSignup.numberOfLines = 0;
    lbSignup.textAlignment = NSTextAlignmentLeft;
    lbSignup.text = @"Signup via Username/Password :";
    [lbSignup setFont:[UIFont systemFontOfSize:16]];
    [_scrollView addSubview:lbSignup];
    
    //create input text user login
    _email = [[UITextField alloc] initWithFrame:CGRectMake(30, 140, withItem, 30)];
    _email.borderStyle = UITextBorderStyleRoundedRect;
    _email.font = [UIFont systemFontOfSize:15];
    _email.placeholder = @"E-Mail";
    _email.autocorrectionType = UITextAutocorrectionTypeNo;
    _email.keyboardType = UIKeyboardTypeDefault;
    _email.returnKeyType = UIReturnKeyNext;
    _email.clearButtonMode = UITextFieldViewModeWhileEditing;
    _email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_scrollView addSubview:_email];
    
    //create input text password
    
    _passWord = [[UITextField alloc] initWithFrame:CGRectMake(30, 185, withItem, 30)];
    _passWord.borderStyle = UITextBorderStyleRoundedRect;
    _passWord.font = [UIFont systemFontOfSize:15];
    _passWord.placeholder = @"Password";
    _passWord.secureTextEntry = YES ;
    _passWord.autocorrectionType = UITextAutocorrectionTypeNo;
    _passWord.keyboardType = UIKeyboardTypeDefault;
    _passWord.returnKeyType = UIReturnKeyDone;
    _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_scrollView addSubview:_passWord];
    
    //create button login
    UIButton * btSignup = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btSignup addTarget:self
                 action:@selector(saveAction)
       forControlEvents:UIControlEventTouchUpInside];
    [btSignup setTitle:@"Signup" forState:UIControlStateNormal];
    btSignup.frame = CGRectMake(30, 235, withItem, 30);
    btSignup.tag = 1;
    btSignup.backgroundColor =[UIColor grayColor];
    [_scrollView addSubview:btSignup];
    
    //create lable reset password
//    UILabel *  _reset = [[UILabel alloc] initWithFrame:CGRectMake(30, 272, withItem, 40)];
//    _reset.backgroundColor = [UIColor clearColor];
//    _reset.numberOfLines = 0;
//    _reset.textAlignment = NSTextAlignmentLeft;
//    _reset.text = @"Or signup via Facebook";
//    [_reset setFont:[UIFont systemFontOfSize:14]];
//    [_scrollView addSubview:_reset];
//    
//    UIButton *btFacebook = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btFacebook addTarget:self
//                   action:@selector(saveAction)
//         forControlEvents:UIControlEventTouchUpInside];
//    [btFacebook setTitle:@"Facebook Login" forState:UIControlStateNormal];
//    btFacebook.frame = CGRectMake(30, 305, withItem, 30);
//    btFacebook.tag = 1;
//    btFacebook.backgroundColor = [UIColor grayColor];
//    [_scrollView addSubview:btFacebook];
    
    UILabel * lbyet = [[UILabel alloc] initWithFrame:CGRectMake(30, 272, withItem, 40)];
    lbyet.backgroundColor = [UIColor clearColor];
    lbyet.numberOfLines = 0;
    lbyet.textAlignment = NSTextAlignmentLeft;
    lbyet.text = @"We will not share your E-Mail or other personal data with anyone";
    [lbyet setFont:[UIFont systemFontOfSize:13]];
    [_scrollView addSubview:lbyet];
    
}


-(void)btSexAction :(id)sender{
    UIButton *btSex = sender ;
    if (btSex.tag == 0) {
        sex = @"Male" ;
    }else{
        sex = @"Female" ;
    }
}

-(void)btSeeMale :(id)sender{
    if (!checkMSee) {
        checkMSee = TRUE ;
    }else{
        checkMSee = FALSE ;
    }
}
-(void)btSeeFrame :(id)sender{
    if (!checkFSee) {
        checkFSee = TRUE ;
    }else{
        checkFSee = FALSE ;
    }
}


-(void)saveAction{
    [self RegisterUser];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        [self._scrollView setContentOffset:CGPointMake(_scrollView.frame.origin.x, 50) animated:YES] ;
    }else if(textField.tag == 1){
        [self._scrollView setContentOffset:CGPointMake(_scrollView.frame.origin.x, 150) animated:YES] ;
        
    }
    
    return YES ;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self._scrollView setContentOffset:CGPointMake(_scrollView.frame.origin.x, 0) animated:YES];
    return YES ;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self._birthdate) {
        [theTextField resignFirstResponder];
    } else if (theTextField == self._cpassWord) {
        [self._birthdate becomeFirstResponder];
        [self._scrollView setContentOffset:CGPointMake(_scrollView.frame.origin.x, 150) animated:YES] ;
    }
    return YES;
}

-(void)RegisterUser{
   
    if ([_passWord.text length] == 0)	{ [ProgressHUD showError:@"Password must be set."]; return; }
    if ([[_email.text lowercaseString] length] == 0)	{ [ProgressHUD showError:@"Email must be set."]; return; }
    ProfileRegist * profileRegist = [[ProfileRegist alloc] init:[_email.text lowercaseString] pass:_passWord.text country:country];
    [self.navigationController pushViewController:profileRegist animated:YES];
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //    currentLocation = [locations objectAtIndex:0];
    CLGeocoder *geocoder1 = [[CLGeocoder alloc] init];
    
    CLLocation * newObject = [locations objectAtIndex:0];
    currentCoordinates = newObject.coordinate ;
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:currentCoordinates.latitude longitude:currentCoordinates.longitude];
    [geocoder1 reverseGeocodeLocation:newLocation
                    completionHandler:^(NSArray *placemarks, NSError *error) {
                        
                        if (error) {
                            NSLog(@"Geocode failed with error: %@", error);
                            return;
                        }
                        if (placemarks && placemarks.count > 0)
                        {
                            CLPlacemark *placemark = placemarks[0];
                            NSDictionary *addressDictionary =
                            placemark.addressDictionary;
                            country = [addressDictionary objectForKey:@"Country"];
                        }
                    }];
    [locationManager stopUpdatingLocation];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
