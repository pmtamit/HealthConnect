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
#import "messages.h"
#import "pushnotification.h"

#import "ChatView.h"
#import "UserChat.h"
#import "utilities.h"
#import "JSQMessagesKeyboardController.h"
#import "UserInfoController.h"
@interface ChatView()
{
    NSTimer *timer;
    BOOL isLoading;
    
    NSString *roomId;
    NSString *roomName;
    NSMutableArray *users;
    NSMutableArray *messages;
    NSMutableDictionary *avatars;
    JSQMessagesBubbleImage *outgoingBubbleImageData;
    JSQMessagesBubbleImage *incomingBubbleImageData;
    
    JSQMessagesAvatarImage *placeholderImageData;
    NSMutableArray * userChat ;
    Boolean isBackground ;
    CGFloat screenWidth  ;
    CGFloat screenHeight ;
    Boolean isFlow ;
    long index ;

}
@property (strong, nonatomic) JSQMessagesKeyboardController *keyboardController;
@end


@implementation ChatView


- (id)initWith:(NSString *)roomId_

{
    self = [super init];
    roomId = roomId_;
    return self;
}
- (id)initWith:(NSString *)roomId_ RoomName:(NSString *)roomName_{
    self = [super init];
    roomId = roomId_;
    roomName =roomName_ ;
    return self;


}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    application.applicationIconBadgeNumber = 0;
    NSLog(@"userInfo %@",userInfo);
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
    [application setApplicationIconBadgeNumber:10];
    NSLog(@"Badge %d",[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue]);
}
- (void)viewDidLoad

{
    [super viewDidLoad];
    self.title = @"Group";
    self.lbHeader.text =roomName;
    self.lbMessage.text = [self countMessage:roomId];
    [self getLocation:roomId];
    [self getLike];
    
    users = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    avatars = [[NSMutableDictionary alloc] init];
    
    PFUser *user = [PFUser currentUser];
    self.senderId = user.objectId;
    self.senderDisplayName = user[PF_USER_FULLNAME];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    placeholderImageData = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"blank_avatar"] diameter:30.0];
    
    isLoading = NO;
    [self loadMessages];
    userChat = [[NSMutableArray alloc] init];
    ClearMessageCounter(roomId);
    
    isBackground = false ;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Background" style:UIBarButtonItemStylePlain target:self
//                                                                             action:@selector(changeBackground)];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    self.collectionView.backgroundColor = [UIColor clearColor];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",roomId]];
    NSData *pngData1 = [NSData dataWithContentsOfFile:filePath];
      UIImage *image = [UIImage imageWithData:pngData1];
    if (image == nil) {
         image = [UIImage imageNamed:@"background.png"];
    }
     self.view.backgroundColor = [UIColor colorWithPatternImage:ResizeImage(image, screenWidth, screenHeight-100)];
    isFlow = false ;
}

- (NSString *)countMessage:(NSString *)groupId
{
    PFQuery *query = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
    [query whereKey:PF_CHAT_ROOMID equalTo:groupId];
    
    return  [NSString stringWithFormat:@"%ld", (long)[query countObjects]];
}
- (void)getLocation:(NSString *)groupId{
    
    PFQuery *query = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_NAME];
    [query whereKey:PF_USER_OBJECTID equalTo:groupId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
     {
         if (error == nil)
         {
             self.lbLocation.text = object[PF_USER_COUNTRY];
             self.lbHeader.backgroundColor =[Common colorWithHexString:object[PF_CHATROOMS_COLOR_BG]];
             self.lbHeader.textColor =[Common colorWithHexString:object[PF_CHATROOMS_COLOR_TXT]];
         }
         
     }];
}

-(void)getLike{
    
    PFQuery *query = [PFQuery queryWithClassName:PF_LIKE_CLASS_NAME];
    [query whereKey:PF_LIKE_ROOMID equalTo:roomId];
    self.lbLike.text =[NSString stringWithFormat:@"%d",[query countObjects]];
}
- (void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}


