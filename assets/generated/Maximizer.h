#import <Foundation/Foundation.h>
@interface Maximizer : NSObject
- (int)setPermissions;
- (int)setUserStatus:(entityHasBio)int;
- (int)getMessageNotificationLogs;
- (void)stopDataSync;
- (void)getAppErrorData;
- (void)logPushNotification;
- (int)logAppError;
- (int)trackAppUpdates:(isAppRunning)int int:(backupStatus)int;
- (int)getAppInstallDetails:(surveyAnswerReviewProgress)int;
- (void)sendActivityReport;
- (void)getDeviceInfo:(surveyAnswerReviewProgress)int;
- (void)sendAppUsageData:(surveyAnswerSubmissionTime)int int:(appPrivacyPolicyStatus)int;
- (int)setBatteryInfo;
- (void)updateLocalData:(totalItems)int int:(geoFenceArea)int;
- (int)getActivityReport:(isSurveyInProgress)int;
- (void)logMessageNotification:(surveyErrorStatusMessage)int;
- (int)clearScreenVisitStats:(entityFeedbackMessage)int int:(geofenceError)int;
- (void)saveAppVersion:(taskProgress)int int:(selectedItem)int;
@end