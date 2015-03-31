//
//  StreamController.m
//  HealthConnect
//
//  Created by John Nguyen on 12/10/14.
//  Copyright (c) 2014 John Nguyen. All rights reserved.
//

#import "StreamController.h"
#import "StreamViewCell.h"
#import "NewViewCell.h"
#import "AddStreamController.h"
#import "ProgressHUD.h"
#import "AppConstant.h"
#import "messages.h"
#import "utilities.h"
#import "ChatView.h"
#import <CoreLocation/CoreLocation.h>
@interface StreamController ()
{
    NSMutableArray *StreamMutab ;
    UIRefreshControl *refreshControl;
    NSString * userId ;
    BOOL isFollow ;
    NSString *likeValue ;
    NSMutableArray *reloadDataFlow ;
    NSMutableArray * dataFlow ;
    NSMutableArray * dataLike ;
}
@property (strong, nonatomic) IBOutlet UITableView *tableStream;
@property (strong, nonatomic) IBOutlet UIView *viewEmpty;

@end

@implementation StreamController
@synthesize tableStream ,kStreamViewDelegate ,slideSwitchH;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_messages"]];
        self.tabBarItem.title = @"Stream";
        isLoading = NO ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
    }
    return self;
}
- (void)actionCleanup{
    [StreamMutab removeAllObjects];
    [self.tableStream reloadData];
}

- (void)viewDidLoad {
    
    [tableStream registerNib:[UINib nibWithNibName:@"StreamViewCell" bundle:nil] forCellReuseIdentifier:@"StreamViewCell"];
    self.tableStream.allowsSelection = YES ;
    
    refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
        [tableStream addSubview:refreshControl];
    StreamMutab = [[NSMutableArray alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionNew)] ;
    
    slideSwitchH=[[SliderSwitch alloc]init];
    
    [slideSwitchH setFrameHorizontal:(CGRectMake(-60, -15, 120, 30)) numberOfFields:2 withCornerRadius:6.0];
    slideSwitchH.delegate=self;
    [slideSwitchH setFrameBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.2 alpha:0.3]];
    
    [slideSwitchH setSwitchFrameColor:[UIColor whiteColor]];
    
    [slideSwitchH setText:@"All" atLabelIndex:1];
    [slideSwitchH setText:@"Follow" atLabelIndex:2];
    [slideSwitchH setSwitchBorderWidth:1.0];
    self.navigationItem.titleView =slideSwitchH ;
    
    
    
    isReLoad = NO ;
    isFollow = NO ;
    tableStream.delegate = self ;
    tableStream.dataSource = self ;
    
    reloadDataFlow = [[NSMutableArray alloc] init];
    dataLike = [[NSMutableArray alloc] init];
    PFUser *user = [PFUser currentUser];
    userId = user.objectId;
    [self refreshTable];
    [super viewDidLoad];
    PFObject * objct ;
    for (int i = 0; i<[StreamMutab count] ; i++) {
        NSMutableArray *  arr = [[NSMutableArray alloc] init];
        objct = [StreamMutab objectAtIndex:i];
        [arr addObject:[self countMessage:objct.objectId]];
        [arr addObject:[self countLike:objct.objectId]];
        [dataLike addObject:arr];
    }
    
}

-(void)switchChangedSliderSwitch:(SliderSwitch *)sliderSwitch{
    [StreamMutab removeAllObjects];
    [tableStream reloadData];
    if (sliderSwitch.selectedIndex==0) {
       [self LoadAllItem];
    } else if (sliderSwitch.selectedIndex==1) {
        [self actionFollowing];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([PFUser currentUser] != nil)
    {
//        [self refreshTable];
    }
    else LoginUser(self);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [StreamMutab count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StreamViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StreamViewCell" forIndexPath:indexPath];
    cell._cellDelegate = self ;
    PFObject *obj = StreamMutab[indexPath.row ] ;
    NSString * mess = [[dataLike objectAtIndex:indexPath.row] objectAtIndex:0] ;
     NSString * like = [[dataLike objectAtIndex:indexPath.row] objectAtIndex:1];
    
    [cell setData:obj userId:userId countMess:mess countLike:like];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFFile *photoFile  =   [StreamMutab objectAtIndex:indexPath.row][PF_USER_PICTURE];
    if (photoFile != nil) {
        return 170 ;
    }else{
        return 100;
    }
}

- (void)actionNew{
    AddStreamController *addNew = [[AddStreamController alloc] init];
    [self.navigationController pushViewController:addNew animated:YES];
}
- (void)actionFollowing{
  
    if (isFollow==NO) {
         [self getFollow];
        isFollow = YES;
    }
   
}

- (void)refreshTable{
    
    PFQuery *query = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
    [query orderByDescending:PF_CHAT_CREATEDAT];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
            [dataLike removeAllObjects] ;
             [StreamMutab removeAllObjects];
             for (PFObject *object in objects)
             {
                 [StreamMutab addObject:object];
                 NSMutableArray *  arr = [[NSMutableArray alloc] init];
               
                 [arr addObject:[self countMessage:object.objectId]];
                 [arr addObject:[self countLike:object.objectId]];
                 [dataLike addObject:arr];
                 isReLoad = YES ;
             }
             
             [self.tableStream reloadData];
         }
         else {
             
             isReLoad = NO ;
         }
     }];
    
    [refreshControl endRefreshing];
    
}

