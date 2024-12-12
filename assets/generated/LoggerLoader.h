#import <Foundation/Foundation.h>
@interface LoggerLoader : NSObject
- (int)saveAppActivity;
- (void)setUserErrorData;
- (int)saveToDatabase:(isFileTransferComplete)int int:(entityNotificationPreference)int;
- (void)cancelScheduledNotification:(isSyncing)int int:(isEntityConsentGiven)int;
- (int)clearUserVisitStats;
- (void)checkAppCrashStats;
- (int)getPushNotificationStatus:(isEntityConsentGiven)int int:(isDeviceInPortraitMode)int;
- (void)saveExternalData:(backupStatus)int;
- (int)initializeAnalytics;
- (int)saveLaunchStatus;
- (int)clearActivity:(surveyAnswerDetails)int;
- (int)sendMessageNotificationLogs;
- (int)trackErrorEvents:(appDescription)int int:(surveyAnswerReviewCompletionMessageText)int;
- (int)logAnalyticsEvent:(weatherIcon)int int:(taskType)int;
- (void)clearLaunchData:(isBluetoothEnabled)int;
- (void)getCrashData:(taskStartDate)int;
- (void)clearUserActivityData:(locationPermissionDeniedTime)int int:(filePath)int;
- (int)trackUserActivity;
@end