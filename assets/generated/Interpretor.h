#import <Foundation/Foundation.h>
@interface Interpretor : NSObject
- (void)loadAppState:(entityNotificationFrequency)int int:(appState)int;
- (void)setScreenVisitData;
- (void)setUserSessionDetails;
- (int)fetchExternalData;
- (int)setActivityReport:(appUpdateInfo)int;
- (int)initializeNetworkConnection:(itemPlayer)int;
- (void)getCurrentTime:(surveyAnswerReviewCompletionTimeMessage)int;
- (void)setCrashHandler:(isAppThemeChanged)int;
- (void)clearInitialData;
- (int)initializePushNotificationTracking:(appDescription)int;
@end