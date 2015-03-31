//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "AppConstant.h"
#import "camera.h"
#import "pushnotification.h"
#import "utilities.h"
#import "ProfileView.h"
#import "SGPopSelectView.h"
#import "StreamController.h"
#import "DropDownListView.h"
#import "AgeView.h"
@interface ProfileView()<kDropDownListViewDelegate ,_FAgeDelegate , UITextInputDelegate ,UITextViewDelegate>{
    CGFloat screenWidth ;
    PFFile *filePicture ;
    PFFile *fileThumbnail;
    NSMutableArray *_pickerData;
    NSString *age ;
    StreamController *streamController ;
    NSArray *arryList;
    DropDownListView * Dropobj;
    AgeView *ageView ;
    UIImageView *icon;
    NSString *patient ;
    NSString *sex ;
}

@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet PFImageView *imageUser;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellName;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellButton;
@property (strong, nonatomic) IBOutlet UITextField *fieldName;
@property (nonatomic, strong) SGPopSelectView *popView;
@end


@implementation ProfileView

@synthesize viewHeader, imageUser;
@synthesize cellName, cellButton;
@synthesize fieldName;
@synthesize _scrollProFile  ,_healthConnect  ,_cancer , _cpassWord ,_email ,_line ,_passWord ,_profileName
,_btSeeFemale , _btSeeMale ,_btSexFemale ,_btSexMale ,_birthdate ,_birthDate ,_txtMyStory ,_btAge ,_btNo ,_btYes
;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_profile"]];
        self.tabBarItem.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    _scrollProFile.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    _scrollProFile.contentSize = CGSizeMake(screenWidth, 800);
    
    [super viewDidLoad];
    self.title = @"Profile";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(actionLogout)];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
   
    imageUser.layer.cornerRadius = imageUser.frame.size.width / 2;
    imageUser.layer.masksToBounds = YES;
    
    _pickerData = [[NSMutableArray alloc] init];
    [_pickerData addObject:@"dont't show"] ;
    
    for (int i = 18; i< 111; i++) {
        [_pickerData addObject:[NSString stringWithFormat:@"%d",i]];
    }
   
    [self initInterface];
    [self profileLoad];
    _txtMyStory.delegate = self ;
    
  }

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([PFUser currentUser] != nil)
    {
       
        [self profileLoad];
    }
    else LoginUser(self);
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}
- (void)profileLoad{
    
    PFUser *user = [PFUser currentUser];
    _profileName.text = user[PF_USER_PROFILE];
    _email.text = user[PF_USER_EMAIL];
    if (user[PF_USER_BIRTHDATE] != nil) {
        _birthdate.text = user[PF_USER_BIRTHDATE];
        age =user[PF_USER_BIRTHDATE] ;
    }else{
        _birthdate.text = @"don't show";
        age = @"don't show";
    }
    patient =user[PF_USER_PATENT];
    if (user[PF_USER_PATENT] !=nil){
        patient =user[PF_USER_PATENT] ;
        
        if ([patient isEqual: @"NO"]) {
            _btNo.backgroundColor = [UIColor redColor];
            _btYes.backgroundColor = [UIColor grayColor];
        }else{
            _btYes.backgroundColor = [UIColor redColor];
             _btNo.backgroundColor = [UIColor grayColor];
        }
    }
    sex = user[PF_USER_SEX] ;
    if (user[PF_USER_SEX] !=nil){
       
        if ([user[PF_USER_SEX] isEqual: @"Male"]) {
            _btSexMale.backgroundColor = [UIColor redColor];
            _btSexFemale.backgroundColor = [UIColor grayColor];
        }else{
            _btSexFemale.backgroundColor = [UIColor redColor];
            _btSexMale.backgroundColor = [UIColor grayColor];
        }
    }

    _txtMyStory.text = user[PF_USER_MYSTORY];
  

}

- (void)actionLogout{
    UIAlertView *logutAlert = [[UIAlertView alloc] initWithTitle:@"Are you want logout system." message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [logutAlert show];
}
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
       [self.view removeFromSuperview];
        [PFUser logOut];
        ParsePushUserResign();
        PostNotification(NOTIFICATION_USER_LOGGED_OUT);
        LoginUser(self);
    }
}


#pragma mark - UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != actionSheet.cancelButtonIndex){
        if (buttonIndex == 0)   ShouldStartCamera(self, YES);
        if (buttonIndex == 1)	ShouldStartPhotoLibrary(self, YES);
    }
}

