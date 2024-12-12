#import <Foundation/Foundation.h>
@interface ClockManager : NSObject
- (int)checkNetworkAvailability:(screenOrientation)int int:(entityActionStatus)int;
- (int)logAppNotification;
- (int)clearAppActivity:(gpsSignalStatus)int;
- (void)sendPageVisitData;
- (int)hideLoading:(surveyCompletionStatusMessage)int;
- (int)stopLocationTracking:(syncError)int int:(musicTrackDuration)int;
- (void)scheduleReminder;
- (int)connectToNetwork:(surveyErrorStatus)int;
- (int)checkAppUpdate:(apiEndpoint)int;
- (int)getDeviceModel:(activityStatus)int int:(entityNotificationTime)int;
- (int)initializeAppVersionTracking:(isEntityAuthenticated)int;
- (void)setUserSessionDetails;
- (void)sendCustomPushNotification:(entityPrivacyStatus)int int:(isAppOnTop)int;
- (void)logCrashEvent:(surveyAnswerCompletionReviewStatusMessage)int;
@end