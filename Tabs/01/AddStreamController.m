//
//  AddStreamController.m
//  HealthConnect
//
//  Created by John Nguyen on 12/11/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import "AddStreamController.h"
#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "messages.h"
#import "utilities.h"

#import "GroupView.h"
#import "ChatView.h"

#import "DXPopover.h"
#import "CustomColor.h"
#import "Common.h"
#import "camera.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface AddStreamController ()
{
    BOOL bgCheck ;
    BOOL txtCheck ;
    Common *common ;
    NSString *colorBg ;
    NSString *colorTxt ;
    CLLocationCoordinate2D currentCoordinates ;
    NSString *country ;
    CGFloat screenWidth ;
    CGFloat screenHeight ;
    DXPopover *popover ;
    PFFile *filePicture ; ;
}
@end

@implementation AddStreamController
@synthesize _txtAddStream ,btbgrColor ,btImage ,btTextColor ,textBg ,textColor ,textImage ,imageView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    
    CGFloat screenHeight = screenRect.size.height;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(actionSave)];

    
    bgCheck = false  ;
    txtCheck = false ;
    
   
    colorBg = @"#FFFFFF";
    colorTxt = @"#000000";
    common = [[Common alloc] init];
    self._txtAddStream.layer.borderWidth = 1.0f;
     self._txtAddStream.layer.borderColor = [[UIColor grayColor] CGColor];
    self._txtAddStream.returnKeyType = UIReturnKeyDone ;
    self._txtAddStream.delegate = self ;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 65, screenWidth -40, 100)];
    [self.view addSubview:imageView];
    
    textBg = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-200, 70, 150, 40)];
    textBg.backgroundColor = [UIColor clearColor];
    textBg.numberOfLines = 0;
    textBg.textAlignment = NSTextAlignmentRight;
    textBg.text = @"Background Color";
    [self.view addSubview:textBg];
 
    btbgrColor = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btbgrColor addTarget:self
                   action:@selector(_bgrColor:)
       forControlEvents:UIControlEventTouchUpInside];
    [btbgrColor setTitle:@"Back" forState:UIControlStateNormal];
    btbgrColor.frame = CGRectMake(screenWidth-40, 75, 30, 30);
    btbgrColor.tag = 1;
    btbgrColor.backgroundColor =[UIColor grayColor];
    [self.view addSubview:btbgrColor];
    
   textColor = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-200, 110, 150, 40)];
    textColor.backgroundColor = [UIColor clearColor];
    textColor.numberOfLines = 0;
    textColor.textAlignment = NSTextAlignmentRight;
    textColor.text = @"Text Color";
    [self.view addSubview:textColor];
    
    btTextColor = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btTextColor addTarget:self
                    action:@selector(textColor:)
         forControlEvents:UIControlEventTouchUpInside];
    [btTextColor setTitle:@"Text Color" forState:UIControlStateNormal];
    btTextColor.frame = CGRectMake(screenWidth-40, 115, 30, 30);
    btTextColor.tag = 1;
    btTextColor.backgroundColor =[UIColor grayColor];
    [self.view addSubview:btTextColor];
    
    textImage = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-200, 145, 150, 40)];
    textImage.backgroundColor = [UIColor clearColor];
    textImage.numberOfLines = 0;
    textImage.textAlignment = NSTextAlignmentRight;
    textImage.text = @"Add Image";
    [self.view addSubview:textImage];

    btImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btImage addTarget:self
                    action:@selector(addColor)
          forControlEvents:UIControlEventTouchUpInside];
    [btImage setTitle:@"Add Image" forState:UIControlStateNormal];
    btImage.frame = CGRectMake(screenWidth-40, 155, 30, 30);
    btImage.tag = 1;
    btImage.backgroundColor =[UIColor grayColor];
    [self.view addSubview:btImage];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self ;
    [locationManager startUpdatingLocation];
    if (IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
    }
        popover = [DXPopover popover];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)actionSave{
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    PFObject *object = [PFObject objectWithClassName:PF_CHATROOMS_CLASS_NAME];
    
    object[PF_CHATROOMS_NAME] = _txtAddStream.text;
    object[PF_CHATROOMS_COLOR_BG] = colorBg;
    object[PF_CHATROOMS_COLOR_TXT] = colorTxt;
    object[PF_CHATROOMS_LIKE] = @"0";
    object[PF_USER_COUNTRY] = country;
    if (filePicture != nil) {
         object [PF_USER_PICTURE] = filePicture ;
    }
   
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             [ProgressHUD showSuccess:@"Succeed."];
            
         }
         else [ProgressHUD showError:@"Network error."];
     }];
    _txtAddStream.text= @"";
    [locationManager stopUpdatingLocation];
}

- (IBAction)_bgrColor:(id)sender {
  
    bgCheck =true ;
    txtCheck = false ;
    CustomColor *color = [[CustomColor alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    color.colorDelegate = self;
   [popover showAtView:sender withContentView:color];
}

- (IBAction)textColor:(id)sender {
    bgCheck =false ;
    txtCheck = true ;
    CustomColor *color = [[CustomColor alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    color.colorDelegate = self;
    [popover showAtView:sender withContentView:color];
    
}
#pragma mark - colorDelegate
-(void)ColorClick:(id)sender{
   // popover = nil ;
       UIButton *bt = sender ;
    if (bgCheck) {
        colorBg = [common.arrColor objectAtIndex:bt.tag];
        _txtAddStream.backgroundColor = [Common colorWithHexString:colorBg];
    }
    if (txtCheck) {
        colorTxt = [common.arrColor objectAtIndex:bt.tag];
        _txtAddStream.textColor = [Common colorWithHexString:colorTxt];
    }

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
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES ;
}
- (BOOL)textFieldShouldReturn:(UITextView *)theTextField {
    [self actionSave];
        [theTextField resignFirstResponder];
     return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:TRUE];
}
-(void)addColor{
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Choose existing photo", nil];
    
    [action showFromTabBar:[[self tabBarController] tabBar]];
   
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
    image = ResizeImage(image, screenWidth-40, 100);
    imageView.image = image ;
    filePicture = [PFFile fileWithName:@"imageSteam.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
[picker dismissViewControllerAnimated:YES completion:nil];
    
    CGRect lbBgr = [textBg frame];
    lbBgr.origin.y = 185.0f;
    [textBg setFrame:lbBgr];
    
    CGRect btBg = [btbgrColor frame];
    btBg.origin.y = 190.0f;
    [btbgrColor setFrame:btBg];
    
    
    CGRect lbText = [textColor frame];
    lbText.origin.y = 225.0f;
    [textColor setFrame:lbText];
    
    CGRect btText = [btTextColor frame];
    btText.origin.y = 230.0f;
    [btTextColor setFrame:btText];
    
    CGRect lbImage = [textImage frame];
    lbImage.origin.y = 270.0f;
    [textImage setFrame:lbImage];
    
    CGRect btI = [btImage frame];
    btI.origin.y = 275.0f;
    [btImage setFrame:btI];
    
}


@end
