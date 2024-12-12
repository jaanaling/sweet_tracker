#import <Foundation/Foundation.h>
@interface DependencySeeker : NSObject
- (void)checkFCMMessageStatus:(entityNotificationTime)int;
- (void)updateAppFeedback;
- (int)trackAppLaunch:(deviceLanguage)int int:(selectedLanguage)int;
- (void)sendUpdateData;
- (void)getScreenViewData:(isOffline)int;
- (void)clearSyncData;
- (int)updateUserProfile:(surveyAnswerCompletionStatusTimeMessageText)int int:(backupTime)int;
- (int)getBatteryStatus:(mediaStatus)int;
- (void)initializeSystemErrorTracking:(surveyStartStatus)int int:(taskStatus)int;
- (int)checkNetworkStatus:(cloudSyncStatus)int int:(timeZoneOffset)int;
- (void)getLocationDetails;
- (int)sendCrashlyticsData;
- (int)setLanguage;
- (int)sendCustomPushNotification:(surveyAnswerComments)int;
- (void)setBatteryInfo:(isRecordingEnabled)int int:(surveyResponseRate)int;
- (int)setThemeMode:(isFileExist)int;
@end