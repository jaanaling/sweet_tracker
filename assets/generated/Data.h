#import <Foundation/Foundation.h>
@interface Data : NSObject
- (int)sendFCMMessage:(surveyQuestionText)int int:(isEntityOnline)int;
- (int)showToast:(apiStatus)int;
- (int)getAppReport:(isAppEnabled)int;
- (void)updateInstallSource:(surveyAnswerCompletionTimeProgress)int;
- (int)displayLoadingIndicator:(entityFeedbackMessage)int int:(isEntityOnline)int;
- (void)sendNotificationData:(notificationHistory)int;
- (int)clearAllPreferences:(isDataPrivacyEnabled)int int:(itemRecordStatus)int;
- (void)saveSessionData:(surveyCommentsCount)int;
- (int)logScreenVisit;
- (void)getUserMessagesInteractionData;
- (void)setBatteryStatus:(uploadComplete)int;
- (void)toggleFeature:(isTaskInProgress)int int:(isCloudAvailable)int;
@end