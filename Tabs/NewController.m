//
//  NewController.m
//  HealthConnect
//
//  Created by John Nguyen on 12/10/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import "NewController.h"
#import "NewViewCell.h"
#import "AppConstant.h"
#import "ProgressHUD.h"
#import <Parse/Parse.h>
@interface NewController (){
NSMutableArray *news;
UIRefreshControl *refreshControl;
}

@property (strong, nonatomic) IBOutlet UITableView *tableNews;
@property (strong, nonatomic) IBOutlet UIView *viewEmpty;

@end

@implementation NewController
@synthesize tableNews ,viewEmpty;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_messages"]];
        self.tabBarItem.title = @"News";
        //-----------------------------------------------------------------------------------------------------------------------------------------
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [super viewDidLoad];
    self.title = @"News";

    //---------------------------------------------------------------------------------------------------------------------------------------------
    [tableNews registerNib:[UINib nibWithNibName:@"NewViewCell" bundle:nil] forCellReuseIdentifier:@"NewViewCell"];
    //tableNews.tableFooterView = [[UIView alloc] init];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadNews) forControlEvents:UIControlEventValueChanged];
    [tableNews addSubview:refreshControl];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    news = [[NSMutableArray alloc] init];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    viewEmpty.hidden = YES;
      
    tableNews.delegate = self ;
    tableNews.dataSource = self ;
    [self loadNews];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadNews{

    PFQuery *query = [PFQuery queryWithClassName:PF_CLASS_NEW];
    [query orderByDescending:PF_CHAT_CREATEDAT];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [news removeAllObjects];
             for (PFObject *object in objects)
             {
                 [news addObject:object];
             }
            [ProgressHUD dismiss];
             [self.tableNews reloadData];
         }
         else {
             
            [ProgressHUD showError:@"Network error."];
         }
         
     }];
    [refreshControl endRefreshing];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [news count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    NewViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewViewCell" forIndexPath:indexPath];
    [cell LoadData:news[indexPath.row]];
  // [cell loadNews:news[indexPath.row]];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
// Cell click 
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