#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    icon.image = ResizeImage(image, 60, 70) ;
    if (image.size.width > 140) image = ResizeImage(image, 140, 140);{
        filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
        imageUser.image = image;}
    if (image.size.width > 30) image = ResizeImage(image, 30, 30);
    fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)initInterface{
    PFUser *userInfo = [PFUser currentUser];
    CGFloat withItem = screenWidth -20 ;
    
    UILabel *lbHealth = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, withItem-40, 40)];
    lbHealth.backgroundColor = [UIColor clearColor];
    lbHealth.numberOfLines = 0;
    lbHealth.textAlignment = NSTextAlignmentRight;
    lbHealth.text = @"HealthConnect";
    [lbHealth setFont:[UIFont systemFontOfSize:30]];
    [_scrollProFile addSubview:lbHealth];
    
    //set lable cancer
    UILabel * cancer = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, withItem-40, 40)];
    cancer.backgroundColor = [UIColor clearColor];
    cancer.numberOfLines = 0;
    cancer.textAlignment = NSTextAlignmentRight;
    cancer.text = @"cancer";
    [cancer setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:cancer];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, withItem, 2)];
    _line.backgroundColor = [UIColor grayColor];
    [_scrollProFile addSubview:_line];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 70)];
    icon.backgroundColor = [UIColor clearColor];
    
    PFFile *photoFile  =   [PFUser currentUser][PF_USER_PICTURE];
    UIImage *fullImage = [UIImage imageWithData:photoFile.getData];
    icon.image = fullImage ;
    
    
    [_scrollProFile addSubview:icon];
    
    UILabel * lbProfile = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 120, 30)];
    lbProfile.backgroundColor = [UIColor clearColor];
    lbProfile.numberOfLines = 0;
    lbProfile.textAlignment = NSTextAlignmentLeft;
    lbProfile.text = @"Profile Name";
    [lbProfile setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:lbProfile];
    
    _profileName = [[UITextField alloc] initWithFrame:CGRectMake(130, 85, screenWidth-150, 30)];
    _profileName.borderStyle = UITextBorderStyleRoundedRect;
    _profileName.font = [UIFont systemFontOfSize:15];
    _profileName.autocorrectionType = UITextAutocorrectionTypeNo;
    _profileName.keyboardType = UIKeyboardTypeDefault;
    _profileName.returnKeyType = UIReturnKeyNext;
    _profileName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _profileName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _profileName.placeholder = @"Profile Name";
    [_scrollProFile addSubview:_profileName];
    
    UILabel * lbEmail = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, withItem, 60)];
    lbEmail.backgroundColor = [UIColor clearColor];
    lbEmail.numberOfLines = 0;
    lbEmail.textAlignment = NSTextAlignmentLeft;
    lbEmail.text = @"Email";
    [lbEmail setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:lbEmail];
    
    _email = [[UITextField alloc] initWithFrame:CGRectMake(130, 125, screenWidth-150, 30)];
    _email.borderStyle = UITextBorderStyleRoundedRect;
    _email.font = [UIFont systemFontOfSize:15];
    _email.autocorrectionType = UITextAutocorrectionTypeNo;
    _email.keyboardType = UIKeyboardTypeDefault;
    _email.returnKeyType = UIReturnKeyNext;
    _email.clearButtonMode = UITextFieldViewModeWhileEditing;
    _email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _email.text = userInfo[PF_USER_PROFILE];
    [_scrollProFile addSubview:_email];
    
    UILabel * lbPass = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 120, 60)];
    lbPass.backgroundColor = [UIColor clearColor];
    lbPass.numberOfLines = 0;
    lbPass.textAlignment = NSTextAlignmentLeft;
    lbPass.text = @"Password ";
    [lbPass setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:lbPass];
    
    _passWord = [[UITextField alloc] initWithFrame:CGRectMake(130, 160, screenWidth-150, 30)];
    _passWord.borderStyle = UITextBorderStyleRoundedRect;
    _passWord.font = [UIFont systemFontOfSize:15];
    _passWord.autocorrectionType = UITextAutocorrectionTypeNo;
    _passWord.keyboardType = UIKeyboardTypeDefault;
    _passWord.returnKeyType = UIReturnKeyNext;
    _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passWord.placeholder = @"Enter New Password";
    [_scrollProFile addSubview:_passWord];
    
    _cpassWord = [[UITextField alloc] initWithFrame:CGRectMake(130, 195, screenWidth-150, 30)];
    _cpassWord.borderStyle = UITextBorderStyleRoundedRect;
    _cpassWord.font = [UIFont systemFontOfSize:15];
    _cpassWord.autocorrectionType = UITextAutocorrectionTypeNo;
    _cpassWord.keyboardType = UIKeyboardTypeDefault;
    _cpassWord.returnKeyType = UIReturnKeyNext;
    _cpassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _cpassWord.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _cpassWord.placeholder = @"Confirm New Password";
    [_scrollProFile addSubview:_cpassWord];
    
    UILabel *  _sex = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, 60, 30)];
    _sex.backgroundColor = [UIColor clearColor];
    _sex.numberOfLines = 0;
    _sex.textAlignment = NSTextAlignmentLeft;
    _sex.text = @"Gender :";
    [_sex setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:_sex];
    
    _btSexMale = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btSexMale addTarget:self
                   action:@selector(MAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [_btSexMale setTitle:@"Male" forState:UIControlStateNormal];
    _btSexMale.frame = CGRectMake(130, 235, 60, 30);
    _btSexMale.tag = 1;
    _btSexMale.backgroundColor = [UIColor grayColor];
    [_scrollProFile addSubview:_btSexMale];
    
    _btSexFemale = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btSexFemale addTarget:self
                     action:@selector(FAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [_btSexFemale setTitle:@"Female" forState:UIControlStateNormal];
    _btSexFemale.frame = CGRectMake(withItem-60, 235, 60, 30);
    _btSexFemale.backgroundColor = [UIColor grayColor];
    _btSexFemale.tag = 2;
    [_scrollProFile addSubview:_btSexFemale];
    
    UILabel *  _patient  = [[UILabel alloc] initWithFrame:CGRectMake(10, 265, 100, 30)];
    _patient.backgroundColor = [UIColor clearColor];
    _patient.numberOfLines = 0;
    _patient.textAlignment = NSTextAlignmentLeft;
    _patient.text = @"I am a patient :";
    [_patient setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:_patient];
    
    _btYes = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btYes addTarget:self
               action:@selector(YesAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [_btYes setTitle:@"Yes" forState:UIControlStateNormal];
    _btYes.frame = CGRectMake(130, 270, 60, 30);
    _btYes.tag = 1;
    _btYes.backgroundColor = [UIColor grayColor];
    [_scrollProFile addSubview:_btYes];
    
    _btNo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btNo addTarget:self
              action:@selector(NoAction:)
    forControlEvents:UIControlEventTouchUpInside];
    [_btNo setTitle:@"No" forState:UIControlStateNormal];
    _btNo.frame = CGRectMake(withItem-60, 270, 60, 30);
    _btNo.backgroundColor = [UIColor grayColor];
    _btNo.tag = 2;
    [_scrollProFile addSubview:_btNo];
    
    UILabel * lbbirth = [[UILabel alloc] initWithFrame:CGRectMake(10, 305, 100, 40)];
    lbbirth.backgroundColor = [UIColor clearColor];
    lbbirth.numberOfLines = 0;
    lbbirth.textAlignment = NSTextAlignmentLeft;
    lbbirth.text = @"Age :";
    [lbbirth setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:lbbirth];
    
    _btAge = [[UILabel alloc] initWithFrame:CGRectMake(130, 310, screenWidth - 150, 32)];
    UIImage * image = [UIImage imageNamed:@"drop_list.png"];
    image = ResizeImage(image, screenWidth - 150, 30);
    _btAge.backgroundColor = [UIColor colorWithPatternImage:image];
    _btAge.textAlignment = NSTextAlignmentCenter ;
    _btAge.layer.borderColor =(__bridge CGColorRef)([UIColor grayColor]);
    _btAge.layer.borderWidth = 2.0 ;
    _btAge.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DropDownSingle)];
    [_btAge addGestureRecognizer:tapGesture];
    [_scrollProFile addSubview:_btAge];
    
    UILabel * lbImageProfile = [[UILabel alloc] initWithFrame:CGRectMake(10, 350, 120, 40)];
    lbImageProfile.backgroundColor = [UIColor clearColor];
    lbImageProfile.numberOfLines = 0;
    lbImageProfile.textAlignment = NSTextAlignmentLeft;
    lbImageProfile.text = @"Profile Image 1 :";
    [lbImageProfile setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:lbImageProfile];
    
    
    UIButton *   _image = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_image addTarget:self
               action:@selector(imageAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [_image setTitle:@"Select" forState:UIControlStateNormal];
    _image.frame = CGRectMake(withItem-60, 355, 60, 30);
    _image.tag = 1;
    _image.backgroundColor = [UIColor grayColor];
    [_scrollProFile addSubview:_image];
    
    
    UILabel * lbMyStory = [[UILabel alloc] initWithFrame:CGRectMake(10, 390, withItem, 30)];
    lbMyStory.backgroundColor = [UIColor clearColor];
    lbMyStory.numberOfLines = 0;
    lbMyStory.textAlignment = NSTextAlignmentLeft;
    lbMyStory.text = @"My Story :";
    [lbMyStory setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:lbMyStory];
    
    _txtMyStory = [[UITextView alloc] initWithFrame:CGRectMake(10, 420, withItem, 100)];
    self._txtMyStory.layer.borderWidth = 1.0f;
    self._txtMyStory.layer.borderColor = [[UIColor grayColor] CGColor];
    _txtMyStory.font = [UIFont systemFontOfSize:15];
    _txtMyStory.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtMyStory.keyboardType = UIKeyboardTypeDefault;
    _txtMyStory.returnKeyType = UIReturnKeyDone;
    _txtMyStory.text = userInfo[PF_USER_MYSTORY];
    [_scrollProFile addSubview:_txtMyStory];
    
    UIButton * saveProfile = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveProfile addTarget:self
                    action:@selector(saveAction:)
          forControlEvents:UIControlEventTouchUpInside];
    [saveProfile setTitle:@"Save" forState:UIControlStateNormal];
    saveProfile.frame = CGRectMake(10, 540, withItem, 30);
    saveProfile.tag = 1;
    saveProfile.backgroundColor = [UIColor grayColor];
    [_scrollProFile addSubview:saveProfile];
    
    ageView = [[AgeView alloc] initWithFrame:CGRectMake(130, 325, screenWidth - 150, 200) data:_pickerData];
    ageView._fageDelegate = self ;
    ageView.layer.cornerRadius = 3.0;
    ageView.layer.borderWidth = 1.0;
    ageView.layer.borderColor = [UIColor grayColor].CGColor;
    ageView.layer.masksToBounds = YES;
    ageView.hidden = YES ;
    [_scrollProFile addSubview:ageView];
    
  }
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:_birthdate];
    [self.popView showFromView:self.view atPoint:touchPoint animated:YES];

}

