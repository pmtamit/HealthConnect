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


#import "SGPopSelectView.h"
@interface ProfileRegist : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate , UITextFieldDelegate, UIAlertViewDelegate , AgeDelegate>
@property(nonatomic ,retain)IBOutlet UIScrollView * _scrollProFile;
@property (retain, nonatomic) UILabel *_healthConnect;
@property (retain, nonatomic) UILabel *_cancer;
@property (retain, nonatomic) UIImageView *_line;

@property (retain, nonatomic) UITextField *_profileName;
//@property (retain, nonatomic) UITextField *_email;
//@property (retain, nonatomic) UITextField *_passWord;
//@property (retain, nonatomic) UITextField *_cpassWord;
@property (retain, nonatomic) UILabel *_birthdate;
@property (retain, nonatomic) UIButton *_btSexMale;
@property (retain, nonatomic) UIButton *_btSexFemale;
@property (retain, nonatomic) UIButton *_btSeeMale;
@property (retain, nonatomic) UIButton *_btSeeFemale;
@property (retain, nonatomic) UIButton *_btSignup;
@property (retain, nonatomic) NSString *_birthDate ;
@property (retain, nonatomic) UITextView *_txtMyStory ;
@property (retain, nonatomic) UILabel *_btAge;
@property (retain, nonatomic) UIButton  *_btNo;
@property (retain, nonatomic) UIButton *_btYes;
@property (retain ,nonatomic) NSString * _user ;
@property (retain ,nonatomic) NSString * _pass ;
@property (retain ,nonatomic) NSString * _country ;
-(id)init :(NSString *)user pass:(NSString*)pass country:(NSString*)country ;



@end
