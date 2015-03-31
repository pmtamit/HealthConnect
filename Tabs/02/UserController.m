//
//  UserController.m
//  HealthConnect
//
//  Created by John Nguyen on 12/22/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import "UserController.h"
#import "UserViewCell.h"
#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "messages.h"
#import "utilities.h"
#import "UserInfoController.h"
#import "ChatView.h"
#import "DXPopover.h"
#import "FilterView.h"
@interface UserController (){
NSMutableArray *users;
    UIImage *img  ;
    UIRefreshControl *refreshControl;
      DXPopover *popover ;
}
@end

@implementation UserController
@synthesize _tableView ,searchBar ;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_private"]];
        self.tabBarItem.title = @"Users";

        
    }
    return self;
}

- (void)viewDidLoad {
    
    [_tableView registerNib:[UINib nibWithNibName:@"UserViewCell" bundle:nil] forCellReuseIdentifier:@"UserViewCell"];
   _tableView.delegate = self ;
   _tableView.dataSource = self ;
    	self.title = @"Users";

    self._tableView.separatorInset = UIEdgeInsetsZero;
    
    users = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
    img = [[UIImage alloc] init];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadUsers) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreshControl];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter(off)" style:UIBarButtonItemStylePlain target:self action:@selector(Filter:)];
    
    
    if ([PFUser currentUser] != nil)
    {
        [self loadUsers];
    }
    else LoginUser(self);
    [super viewDidLoad];
    popover = [DXPopover popover];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return [users count] ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UserViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"UserViewCell" forIndexPath:indexPath];
    cell._userDelegate = self ;
    PFUser *user = [users objectAtIndex:indexPath.row] ;
    [cell setDataCell:user Longtitude:longitude Latitude:latitude];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
#pragma userDelegate
-(void)UserClick:(id)sender cell:(UserViewCell *)cell{
    NSIndexPath *cellPath = [_tableView indexPathForCell:cell];
    PFUser *object = [users objectAtIndex:cellPath.row];
  
    UserInfoController *userInfo  = [[UserInfoController alloc] init:object];
   userInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfo animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self searchBarCancelled];
}

#pragma mark - User actions

- (void)actionCleanup

{
    [users removeAllObjects];
    [self._tableView reloadData];
}

#pragma mark - Backend methods


- (void)loadUsers{
    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_OBJECTID notEqualTo:[PFUser currentUser].objectId];
    [query orderByAscending:PF_USER_FULLNAME];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [users removeAllObjects];
             [users addObjectsFromArray:objects];
             [self._tableView reloadData];
         }
         else [ProgressHUD showError:@"Network error."];
     }];
     [refreshControl endRefreshing];
}
- (IBAction)Filter:(id)sender{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    UIButton * bt = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth-60,-25,60, 30)];
    FilterView *filter = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    filter.delegate = self;
    [popover showAtView:bt withContentView:filter];

}
-(void)clickFilterwithGender:(NSString *)gender withPatient:(NSString *)patient{
    [ProgressHUD show:@"Progressing..."];
    [popover dismiss];
    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_OBJECTID notEqualTo:[PFUser currentUser].objectId];
    if (gender.length > 0) {
        [query whereKey:PF_USER_SEX equalTo:gender];
    }
    if (patient.length > 0) {
        [query whereKey:PF_USER_PATENT equalTo:patient];
    }
    [query orderByAscending:PF_USER_FULLNAME];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [users removeAllObjects];
             [users addObjectsFromArray:objects];
             [self._tableView reloadData];
             [ProgressHUD dismiss];
         }
         else [ProgressHUD showError:@"Network error."];
     }];
    [refreshControl endRefreshing];
}
@end
