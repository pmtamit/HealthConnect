//
//  UserImage.m
//  HealthConnect
//
//  Created by John Nguyen on 1/3/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//

#import "UserImage.h"
#import <Parse/Parse.h>
#import "ChatView.h"
#import "AppConstant.h"
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "messages.h"
#import "utilities.h"
#import "PrivateView.h"
#import "UserChat.h"
@interface UserImage (){
    PFUser *_user;
    
}

@end

@implementation UserImage
-(id)init :(PFUser *)user  {
    if (self) {
        _user = user ;
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, screenWidth-10, 3*screenHeight/4)];
        imageView.backgroundColor =[UIColor grayColor];
        [self.view addSubview:imageView];
        
        PFFile *fileThumbnail = _user[PF_USER_PICTURE];
        if (fileThumbnail != nil) {
            
            [fileThumbnail getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
             {
                 if (error == nil)
                 {
                     imageView.image  = [UIImage imageWithData:imageData];
                     
                 }
             }];
        }
        
    }
    return self ;
    
}
- (void)viewDidLoad {
    self.title = _user[PF_USER_PROFILE] ;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Chat" style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(chatAction)];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self
//                                                                             action:@selector(chatAction)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(back)];
    self.navigationItem.backBarButtonItem = backButton;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)back{


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
-(void)chatAction{

    PFUser *user1 = [PFUser currentUser];
    PFUser *user2 = _user;
    NSString *id1 = user1.objectId;
    NSString *id2 = user2.objectId;
    NSString *roomId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@", id1, id2] : [NSString stringWithFormat:@"%@%@", id2, id1];
    CreateMessageItemUser(user1,roomId,user2[PF_USER_FULLNAME],@"Messaging you privately");
    CreateMessageItemUser(user2,roomId,user1[PF_USER_FULLNAME],@"Messaging you privately");
     UserChat *chatView = [[UserChat alloc] initWith:roomId title:@"Messaging you privately"];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
    
}

@end
