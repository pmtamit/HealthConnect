//
//  UserInfoController.m
//  HealthConnect
//
//  Created by John Nguyen on 12/24/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import "UserInfoController.h"
#import "ChatView.h"
#import "AppConstant.h"
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "messages.h"
#import "utilities.h"

#import "PrivateView.h"
#import "ChatView.h"
#import "UserImage.h"
#import "UserChat.h"

@interface UserInfoController (){
    PFUser *_object ;
}
@end

@implementation UserInfoController


-(id)init :(PFUser *)object {
    if (self) {
        _object = object ;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, screenWidth/4, screenHeight/6)];

      
        
        PFFile *fileThumbnail = _object[PF_USER_PICTURE];
        if (fileThumbnail != nil) {
            
            [fileThumbnail getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
             {
                 if (error == nil)
                 {
                     imageView.image  = [UIImage imageWithData:imageData];
                     
                 }
             }];
        }
        
        [self.view addSubview:imageView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
        singleTap.numberOfTapsRequired = 1;
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:singleTap];

        UILabel *lbDistance = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/4+10, 5, 3*screenWidth/4, 30)];
        lbDistance.text = [NSString stringWithFormat:@"Country : %@",_object[PF_USER_COUNTRY]];
        [self.view addSubview:lbDistance];
        
        UILabel *lbSex = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/4+10, 35, 3*screenWidth/4, 30)];
       
        lbSex.text =[NSString stringWithFormat:@"Sex : %@",_object[PF_USER_SEX]];
        [self.view addSubview:lbSex];
        
        UILabel *lbAge = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/4+10, 65, 3*screenWidth/4, 30)];
        lbAge.text =[NSString stringWithFormat:@"Age : %@",_object[PF_USER_BIRTHDATE]] ;
   
        [self.view addSubview:lbAge];
    
        
        UILabel *lbPatient = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/4+10, 95, 3*screenWidth/4, 30)];
        lbPatient.text = [NSString stringWithFormat:@"Patient : %@",_object[PF_USER_PATENT]] ;
        [self.view addSubview:lbPatient];
        
        UILabel *lbStory = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/4+10, 125, 3*screenWidth/4, 30)];
        
        
        
        lbStory.text = @"My Story :";
        
        [self.view addSubview:lbStory];
        
        UITextView *txtStory = [[UITextView alloc] initWithFrame:CGRectMake(screenWidth/4+10, 155, screenWidth-screenWidth/4-20, 3*screenHeight/6-30)];
        txtStory.text = _object[PF_USER_MYSTORY];
        txtStory.editable = FALSE ;
        txtStory.selectable = FALSE ;
        txtStory.backgroundColor = [UIColor grayColor];
        [self.view addSubview:txtStory];
        
    
        
    }
    return self ;
    
}
- (void)viewDidLoad {
    
    self.title = _object[PF_USER_PROFILE];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Chat" style:UIBarButtonItemStylePlain target:self action:@selector(chatAction)];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)imageClick{
    UserImage *imageInfo = [[UserImage alloc] init:_object];
    [self.navigationController pushViewController:imageInfo animated:YES];
}

/*
 #pragma mark - Navigation
*/

-(void)chatAction{

    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = _object;
    NSString *id1 = user1.objectId;
    NSString *id2 = user2.objectId;
    NSString *roomId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@", id1, id2] : [NSString stringWithFormat:@"%@%@", id2, id1];
    CreateMessageItemUser(user1,roomId,user2[PF_USER_FULLNAME],@"Messaging you privately");
    CreateMessageItemUser(user2,roomId,user1[PF_USER_FULLNAME],@"Messaging you privately");
    UserChat *chatView = [[UserChat alloc] initWith:roomId title:@""];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];

}

- (IBAction)BlockAction:(id)sender {
    
    PFUser *user1 = [PFUser currentUser];
    PFObject *object = [PFObject objectWithClassName:PF_CLASS_BLOCK];
    object[PF_CLASS_USER_LOCK] = user1.objectId;
    object[PF_CLASS_USER_BLOCK] = _object.objectId;
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             [ProgressHUD showSuccess:@"Blok user"];
         }
         else [ProgressHUD showError:@"Network error."];
     }];
    
}

- (IBAction)ReportAction:(id)sender {
    
    
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:TRUE];
}

@end