-(void)MAction :(id)sender {
    UIButton *bt = sender ;
    _btSexFemale.backgroundColor = [UIColor grayColor];
    bt.backgroundColor= [UIColor redColor];
    sex = @"Male";
}

-(void)FAction :(id)sender {
    UIButton *bt = sender ;
    _btSexMale.backgroundColor = [UIColor grayColor];
    bt.backgroundColor= [UIColor redColor];
    sex = @"Female";

}
-(void)YesAction :(id)sender {
    patient = @"YES";
    _btNo.backgroundColor = [UIColor grayColor];
    _btYes.backgroundColor= [UIColor redColor];
    
}
-(void)NoAction :(id)sender {
    patient = @"NO";
    _btYes.backgroundColor = [UIColor grayColor];
    _btNo.backgroundColor= [UIColor redColor];
}
-(void)imageAction :(id)sender {
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Choose existing photo", nil];
    
    [action showFromTabBar:[[self tabBarController] tabBar]];
    
}
-(void)saveAction :(id)sender {
    if (_profileName.text.length == 0) {
        [ProgressHUD showError:@"Profile Name cannot be empty."];
    }else if (sex.length == 0){
        [ProgressHUD showError:@"You must choose gender."];
    }else if (patient.length == 0){
        [ProgressHUD showError:@"You must choose patient."];
    }else{
    [self dismissKeyboard];
    

        [ProgressHUD show:@"Please wait..."];
        PFUser *user = [PFUser currentUser];
    
    if (age == nil) {
        age = @"don't show";
    }
    if (patient == nil) {
        patient = @"NO";
    }
    if (sex == nil) {
        sex = @"Female";
    }
        user[PF_USER_BIRTHDATE]=age;
        user[PF_USER_SEX]=sex;
        user[PF_USER_PATENT]=patient;
      
        user[PF_USER_PROFILE] = (_profileName.text.length == 0)?@"":(_profileName.text);
        user[PF_USER_MYSTORY] = (_txtMyStory.text.length == 0)?@"":(_txtMyStory.text);
        if (filePicture == nil) {
            filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation([UIImage imageNamed:@"avatar.png"], 0.6)];
            fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation([UIImage imageNamed:@"avatar.png"], 0.6)];
        }
        user[PF_USER_PICTURE] = filePicture;
        user[PF_USER_THUMBNAIL] = fileThumbnail;
        if ([_passWord.text length] ) {
             user.password = _passWord.text;
        }
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error == nil)
             {
                 [ProgressHUD showSuccess:@"Update Profile Success."];
             }
             else [ProgressHUD showError:@"Network error."];
         }];
    }

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:TRUE];
}
- (void)DropDownSingle {
    ageView.hidden = NO ;
}

-(void)fAgeDelegateClick:(NSString *)_age{
    _btAge.text = _age ;
    age = _age ;
    ageView.hidden = YES ;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES ;
}
- (BOOL)textFieldShouldReturn:(UITextView *)theTextField {
    if (theTextField == self._txtMyStory) {
        [theTextField resignFirstResponder];
    }     return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"hoang");
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