- (void)viewWillDisappear:(BOOL)animated

{
    [super viewWillDisappear:animated];
    [timer invalidate];
}

#pragma mark - Backend methods


- (void)loadMessages

{
    if (isLoading == NO)
    {
        isLoading = YES;
        JSQMessage *message_last = [messages lastObject];
        
        PFQuery *query = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
        [query whereKey:PF_CHAT_ROOMID equalTo:roomId];
        if (message_last != nil)
            [query whereKey:PF_CHAT_CREATEDAT greaterThan:message_last.date];
        [query includeKey:PF_CHAT_USER];
        [query orderByDescending:PF_CHAT_CREATEDAT];
        [query setLimit:1000];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error == nil)
             {
                 for (PFObject *object in [objects reverseObjectEnumerator])
                 {
                     [self addMessage:object];
                 }
                 if ([objects count] != 0) [self finishReceivingMessage];
             }
             else [ProgressHUD showError:@"Network error."];
             isLoading = NO;
         }];
    }
    self.lbMessage.text = [NSString stringWithFormat:@"%d",[messages count]];
}


- (void)addMessage:(PFObject *)object

{
    PFUser *user = object[PF_CHAT_USER];
    [users addObject:user];
    
    if (object[PF_CHAT_PICTURE] == nil)
    {
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:user[PF_USER_FULLNAME]
                                                              date:object.createdAt text:object[PF_CHAT_TEXT]];
        [messages addObject:message];
    }
    
    if (object[PF_CHAT_PICTURE] != nil)
    {
        JSQPhotoMediaItem *mediaItem = [[JSQPhotoMediaItem alloc] initWithImage:nil];
        mediaItem.appliesMediaViewMaskAsOutgoing = [user.objectId isEqualToString:self.senderId];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:user[PF_USER_FULLNAME]
                                                              date:object.createdAt media:mediaItem];
        [messages addObject:message];
        //-----------------------------------------------------------------------------------------------------------------------------------------
        PFFile *filePicture = object[PF_CHAT_PICTURE];
        [filePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             if (error == nil)
             {
                 mediaItem.image = [UIImage imageWithData:imageData];
                 [self.collectionView reloadData];
             }
         }];
    }
}


- (void)sendMessage:(NSString *)text Picture:(UIImage *)picture

{
    if (!isFlow) {
            PFQuery *query = [PFQuery queryWithClassName:PF_LIKE_FOLLOW_CLASS_NAME];
            [query whereKey:PF_LIKE_FOLLOW_ROOMID equalTo:roomId];
            [query whereKey:PF_LIKE_FOLLOW_USER equalTo:[PFUser currentUser].objectId];
        if ([query countObjects]==0) {
            PFObject * userObject= [PFObject objectWithClassName:PF_LIKE_FOLLOW_CLASS_NAME];
            userObject[PF_LIKE_FOLLOW_ROOMID] = roomId;
            userObject[PF_LIKE_FOLLOW_USER] = [PFUser currentUser].objectId;
            [userObject saveInBackground];
        }
         CreateMessageItem([PFUser currentUser], roomId, roomName);
         isFlow = true ;
    }
    
    PFFile *filePicture = nil;
    
    if (picture != nil)
    {
        filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 0.6)];
        [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error != nil) NSLog(@"sendMessage picture save error.");
         }];
    }
    
    PFObject *object = [PFObject objectWithClassName:PF_CHAT_CLASS_NAME];
    object[PF_CHAT_USER] = [PFUser currentUser];
    object[PF_CHAT_ROOMID] = roomId;
    object[PF_CHAT_TEXT] = text;
    if (filePicture != nil) object[PF_CHAT_PICTURE] = filePicture;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             [JSQSystemSoundPlayer jsq_playMessageSentSound];
             [self loadMessages];
         }
         else [ProgressHUD showError:@"Network error."];;
     }];
    
    SendPushNotification(roomId, text);
    UpdateMessageCounter(roomId, text);
    
    [self finishSendingMessage];
}

