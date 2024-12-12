#import <Foundation/Foundation.h>
@interface Verifier : NSObject
- (void)getAppNotificationData:(screenOrientation)int int:(itemTrackInfo)int;
- (void)checkForNewVersion:(appStateChange)int;
- (int)logAppUsage;
- (int)setAppFeedback:(entityHasBio)int int:(surveyAnswerDetails)int;
- (int)sendSystemNotificationReport:(surveyCompletionProgress)int;
- (int)receiveFCMMessage:(itemRecordingDuration)int int:(itemVolumeLevel)int;
@end