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


#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]


#define		PF_INSTALLATION_CLASS_NAME			@"_Installation"		//	Class name
#define		PF_INSTALLATION_OBJECTID			@"objectId"				//	String
#define		PF_INSTALLATION_USER				@"user"					//	Pointer to User Class

#define		PF_USER_CLASS_NAME					@"_User"				//	Class name
#define		PF_USER_OBJECTID					@"objectId"				//	String
#define		PF_USER_USERNAME					@"username"				//	String
#define		PF_USER_PASSWORD					@"password"				//	String
#define		PF_USER_EMAIL						@"email"				//	String
#define		PF_USER_EMAILCOPY					@"emailCopy"			//	String
#define		PF_USER_FULLNAME					@"fullname"
#define		PF_USER_COUNTRY					    @"country"//	String
#define		PF_USER_FULLNAME_LOWER				@"fullname_lower"		//	String
#define		PF_USER_FACEBOOKID					@"facebookId"			//	String
#define		PF_USER_PICTURE						@"picture"				//	File
#define		PF_USER_THUMBNAIL					@"thumbnail"			//	File
#define		PF_USER_BIRTHDATE					@"birthdate"			//	File
#define		PF_USER_SEX                         @"sex"                  //	File
#define		PF_USER_PATENT                      @"patient"                 //	File
#define		PF_USER_PROFILE                     @"profile"
#define		PF_USER_MYSTORY                     @"mystory"
#define		PF_USER_LONGI_TUDE                  @"longitude"
#define		PF_USER_LATI_TUDE                   @"latitude"

#define		PF_CHAT_CLASS_NAME					@"Chat"					//	Class name
#define		PF_CHAT_USER						@"user"
//#define		PF_CHAT_USER						@"GroupChat"					//	Pointer to User Class
#define		PF_CHAT_ROOMID						@"roomId"				//	String
#define		PF_CHAT_TEXT						@"text"					//	String
#define		PF_CHAT_PICTURE						@"picture"				//	File
#define		PF_CHAT_CREATEDAT					@"createdAt"			//	Date

#define		PF_CHATROOMS_CLASS_NAME				@"ChatRooms"
#define		PF_BACKGROUND_CLASS_NAME		    @"Background"
//	Class name
#define		PF_CHATROOMS_NAME					@"name"					//	String
#define		PF_CHATROOMS_LIKE					@"like"					//	String
#define		PF_CHATROOMS_LOCATION				@"location"				//	location
#define		PF_CHATROOMS_COLOR_BG				@"colorbg"				//	color
#define		PF_CHATROOMS_COLOR_TXT				@"colortxt"				//	color
#define		PF_MESSAGES_CLASS_NAME				@"Messages"				//	Class name
#define		PF_MESSAGES_USER					@"userChat"					//	Pointer to User Class
#define		PF_MESSAGES_ROOMID					@"roomId"				//	String
#define		PF_MESSAGES_DESCRIPTION				@"description"			//	String
#define		PF_MESSAGES_LASTUSER				@"lastUser"				//	Pointer to User Class
#define		PF_MESSAGES_LASTMESSAGE				@"lastMessage"			//	String
#define		PF_MESSAGES_COUNTER					@"counter"				//	Number
#define		PF_MESSAGES_UPDATEDACTION			@"updatedAction"		//	Date


#define		NOTIFICATION_APP_STARTED			@"NCAppStarted"
#define		NOTIFICATION_USER_LOGGED_IN			@"NCUserLoggedIn"
#define		NOTIFICATION_USER_LOGGED_OUT		@"NCUserLoggedOut"

//--------------------------------------------------- CONSTANT NEWS ----------------------------------------------------------------------------

#define		NEWS_TITLE                          @"Title"
#define		NEWS_SPLIPT_CONTENT                 @"SplipContent"
#define		NEWS_CONTENT                        @"Content"
//--------------------------------------------------------------- Create class Follow - Like ---------------------------------------------------
#define		PF_LIKE_CLASS_NAME			@"Like"
#define		PF_LIKE_USER                 @"userId"
#define		PF_LIKE_ROOMID               @"roomId"
#define		PF_LIKE_LIKE                 @"like"

#define		PF_USER_LIKE_CLASS			@"UserLike"

#define		PF_FLLOW_CLASS_NAME			@"Flow"
#define		PF_LIKE_FOLLOW_FOLLOW               @"follow"
#define		PF_CLASS_BLOCK                      @"Block"
#define		PF_CLASS_USER_LOCK                  @"userLock"
#define		PF_CLASS_USER_BLOCK                 @"userUnLock"
#define		PF_CLASS_NEW                        @"News"
#define		PF_CLASS_NEW_HEADER                 @"header"
#define		PF_CLASS_NEW_CONTENT                @"Content"

#define		PF_CHATROOMS_CLASS_ID				@"ChatList"
#define		PF_CHATROOMS_CLASS_ID_USER		   @"ChatListUser"

#define		PF_CHATROOMS_CLASS_ID_ROOM_ID		@"roomId"
#define		PF_CHATROOMS_CLASS_ID_HEAHDER		@"header"
#define		PF_CHATROOMS_CLASS_ID_USER		    @"userChat"

#define		PF_BACKGROUNF_ROOM_ID                @"roomId"
#define		PF_BACKGROUNF_ROOM_IMG                @"image"
#define		PF_BACKGROUNF_ROOM_USER                @"userId"
#define		PF_BACKGROUNF_ROOM_ALL                @"all"

#define		PF_LIKE_FOLLOW_CLASS_NAME                @"FLOW"
#define	    PF_LIKE_FOLLOW_ROOMID                    @"roomid"
#define     PF_LIKE_FOLLOW_USER                     @"userid"
