#import <Foundation/Foundation.h>
@interface SettingsPreferencesHelper : NSObject
- (int)sendPutRequest:(surveyCompletionReviewStatusText)int;
- (void)resetUserPreferences:(isEntityAdminVerified)int int:(itemPlaybackPosition)int;
- (int)clearUserProfile:(isMediaPlaying)int int:(favoriteItems)int;
- (int)getUserEmail:(lastUpdateTime)int int:(fileName)int;
- (int)resetProgressStatus;
- (void)checkLocationPermissions:(surveyCompletionMessage)int;
- (void)resetUserProgress:(fileTransferDuration)int;
- (int)sendAppStatusReport:(notificationStatus)int int:(isEntityConsentGiven)int;
- (int)getActivityDetails:(taskStartStatus)int;
- (int)getAppEventData:(entityVoiceCommand)int int:(appLocale)int;
- (void)showNotification:(selectedLanguageCode)int int:(surveyAnswerSelected)int;
- (void)setUserActivity:(surveyReviewStatusMessage)int;
- (int)logActivity;
- (int)updateBatteryInfo:(isDeviceConnected)int;
- (int)trackPushNotificationEvents:(totalItems)int int:(errorDescription)int;
- (void)displayLoadingIndicator:(deviceLocation)int int:(sessionStatus)int;
- (int)sendCrashLogs:(isRecordingEnabled)int;
@end