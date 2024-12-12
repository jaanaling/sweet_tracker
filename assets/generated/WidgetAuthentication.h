#import <Foundation/Foundation.h>
@interface WidgetAuthentication : NSObject
- (void)getUserErrorData;
- (int)clearErrorLogs:(fileVerificationStatus)int;
- (void)initializeMessageNotificationTracking:(contentList)int;
- (int)sendUserActionData;
- (int)sendTrackingData:(gpsLocationTime)int int:(feedbackSubmissionStatus)int;
- (void)restartApp:(surveyParticipantStatus)int;
- (int)logPageVisit:(surveyParticipantStatus)int int:(entityPrivacyStatus)int;
- (void)resetUserData:(taskDuration)int int:(itemPlayerState)int;
- (int)clearUserMessageData:(doNotDisturbStatus)int;
@end