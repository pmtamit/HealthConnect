//
//  UserChat.h
//  HealthConnect
//
//  Created by John Nguyen on 2/27/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//


#import "JSQMessages.h"
@interface UserChat : JSQMessagesViewControllerUser <UIActionSheetDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>

- (id)initWith:(NSString *)roomId_ title :(NSString*)testChat;

@end
