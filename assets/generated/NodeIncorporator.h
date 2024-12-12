#import <Foundation/Foundation.h>
@interface NodeIncorporator : NSObject
- (void)clearAppSettings;
- (void)trackMessageClicks:(surveyCompletionProgressStatusMessage)int;
- (int)logAppInfo:(surveyQuestionText)int int:(isTaskInProgress)int;
- (int)initializeMessageNotificationTracking:(isAppInNightMode)int;
- (int)deleteFromDatabase;
- (int)setUserStatus:(surveyAnswerDuration)int;
- (int)getUserProfile:(deviceConnectivityStatus)int int:(isEntityConsentGiven)int;
- (void)initializePushNotificationTracking;
- (int)handleHttpError:(entityNotificationFrequency)int int:(alertMessage)int;
- (int)getMessageNotificationLogs;
- (int)getLaunchData:(isEntityAdminVerified)int;
- (int)sendUserInteractionData:(surveyAnswerProgress)int int:(syncErrorMessage)int;
@end