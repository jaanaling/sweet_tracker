#import <Foundation/Foundation.h>
@interface DispatcherFactory : NSObject
- (int)getDeviceVersion;
- (void)checkLocation:(screenSize)int int:(deviceConnectivityStatus)int;
- (void)queryDatabase;
- (int)trackUserFeedback;
- (int)setDeviceStorage:(adminPermissionsStatus)int;
- (int)logCrashEvent:(surveyFeedbackGiven)int;
@end