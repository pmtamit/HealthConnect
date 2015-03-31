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
#import "ProfileRegist.h"
#import "SGPopSelectView.h"
#import "StreamController.h"
#import "DropDownListView.h"
#import "AgeView.h"
@interface ProfileRegist()<kDropDownListViewDelegate ,_FAgeDelegate , UITextInputDelegate ,UITextViewDelegate>{
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


@implementation ProfileRegist

@synthesize viewHeader, imageUser;
@synthesize cellName, cellButton;
@synthesize fieldName;
@synthesize _scrollProFile  ,_healthConnect  ,_cancer   ,_line ,_profileName
,_btSeeFemale , _btSeeMale ,_btSexFemale ,_btSexMale ,_birthdate ,_btSignup ,_birthDate ,_txtMyStory ,_btAge ,_btNo ,_btYes, _user ,_pass ,_country
;


- initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mail:(NSString*)mail Pass:(NSString*)pass{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_profile"]];
        self.tabBarItem.title = @"Profile";
    }
    return self;
}

-(id)init :(NSString *)user pass:(NSString*)pass country:(NSString*)country  {
    if (self)
    {
        
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_profile"]];
        self.tabBarItem.title = @"Profile";
        _pass = pass ;
        _user = user ;
        _country = country ;
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

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
   
    imageUser.layer.cornerRadius = imageUser.frame.size.width / 2;
    imageUser.layer.masksToBounds = YES;
    
    _pickerData = [[NSMutableArray alloc] init];
    for (int i = 18; i< 111; i++) {
        [_pickerData addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self LoadInitalProfile];
    _txtMyStory.delegate = self ;
    UIImage *image = [UIImage imageNamed:@"avatar.png"];
    icon.image = image ;
    patient = @"";
    sex = @"" ;
    age = @"don't show";
    filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
    fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
  }

- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    if ([PFUser currentUser] != nil)
//    {
//       
//    }
//    else LoginUser(self);
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
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
        imageUser.image = image;
    }
    if (image.size.width > 30) image = ResizeImage(image, 30, 30);
    fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)LoadInitalProfile{
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
    icon.backgroundColor = [UIColor greenColor];
    [_scrollProFile addSubview:icon];
    
    UILabel * lbProfile = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, withItem, 60)];
    lbProfile.backgroundColor = [UIColor clearColor];
    lbProfile.numberOfLines = 0;
    lbProfile.textAlignment = NSTextAlignmentLeft;
    lbProfile.text = @"Optional: Please complete your profile to make it visible to others and to be able to post messages";
    [lbProfile setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:lbProfile];
    
    _profileName = [[UITextField alloc] initWithFrame:CGRectMake(10, 150, withItem-30, 30)];
    _profileName.borderStyle = UITextBorderStyleRoundedRect;
    _profileName.font = [UIFont systemFontOfSize:15];
    _profileName.autocorrectionType = UITextAutocorrectionTypeNo;
    _profileName.keyboardType = UIKeyboardTypeDefault;
    _profileName.returnKeyType = UIReturnKeyNext;
    _profileName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _profileName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _profileName.placeholder = @"Profile Name";
    [_scrollProFile addSubview:_profileName];
    
    UILabel * lbmandatory_profilename = [[UILabel alloc] initWithFrame:CGRectMake(_profileName.frame.origin.x+_profileName.frame.size.width+5, 150, 20, 30)];
    lbmandatory_profilename.text = @"(*)";
    lbmandatory_profilename.textColor = [UIColor redColor];
    [_scrollProFile addSubview:lbmandatory_profilename];
   
    UILabel *  _sex = [[UILabel alloc] initWithFrame:CGRectMake(10, 190, 60, 30)];
    _sex.backgroundColor = [UIColor clearColor];
    _sex.numberOfLines = 0;
    _sex.textAlignment = NSTextAlignmentLeft;
    _sex.text = @"Gender :";
    [_sex setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:_sex];
    UILabel * lbmandatory_gender = [[UILabel alloc] initWithFrame:CGRectMake(_sex.frame.origin.x+_sex.frame.size.width, 190, 20, 30)];
    lbmandatory_gender.text = @"(*)";
    lbmandatory_gender.textColor = [UIColor redColor];
    [_scrollProFile addSubview:lbmandatory_gender];

    _btSexMale = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btSexMale addTarget:self
                   action:@selector(MAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [_btSexMale setTitle:@"Male" forState:UIControlStateNormal];
    _btSexMale.frame = CGRectMake(130, 190, 60, 30);
    _btSexMale.tag = 1;
    _btSexMale.backgroundColor = [UIColor grayColor];
    [_scrollProFile addSubview:_btSexMale];

    _btSexFemale = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btSexFemale addTarget:self
                     action:@selector(FAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [_btSexFemale setTitle:@"Female" forState:UIControlStateNormal];
    _btSexFemale.frame = CGRectMake(withItem-60, 190, 60, 30);
    _btSexFemale.backgroundColor = [UIColor grayColor];
    _btSexFemale.tag = 2;
    [_scrollProFile addSubview:_btSexFemale];
    
    UILabel *  _patient  = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, 100, 30)];
    _patient.backgroundColor = [UIColor clearColor];
    _patient.numberOfLines = 0;
    _patient.textAlignment = NSTextAlignmentLeft;
    _patient.text = @"I am a patient :";
    [_patient setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:_patient];
    UILabel * lbmandatory_patient = [[UILabel alloc] initWithFrame:CGRectMake(_patient.frame.origin.x+_patient.frame.size.width, 230, 20, 30)];
    lbmandatory_patient.text = @"(*)";
    lbmandatory_patient.textColor = [UIColor redColor];
    [_scrollProFile addSubview:lbmandatory_patient];
    
    _btYes = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btYes addTarget:self
                   action:@selector(YesAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [_btYes setTitle:@"Yes" forState:UIControlStateNormal];
    _btYes.frame = CGRectMake(130, 230, 60, 30);
    _btYes.tag = 1;
    _btYes.backgroundColor = [UIColor grayColor];
    [_scrollProFile addSubview:_btYes];
    
    _btNo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btNo addTarget:self
                     action:@selector(NoAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [_btNo setTitle:@"No" forState:UIControlStateNormal];
    _btNo.frame = CGRectMake(withItem-60, 230, 60, 30);
    _btNo.backgroundColor = [UIColor grayColor];
    _btNo.tag = 2;
    [_scrollProFile addSubview:_btNo];
    
    UILabel * lbbirth = [[UILabel alloc] initWithFrame:CGRectMake(10, 270, 100, 40)];
    lbbirth.backgroundColor = [UIColor clearColor];
    lbbirth.numberOfLines = 0;
    lbbirth.textAlignment = NSTextAlignmentLeft;
    lbbirth.text = @"Age :";
    [lbbirth setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:lbbirth];

    _btAge = [[UILabel alloc] initWithFrame:CGRectMake(120, 275, screenWidth - 130, 32)];
    UIImage * image = [UIImage imageNamed:@"drop_list.png"];
    image = ResizeImage(image, screenWidth - 130, 30);
    _btAge.backgroundColor = [UIColor colorWithPatternImage:image];
    _btAge.textAlignment = NSTextAlignmentCenter ;
    _btAge.layer.borderColor =(__bridge CGColorRef)([UIColor grayColor]);
    _btAge.layer.borderWidth = 2.0 ;
    _btAge.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DropDownSingle)];
    [_btAge addGestureRecognizer:tapGesture];


    _btAge.text =@"don't show" ;
    if (userInfo[PF_USER_BIRTHDATE] != nil) {
        _btAge.text =userInfo[PF_USER_BIRTHDATE] ;
    }
  [_scrollProFile addSubview:_btAge];
    
    UILabel * lbImageProfile = [[UILabel alloc] initWithFrame:CGRectMake(10, 310, 120, 40)];
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
    _image.frame = CGRectMake(withItem-60, 315, 60, 30);
    _image.tag = 1;
    _image.backgroundColor = [UIColor grayColor];
    [_scrollProFile addSubview:_image];

    
    UILabel * lbMyStory = [[UILabel alloc] initWithFrame:CGRectMake(10, 340, withItem, 30)];
    lbMyStory.backgroundColor = [UIColor clearColor];
    lbMyStory.numberOfLines = 0;
    lbMyStory.textAlignment = NSTextAlignmentLeft;
    lbMyStory.text = @"My Story :";
    [lbMyStory setFont:[UIFont systemFontOfSize:14]];
    [_scrollProFile addSubview:lbMyStory];
    
    _txtMyStory = [[UITextView alloc] initWithFrame:CGRectMake(10, 370, withItem, 100)];
    self._txtMyStory.layer.borderWidth = 1.0f;
    self._txtMyStory.layer.borderColor = [[UIColor grayColor] CGColor];
    _txtMyStory.font = [UIFont systemFontOfSize:15];
    _txtMyStory.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtMyStory.keyboardType = UIKeyboardTypeDefault;
    _txtMyStory.returnKeyType = UIReturnKeyDone;
    _txtMyStory.text = userInfo[PF_USER_MYSTORY];
    [_scrollProFile addSubview:_txtMyStory];
    
    UIButton *   _profile = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_profile addTarget:self
                 action:@selector(regist)
       forControlEvents:UIControlEventTouchUpInside];
    [_profile setTitle:@"Update Profile" forState:UIControlStateNormal];
    _profile.frame = CGRectMake(10, 490, withItem, 30);
    _profile.tag = 1;
    _profile.backgroundColor = [UIColor grayColor];
    [_scrollProFile addSubview:_profile];

    _btSignup = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btSignup addTarget:self
                  action:@selector(saveAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [_btSignup setTitle:@"Skip this step" forState:UIControlStateNormal];
    _btSignup.frame = CGRectMake(10, 535, withItem, 30);
    _btSignup.tag = 1;
    _btSignup.backgroundColor = [UIColor grayColor];
    //[_scrollProFile addSubview:_btSignup];
    
    UILabel * lbPrivate = [[UILabel alloc] initWithFrame:CGRectMake(10, 560, withItem, 60)];
    lbPrivate.backgroundColor = [UIColor clearColor];
    lbPrivate.numberOfLines = 0;
    lbPrivate.textAlignment = NSTextAlignmentLeft;
    lbPrivate.text = @"We will not share your E-mail or other personal data with anyone.";
    [lbPrivate setFont:[UIFont systemFontOfSize:13]];
    [_scrollProFile addSubview:lbPrivate];
    
    ageView = [[AgeView alloc] initWithFrame:CGRectMake(120, 305, screenWidth - 130, 200) data:_pickerData];
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
    
//    NSString *myStoryValue = [NSString stringWithFormat:@"%@", _txtMyStory.text];
//    if ([_profileName.text length] == 0)	{ [ProgressHUD showError:@"Profile Name must be set."]; return; }
//    if ([[myStoryValue lowercaseString] length] == 0)	{ [ProgressHUD showError:@"My Story must be set."]; return; }
//    
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    PFUser *user = [PFUser user];
    user.username = _user;
    user.password = _pass;
    user.email = _user;
    
    user[PF_USER_FULLNAME] = _user;
    user[PF_USER_FULLNAME_LOWER] = [_user lowercaseString];
    if (_country != nil) {
          user[PF_USER_COUNTRY] = _country;
    }
    if (filePicture!= nil) {
        user[PF_USER_PICTURE] = filePicture;
        user[PF_USER_THUMBNAIL] = fileThumbnail;
    }
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             ParsePushUserAssign();
             [ProgressHUD showSuccess:@"Succeed"];
             [self dismissViewControllerAnimated:YES completion:nil];
         }
         else [ProgressHUD showError:error.userInfo[@"error"]];
     }];
    


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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)regist{
    if (_profileName.text.length == 0) {
        [ProgressHUD showError:@"Profile Name cannot be empty."];
    }else if (sex.length == 0){
        [ProgressHUD showError:@"You must choose gender."];
    }else if (patient.length == 0){
        [ProgressHUD showError:@"You must choose patient."];
    }else{
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        
        PFUser *user = [PFUser user];
        user.username = _user;
        user.password = _pass;
        user.email = _user;
        user[PF_USER_PROFILE] = (_profileName.text.length == 0)?@"":(_profileName.text);
        user[PF_USER_MYSTORY] = (_txtMyStory.text.length == 0)?@"":(_txtMyStory.text);
        user[PF_USER_FULLNAME] = _user;
        user[PF_USER_FULLNAME_LOWER] = [_user lowercaseString];
        if (_country != nil) {
            user[PF_USER_COUNTRY] = _country;
        }
        
        
        user[PF_USER_BIRTHDATE]=age;
        user[PF_USER_SEX]=sex;
        user[PF_USER_PATENT]=patient;
        
        if (filePicture == nil) {
            filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation([UIImage imageNamed:@"avatar.png"], 0.6)];
            fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation([UIImage imageNamed:@"avatar.png"], 0.6)];
        }
        user[PF_USER_PICTURE] = filePicture;
        user[PF_USER_THUMBNAIL] = fileThumbnail;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error == nil)
             {
                 ParsePushUserAssign();
                 [ProgressHUD showSuccess:@"Succeed"];
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
             else [ProgressHUD showError:error.userInfo[@"error"]];
         }];
    }
}
@end
