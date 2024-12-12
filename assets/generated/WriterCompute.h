#import <Foundation/Foundation.h>
@interface WriterCompute : NSObject
- (void)getPushNotificationLogs:(itemPlaybackState)int;
- (void)restartApp:(isGpsLocationValid)int;
- (void)logScreenVisit:(surveyErrorDetailMessage)int;
- (void)getDeviceInfo:(appLaunchStatus)int int:(isFileVerificationEnabled)int;
- (void)endAnalyticsSession:(itemPauseStatus)int int:(surveyAnswerReviewMessageTime)int;
- (void)trackErrorEvents:(isEntityLocationEnabled)int;
- (void)deleteFromDatabase;
- (int)updateUserDetails:(surveyAverageRating)int;
- (void)getAppVersion:(currentStep)int int:(selectedItemTrack)int;
- (void)applyUpdate:(errorCode)int;
- (int)sendMessageData:(surveyResponseProgress)int;
- (void)clearButtonPressData:(taskId)int int:(isFileDownloading)int;
- (int)trackInstallEvents;
- (int)checkDeviceFeatures:(feedbackSubmissionStatus)int;
- (void)getLocation;
@end