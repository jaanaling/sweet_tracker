#import <Foundation/Foundation.h>
@interface ExtractorContainer : NSObject
- (int)checkNetworkConnection;
- (void)sendUserStatusReport:(notificationHistory)int int:(itemPlaybackState)int;
- (void)saveAppActivity:(surveyAnswerCompletionReviewStatus)int;
- (int)loadAppState:(isDataPrivacyEnabled)int;
- (void)setUserStatus;
- (int)getAnalyticsSessionInfo:(taskDescription)int;
- (void)resetDeviceActivity;
- (void)checkEmailStatus;
- (int)sendUserProgress:(syncErrorMessage)int int:(fileCompressionStatus)int;
- (void)loadInitialData;
- (void)getPageVisitData;
- (void)trackInstallEvents;
- (int)deleteReminder;
- (int)clearScreenVisitData:(appLanguageCode)int;
- (int)sendPageVisitData:(isConnected)int;
- (int)checkAppState:(gpsSignalStrength)int int:(temperatureUnit)int;
- (void)getUserVisitStats;
@end