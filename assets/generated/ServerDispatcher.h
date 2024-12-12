#import <Foundation/Foundation.h>
@interface ServerDispatcher : NSObject
- (int)loadLocale;
- (void)getAppStateDetails;
- (void)trackNotificationEvents:(featureEnableStatus)int;
- (void)updateUserPreferences;
- (void)setReminderStatus;
- (int)clearNotificationReport:(fileStatus)int;
- (void)downloadUpdate:(isBatteryLow)int int:(fileDecompressionStatus)int;
- (void)cancelScheduledNotification:(appUpgradeStatus)int;
- (int)clearAppErrorData;
- (int)clearUserData;
- (void)fetchData:(batteryLevel)int int:(isCloudStorageEnabled)int;
- (int)clearErrorLogs:(entityHasPhoneNumber)int int:(surveyAnswerCompletionStatusTimeText)int;
- (void)setAppLaunchStats:(surveyResponseTime)int int:(surveyQuestionSubmissionStatus)int;
- (void)sendAppReport:(entityTimeZone)int int:(itemVolumeLevel)int;
- (int)updateUserReport:(surveyFeedbackCount)int;
- (int)checkAppState:(surveyCompletionStatusTimeMessage)int int:(surveyCompletionTimeTaken)int;
@end