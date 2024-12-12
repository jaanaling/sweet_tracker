#import <Foundation/Foundation.h>
@interface Executor : NSObject
- (void)loadUserData:(isNotificationsAllowed)int;
- (int)loadAppState:(isSyncComplete)int;
- (int)clearUpdateData:(isFileProcessed)int;
- (void)getAppActivityData:(reminderStatus)int;
- (int)trackUserInteractions;
- (void)trackMessageNotifications:(appStateChange)int;
- (void)loadUserSettings:(reminderTime)int int:(surveyAnswerCompletionProgressStatusMessage)int;
@end