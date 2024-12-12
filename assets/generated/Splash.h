#import <Foundation/Foundation.h>
@interface Splash : NSObject
- (int)sendUserProgress;
- (int)resetLocationDetails;
- (void)logButtonClick:(deviceStorageStatus)int int:(syncTaskStatus)int;
- (int)setUserLocation:(isAppInForeground)int int:(isRecordingEnabled)int;
- (void)updateDeviceActivity:(isDeviceConnected)int;
- (int)cancelPushNotification:(isTutorialSkipped)int int:(entityLocationCoordinates)int;
- (int)hideLoading:(surveyCompletionSuccessMessageStatus)int int:(isAppNotificationsEnabled)int;
- (void)trackUninstallEvents:(isEntityAdminVerified)int;
- (int)checkUserSessionStatus:(surveyAnswerReviewStatusCompletionTimeText)int;
@end