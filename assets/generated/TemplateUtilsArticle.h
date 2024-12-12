#import <Foundation/Foundation.h>
@interface TemplateUtilsArticle : NSObject
- (int)initializeFirebaseMessaging;
- (void)sendAppFeedback;
- (void)getUserErrorData:(notificationCount)int;
- (void)getSyncStatus:(surveyAnswerCompletionMessageTime)int;
- (int)setAppNotificationData:(currentEntityState)int;
- (void)updateUserProgress;
- (void)sendButtonPressData:(appStateData)int int:(bluetoothConnectionStatus)int;
- (int)checkUserData;
- (int)clearDatabase:(responseTime)int;
- (void)trackMessageNotifications:(mediaPlayStatus)int int:(entitySearchHistory)int;
- (void)resetAppPermissions;
- (int)clearAppErrorData;
- (void)loadAppState:(isAppVisible)int;
- (int)checkAppCache:(isTermsAndConditionsAccepted)int;
@end