#pragma mark - JSQMessagesViewController method overrides


- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date

{
    [self sendMessage:text Picture:nil];
}


- (void)didPressAccessoryButton:(UIButton *)sender

{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"Take photo", @"Choose existing photo", nil];
    [action showInView:self.view];
}

#pragma mark - JSQMessages CollectionView DataSource


- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    return messages[indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]){
        return outgoingBubbleImageData;
    }
    return incomingBubbleImageData;
}


- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
                    avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath

{
    PFUser *user = users[indexPath.item];
    if (avatars[user.objectId] == nil)
    {
        PFFile *fileThumbnail = user[PF_USER_THUMBNAIL];
        [fileThumbnail getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             if (error == nil)
             {
                 avatars[user.objectId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageWithData:imageData] diameter:30.0];
                 [self.collectionView reloadData];
             }
         }];
        return placeholderImageData;
    }
    else return avatars[user.objectId];
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.item % 3 == 0)
    {
        JSQMessage *message = messages[indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    return nil;
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId])
    {
        return nil;
    }
    
    if (indexPath.item - 1 > 0)
    {
        JSQMessage *previousMessage = messages[indexPath.item-1];
        if ([previousMessage.senderId isEqualToString:message.senderId])
        {
            return nil;
        }
    }
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - UICollectionView DataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    return [messages count];
}


- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId])
    {
        cell.textView.textColor = [UIColor blackColor];
    }
    else
    {
        cell.textView.textColor = [UIColor whiteColor];
    }
    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.item % 3 == 0)
    {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    return 0.0f;
}


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath

