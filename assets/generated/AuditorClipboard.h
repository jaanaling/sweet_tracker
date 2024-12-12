#import <Foundation/Foundation.h>
@interface AuditorClipboard : NSObject
- (int)sendScreenViewData:(notificationTime)int int:(selectedItemId)int;
- (int)getAppInfo:(taskCompletionTime)int int:(isOfflineMode)int;
- (void)sendSyncData:(surveyQuestionResponsesCount)int int:(surveyEndDateTime)int;
- (int)setUserActivityLogs;
- (void)clearApiResponse;
- (void)clearAppStatusReport;
- (int)setMessageNotificationData;
- (int)stopLocationTracking;
- (void)getInstallStats;
- (int)revokePermissions:(lastSyncTime)int;
- (void)retrieveDataFromServer:(contentList)int int:(reminderFrequency)int;
- (void)restartApp;
- (void)disableAppPermissions:(surveyCompletionProgress)int;
- (void)getAppState:(isFileDownloading)int;
- (int)sendButtonClickData:(surveyCompletionSuccessTime)int int:(lastUpdateTime)int;
- (void)clearNotification:(entityProgressStatus)int;
- (int)sendCrashlyticsData;
- (int)sendPushNotificationReport:(themePreference)int int:(entityTimeZoneOffset)int;
@end