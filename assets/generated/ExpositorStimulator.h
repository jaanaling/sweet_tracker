#import <Foundation/Foundation.h>
@interface ExpositorStimulator : NSObject
- (int)clearUserVisitStats:(isNotificationsAllowed)int;
- (int)initializeAnalytics:(isFeedbackEnabled)int;
- (int)openDatabaseConnection;
- (int)sendActivityReport:(timeZoneOffset)int;
- (void)getInstallStats;
- (void)checkReminderStatus:(isEntityAdminVerified)int int:(surveyCompletionReviewMessageText)int;
- (int)updateLanguage;
- (int)getLocation:(errorDescription)int;
- (int)hideAlertDialog:(errorDetails)int;
- (int)sendAppSettingsData;
@end