{
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]){
        return 0.0f;
    }
    if (indexPath.item - 1 > 0){
        JSQMessage *previousMessage = messages[indexPath.item-1];
        if ([previousMessage.senderId isEqualToString:message.senderId])
        {
            return 0.0f;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events


- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender{
    NSLog(@"didTapLoadEarlierMessagesButton");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView
           atIndexPath:(NSIndexPath *)indexPath{
     index = indexPath.item ;
   id<JSQMessageData> messageItem = [collectionView.dataSource collectionView:collectionView messageDataForItemAtIndexPath:indexPath];
    [self changeBackground];
//    JSQMessage *message = messages[indexPath.item];
//    msSend = [message text];]
   
//    PFUser *user1 = [PFUser currentUser];
//    PFUser *user2 = [users objectAtIndex:indexPath.row];
//    NSString *id1 = user1.objectId;
//    NSString *id2 = [message senderId];
//    NSString *roomUserId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@", id1, id2] : [NSString stringWithFormat:@"%@%@", id2, id1];
//    //---------------------------------------------------------------------------------------------------------------------------------------------
//    CreateMessageItem(user1, roomUserId, user2[PF_USER_FULLNAME]);
//    CreateMessageItem(user2, roomUserId, user1[PF_USER_FULLNAME]);
//    UserChat *_chatView = [[UserChat alloc] initWith:roomUserId title:[message text]];
//    _chatView.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:_chatView animated:YES];
//    //---------------------------------------------------------------------------------------------------------------------------------------------
//    PFQuery *queryRoom = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_ID_USER];
//    [queryRoom whereKey:PF_CHATROOMS_CLASS_ID_ROOM_ID equalTo:roomUserId];
//    [queryRoom whereKey:PF_CHATROOMS_CLASS_ID_USER equalTo:[PFUser currentUser].objectId];
//    if ([queryRoom countObjects]== 0) {
//        PFObject *object = [PFObject objectWithClassName:PF_CHATROOMS_CLASS_ID_USER];
//        object[PF_CHATROOMS_CLASS_ID_ROOM_ID] =roomUserId;
//        object[PF_CHATROOMS_CLASS_ID_HEAHDER] = [message text];
//        object[PF_CHATROOMS_CLASS_ID_USER] = [PFUser currentUser].objectId;
//        [object saveInBackground];
//        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (error == nil) {
//                UserChat *_chatView = [[UserChat alloc] initWith:roomUserId];
//                _chatView.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:_chatView animated:YES];
//            }
//        }];
//    }else{
//        [queryRoom getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//            [object setObject:[message text] forKey:PF_CHATROOMS_CLASS_ID_HEAHDER];
//            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (error == nil) {
//                    UserChat *_chatView = [[UserChat alloc] initWith:roomUserId];
//                    _chatView.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:_chatView animated:YES];
//                }
//            }];
//        }];
//    }
   // [_keyboardController endListeningForKeyboard];
}


- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didTapMessageBubbleAtIndexPath");
}
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation{
    NSLog(@"didTapCellAtIndexPath %@", NSStringFromCGPoint(touchLocation));
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != actionSheet.cancelButtonIndex){

        JSQMessage *message = messages[index];
        PFUser *user1 = [PFUser currentUser];
        PFUser *user2 = [users objectAtIndex:index];
        NSString *id1 = user1.objectId;
        NSString *id2 = [message senderId];
        
        NSString *roomUserId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@", id1, id2] : [NSString stringWithFormat:@"%@%@", id2, id1];
        if (buttonIndex == 0) {
            UserInfoController * user = [[UserInfoController alloc] init:user2];
            [self.navigationController pushViewController:user animated:YES];
        }else if (buttonIndex == 1){
        
            NSString * msSend = [NSString stringWithFormat:@"Messaging you from %@",[message text]];
            CreateMessageItemUser(user1, roomUserId, user2[PF_USER_FULLNAME],msSend);
            CreateMessageItemUser(user2, roomUserId, user1[PF_USER_FULLNAME],msSend);
            UserChat *_chatView = [[UserChat alloc] initWith:roomUserId title:@""];
            _chatView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:_chatView animated:YES];
            
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *picture = info[UIImagePickerControllerEditedImage];
//    PFFile *filePicture ;
    if (isBackground) {
        
        NSData *pngData = UIImagePNGRepresentation(picture);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",roomId]]; //Add the file name
        [pngData writeToFile:filePath atomically:YES];
        
        NSData *pngData1 = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:pngData1];
        self.view.backgroundColor = [UIColor colorWithPatternImage:ResizeImage(image, screenWidth, screenHeight-100)];
        isBackground = false ;
    }else{
        [self sendMessage:@"[Picture message]" Picture:picture];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)changeBackground {
    isBackground = true ;
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"Profile", @"Chat", nil];
    [action showInView:self.view];
}
-(IBAction)LikeAction:(id)sender{
    PFUser *user = [PFUser currentUser];
    NSString *  userId = user.objectId;
    PFQuery *query = [PFQuery queryWithClassName:PF_LIKE_CLASS_NAME];
    [query whereKey:PF_LIKE_ROOMID equalTo:roomId];
     long like = [query countObjects];
    [query whereKey:PF_LIKE_USER equalTo:userId];
  //  int like = [query countObjects];
    if ([query countObjects]!= 0) {
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (!error) {
                NSLog(@"Successfully retrieved %ld scores.", objects.count);
                for (PFObject *object in objects) {
                    [object deleteInBackground];
                }
            }
        }];
        like = like -1 ;
    }else{
        PFObject * userObject= [PFObject objectWithClassName:PF_LIKE_CLASS_NAME];
        userObject[PF_LIKE_USER] = userId;
        userObject[PF_LIKE_ROOMID] = roomId;
        [userObject saveInBackground];
        like = like + 1 ;
    }
    self.lbLike.text = [NSString stringWithFormat:@"%ld",like];
}

@end
