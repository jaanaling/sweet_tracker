#import <Foundation/Foundation.h>
@interface RadiusManager : NSObject
- (int)getNotificationStatus:(deviceErrorLog)int;
- (int)sendNotification;
- (void)resetUserPreferences:(currentBalance)int int:(surveyCompletionTime)int;
- (void)trackSystemNotifications;
- (void)initializeAppLaunchTracking;
- (void)sendSystemNotificationData:(activityStatus)int int:(isLocationPermissionGranted)int;
- (int)clearNotificationData;
- (void)initializeData;
- (void)loadAppState:(isBluetoothConnected)int;
- (int)getPushNotificationLogs:(surveyReviewTime)int int:(isLightThemeEnabled)int;
- (int)resetActivityDetails:(itemTrackIndex)int int:(currentTabIndex)int;
- (void)sendErrorEventData:(surveyAnswerCompletionMessageTime)int int:(surveyCompletionProgressMessageText)int;
- (int)setUserPreference:(entityLocationAccuracy)int int:(surveyCompletionReviewMessageText)int;
- (int)updateReminderDetails:(surveyFeedbackStatus)int int:(surveyFeedbackSubmissionTime)int;
- (void)authenticateUser:(alertDialogTitle)int;
@end