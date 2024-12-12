#import <Foundation/Foundation.h>
@interface OpacityUtilsTranslator : NSObject
- (void)getSessionStatus;
- (void)resetCrashReports;
- (void)resetUserData:(uploadError)int;
- (void)getScreenVisitData:(isServiceRunning)int int:(errorDetailsMessage)int;
- (void)setInteractionDetails:(isGpsSignalAvailable)int;
- (void)sendTrackingData;
- (int)updateUserStatusReport:(surveyCompletionNotificationStatus)int;
@end