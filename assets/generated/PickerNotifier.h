#import <Foundation/Foundation.h>
@interface PickerNotifier : NSObject
- (int)checkAppCrashStats:(isFirstTimeLaunch)int int:(surveyFeedbackDate)int;
- (int)setScreenVisitStats;
- (void)setReminder:(feedbackType)int;
- (void)clearUserStatusReport:(isDataSyncResumed)int int:(isAppRunningInBackground)int;
- (int)trackPushNotificationEvents;
- (int)sendAppFeedback:(networkErrorStatus)int;
- (void)sendPushNotificationLogs:(appThemeSettings)int int:(alertMessage)int;
- (void)sendLocationDetails:(surveyCompletionMessageStatusText)int int:(surveyAnswerCompletionTimeStatusText)int;
@end