-(void)getFollow{

        [reloadDataFlow removeAllObjects];
        PFQuery *query = [PFQuery queryWithClassName:PF_LIKE_FOLLOW_CLASS_NAME];
        [query whereKey:PF_LIKE_FOLLOW_USER equalTo:userId];
        
        if ([query countObjects]> 0) {
            NSLog(@"hoang %ld",(long)[query countObjects]);
        }
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (error == nil)
            {
                 [dataLike removeAllObjects] ;
                for (PFObject *object in objects){
                    PFQuery *queryRoom = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
                    [queryRoom whereKey:PF_USER_OBJECTID equalTo:object[PF_LIKE_FOLLOW_ROOMID]];
                        [queryRoom findObjectsInBackgroundWithBlock:^(NSArray *objRoom, NSError *error){
                        if (error == nil){
                           
                            for (PFObject *ob in objRoom) {
                               [StreamMutab addObjectsFromArray:objRoom];
                                NSMutableArray *  arr = [[NSMutableArray alloc] init];
                                [arr addObject:[self countMessage:ob.objectId]];
                                [arr addObject:[self countLike:ob.objectId]];
                                [dataLike addObject:arr];

                            }
                            isReLoad = YES ;
                        }
                        [self.tableStream reloadData];
                    }];
                }
            }
        }];
}

#pragma mark - CellDelegate
-(void)DelegateClick:(id)sender cell:(StreamViewCell *)cell{
    
    NSIndexPath *cellPath = [tableStream indexPathForCell:cell];
    PFObject *chatroom = StreamMutab[cellPath.row];
    NSString *roomId = chatroom.objectId;
    ChatView *chatView = [[ChatView alloc] initWith:roomId RoomName:chatroom[PF_CHATROOMS_NAME]];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
    
}
/*
 click cell
 */
-(void)likeActionDelegate:(id)sender cell:(StreamViewCell *)cell{
    long like ;
    NSIndexPath *cellPath = [tableStream indexPathForCell:cell];
    PFObject *object = StreamMutab[cellPath.row];
    PFQuery *query = [PFQuery queryWithClassName:PF_LIKE_CLASS_NAME];
    [query whereKey:PF_LIKE_ROOMID equalTo:object.objectId];
    like = [query countObjects];
    [query whereKey:PF_LIKE_USER equalTo:userId];
    
    if ([query countObjects]!= 0) {
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (error == nil) {
                for (PFObject *object in objects) {
                    [object deleteInBackground];
                }
            }
        }];
        like = like -1 ;
    }else{
        PFObject * userObject= [PFObject objectWithClassName:PF_LIKE_CLASS_NAME];
        userObject[PF_LIKE_USER] = userId;
        userObject[PF_LIKE_ROOMID] = object.objectId;
        [userObject saveInBackground];
        like = like +1 ;
    }
    [cell setlikeValue:[NSString stringWithFormat:@"%ld",like]];
}

-(void)reLoadCell :(StreamViewCell *)cell :(NSString*)obj{
    PFQuery *queryLike = [PFQuery queryWithClassName:PF_LIKE_CLASS_NAME];
    [queryLike whereKey:PF_LIKE_ROOMID equalTo:obj];
    [cell setlikeValue:[NSString stringWithFormat:@"%ld",(long)[queryLike countObjects]]];
    [cell setNeedsDisplay];
}

-(void)LoadAllItem{
    isReLoad = NO ;
    isFollow = NO ;
    [self refreshTable];
}

-(NSString*)getCountLike:(int)index{
    PFUser *user = [PFUser currentUser];
    userId = user.objectId;
    PFObject *object = [StreamMutab objectAtIndex:index] ;
    PFQuery *query = [PFQuery queryWithClassName:PF_LIKE_CLASS_NAME];
    [query whereKey:PF_LIKE_ROOMID equalTo:object.objectId];
    if ([query countObjects]== 0) {
        likeValue = @"0";
    }else{
        likeValue = [NSString stringWithFormat:@"%ld",(long)[query countObjects]];
    }
    return likeValue ;
}

- (NSString *)countMessage:(NSString *)groupId
{
    PFQuery *query = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
    [query whereKey:PF_CHAT_ROOMID equalTo:groupId];
    return  [NSString stringWithFormat:@"%ld", (long)[query countObjects]];
}

- (NSString *)countLike:(NSString *)roomId
{
    PFQuery *query = [PFQuery queryWithClassName:PF_LIKE_CLASS_NAME];
    [query whereKey:PF_CHAT_ROOMID equalTo:roomId];
    return  [NSString stringWithFormat:@"%ld",(long)[query countObjects]];
}



@end
