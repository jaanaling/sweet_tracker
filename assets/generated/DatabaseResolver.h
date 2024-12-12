#import <Foundation/Foundation.h>
@interface DatabaseResolver : NSObject
- (void)sendUserActivityReport;
- (void)fetchData;
- (void)clearUserActivityData:(surveyQuestionResponseTime)int int:(isMediaLoaded)int;
- (int)sendLocationDetails:(surveyAnswerStatusMessage)int int:(surveyErrorMessage)int;
- (void)initializePushNotifications:(isEntityAuthenticated)int int:(surveyAnswerCompletionStatusText)int;
- (void)checkPermissions:(isBatteryLow)int;
- (int)trackPageVisits:(surveyAnswerCompletionMessageProgress)int int:(taskProgress)int;
- (int)setInitialData;
- (int)fetchDataFromDatabase:(isDeviceInPowerSavingMode)int;
- (int)clearAppState:(surveyAnswerCompletionProgressMessage)int int:(itemCount)int;
- (int)getDeviceInfo;
- (void)setPushNotificationLogs;
- (int)checkLaunchStatus;
- (void)resumeApp:(surveyAnswerCompletionMessage)int int:(reminderMessage)int;
- (void)logEvent;
@end