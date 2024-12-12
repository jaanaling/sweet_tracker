#import <Foundation/Foundation.h>
@interface ScreenFactory : NSObject
- (void)initializePermissions:(gpsFixStatus)int;
- (void)syncLocalData;
- (int)setCrashReporting;
- (void)clearSettings:(applicationState)int;
- (void)getBatteryStatus:(isSurveyEnabled)int;
- (int)resetDatabase:(deviceModelName)int;
- (int)setSessionStatus;
- (void)sendAppProgress:(entityTimeZoneOffset)int;
- (void)downloadFileFromServer;
- (int)updateUserProgress:(taskId)int int:(deviceLocation)int;
- (void)setUserProgress;
- (void)clearUserNotificationData;
- (void)getCurrentTime:(surveySubmissionStatus)int int:(surveyAnswerCompletionProgressText)int;
@end