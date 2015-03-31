//
//  UserChat.m
//  HealthConnect
//
//  Created by John Nguyen on 2/27/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//

#import "UserChat.h"
#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "camera.h"
#import "messages.h"
#import "pushnotification.h"


@interface UserChat()
{
    NSTimer *timer;
    BOOL isLoading;
    
    NSString *roomId;
    
    NSMutableArray *users;
    NSMutableArray *messages;
    NSMutableDictionary *avatars;
    
    JSQMessagesBubbleImage *outgoingBubbleImageData;
    JSQMessagesBubbleImage *incomingBubbleImageData;
    
    JSQMessagesAvatarImage *placeholderImageData;
    Boolean isBackground ;
    NSString * _testChat ;
}
@end


@implementation UserChat


- (id)initWith:(NSString *)roomId_ title :(NSString*)testChat

{
    self = [super init];
    roomId = roomId_;
    _testChat = testChat ;
    return self;
}


- (void)viewDidLoad

{
    [super viewDidLoad];
    self.title = @"User";
    users = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    avatars = [[NSMutableDictionary alloc] init];
//   
//    PFQuery *queryRoom = [PFQuery queryWithClassName:PF_CHATROOMS_CLASS_ID_USER];
//    [queryRoom whereKey:PF_CHATROOMS_CLASS_ID_ROOM_ID equalTo:roomId];
//    [queryRoom whereKey:PF_CHATROOMS_CLASS_ID_USER equalTo:[PFUser currentUser].objectId];
//
//    [queryRoom getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
//     {
//         if (error == nil)
//         {
//             self.lbHeader.text = object[PF_CHATROOMS_CLASS_ID_HEAHDER];
//         }
//         
//     }];
    self.lbHeader.text = _testChat;
    PFUser *user = [PFUser currentUser];
    self.senderId = user.objectId;
    self.senderDisplayName = user[PF_USER_FULLNAME];

    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    placeholderImageData = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"blank_avatar"] diameter:30.0];
    isLoading = NO;
    [self loadMessages];
    ClearMessageCounter(roomId);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Background" style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(changeBackground)];
    isBackground = false ;
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


- (void)loadMessages{
    if (isLoading == NO)
    {
        isLoading = YES;
        JSQMessage *message_last = [messages lastObject];
        
        PFQuery *query = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
        [query whereKey:PF_CHAT_ROOMID equalTo:roomId];
        if (message_last != nil) [query whereKey:PF_CHAT_CREATEDAT greaterThan:message_last.date];
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


- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath

{
    return messages[indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath

{
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId])
    {
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


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath

{
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
    if ([message.senderId isEqualToString:self.senderId])
    {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0)
    {
        JSQMessage *previousMessage = messages[indexPath.item-1];
        if ([previousMessage.senderId isEqualToString:message.senderId])
        {
            return 0.0f;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath

{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events


- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender

{
    NSLog(@"didTapLoadEarlierMessagesButton");
}


- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView
           atIndexPath:(NSIndexPath *)indexPath
{
    id<JSQMessageData> messageItem = [collectionView.dataSource collectionView:collectionView messageDataForItemAtIndexPath:indexPath];
    JSQMessage *message = messages[indexPath.item];
    NSLog(@"hoang %d",indexPath.row);
    NSLog(@"hoang %@",[message senderId]);
    NSLog(@"didTapAvatarImageView");
    
    
    
    
    
    
}


- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath

{
    NSLog(@"didTapMessageBubbleAtIndexPath");
    [self.view endEditing:YES];
}


- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation

{
    [self.view endEditing:YES];
    NSLog(@"didTapCellAtIndexPath %@", NSStringFromCGPoint(touchLocation));
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        if (buttonIndex == 0)	ShouldStartCamera(self, YES);
        if (buttonIndex == 1)	ShouldStartPhotoLibrary(self, YES);
    }
}

#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
      UIImage *picture = info[UIImagePickerControllerEditedImage];
    if (isBackground) {
       self.view.backgroundColor = [UIColor colorWithPatternImage:picture];
        isBackground = false ;
    }else{
        [self sendMessage:@"[Picture message]" Picture:picture];
    }
  
     [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)changeBackground{
    isBackground = true ;
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"Take photo", @"Choose existing photo", nil];
    [action showInView:self.view];


}
@end
