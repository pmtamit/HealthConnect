//
//  LoginController.m
//  HealthConnect
//
//  Created by John Nguyen on 12/16/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//
#import "LoginController.h"
#import "ProgressHUD.h"
#import "AppConstant.h"
#import "pushnotification.h"
#import "AppDelegate.h"

#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface LoginController (){
    CGFloat screenWidth  ;
    NSString * longitude ;
    NSString * latitude ;
}
@end

@implementation LoginController
@synthesize _txtPass , _txtUser  ;
@synthesize _scrollView  ,_healthConnect  ,_cancer   ,_line ,_btSignup ,_btLogin;

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    
    CGFloat screenHeight = screenRect.size.height;
    _scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    _scrollView.contentSize = CGSizeMake(screenWidth, 500);
    _scrollView.scrollEnabled = NO;
    
    [self LoadInitalView];
    _txtUser.delegate = self ;
    _txtPass.delegate = self ;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
    if (IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager stopUpdatingLocation];
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
//Call action register
- (void)registerAction:(id)sender {
    
    RegisterController *registerView = [[RegisterController alloc] init ];
    [self.navigationController pushViewController:registerView animated:YES];
      [locationManager stopUpdatingLocation];
    
}
//Action Login
- (void)loginAction:(id)sender {
    [locationManager stopUpdatingLocation];
    [self functionLogin ];
    
}


//Function Login
-(void)functionLogin{
    NSString *email = [_txtUser.text lowercaseString];
    NSString *password = _txtPass.text;
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if ([email length] == 0)	{ [ProgressHUD showError:@"Email must be set."]; return; }
    if ([password length] == 0)	{ [ProgressHUD showError:@"Password must be set."]; return; }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [ProgressHUD show:@"Signing in..." Interaction:NO];
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error)
     {
         if (user != nil)
         {
             ParsePushUserAssign();
             [self dismissViewControllerAnimated:YES completion:nil];
            [ProgressHUD dismiss];
         }
         else [ProgressHUD showError:error.userInfo[@"error"]];
     }];

}

// Delegate text input
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self._txtPass) {
        [theTextField resignFirstResponder];
        [self functionLogin];
    } else if (theTextField == self._txtUser) {
        [self._txtPass becomeFirstResponder];
    }
    return YES;
}
//Create view
-(void)LoadInitalView{
    
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
    
    //create input text user login
    _txtUser = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, withItem, 30)];
    _txtUser.borderStyle = UITextBorderStyleRoundedRect;
    _txtUser.font = [UIFont systemFontOfSize:15];
    _txtUser.placeholder = @"E-Mail";
    _txtUser.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtUser.keyboardType = UIKeyboardTypeDefault;
    _txtUser.returnKeyType = UIReturnKeyNext;
    _txtUser.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtUser.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_scrollView addSubview:_txtUser];
    
    //create input text password
    
    _txtPass = [[UITextField alloc] initWithFrame:CGRectMake(30, 145, withItem, 30)];
    _txtPass.borderStyle = UITextBorderStyleRoundedRect;
    _txtPass.font = [UIFont systemFontOfSize:15];
    _txtPass.placeholder = @"Password";
    _txtPass.secureTextEntry = YES ;
    _txtPass.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtPass.keyboardType = UIKeyboardTypeDefault;
    _txtPass.returnKeyType = UIReturnKeyDone;
    _txtPass.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtPass.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_scrollView addSubview:_txtPass];
    
    //create button login
    _btLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btLogin addTarget:self
                 action:@selector(loginAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [_btLogin setTitle:@"Login" forState:UIControlStateNormal];
    _btLogin.frame = CGRectMake(30, 190, withItem, 30);
    _btLogin.tag = 1;
    _btLogin.backgroundColor =[UIColor grayColor];
    [_scrollView addSubview:_btLogin];
    
    //create lable reset password
    UILabel *  _reset = [[UILabel alloc] initWithFrame:CGRectMake(30, 215, withItem, 40)];
    _reset.backgroundColor = [UIColor clearColor];
    _reset.numberOfLines = 0;
    _reset.textAlignment = NSTextAlignmentRight;
    _reset.text = @"Rest Password ";
    [_reset setFont:[UIFont systemFontOfSize:14]];
//    [_scrollView addSubview:_reset];
    
    //create lable yet
    UILabel * lbyet = [[UILabel alloc] initWithFrame:CGRectMake(30, 245, withItem, 40)];
    lbyet.backgroundColor = [UIColor clearColor];
    lbyet.numberOfLines = 0;
    lbyet.textAlignment = NSTextAlignmentLeft;
    lbyet.text = @"No account yet?";
    [lbyet setFont:[UIFont systemFontOfSize:16]];
    [_scrollView addSubview:lbyet];
    
    _btSignup = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btSignup addTarget:self
                  action:@selector(registerAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [_btSignup setTitle:@"Signup" forState:UIControlStateNormal];
    _btSignup.frame = CGRectMake(30, 285, withItem, 30);
    _btSignup.tag = 1;
    _btSignup.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:_btSignup];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES ;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end



