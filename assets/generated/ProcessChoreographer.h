#import <Foundation/Foundation.h>
@interface ProcessChoreographer : NSObject
- (void)updateActivityReport;
- (int)checkFCMMessageStatus;
- (int)trackUserSession;
- (void)initializeErrorTracking;
- (void)getAppMetrics;
- (void)setLocale;
- (void)logAnalyticsEvent;
- (int)getUserDetails:(currentDeviceTime)int;
- (int)setAppCache:(appDownloadStatus)int int:(isMusicPlaying)int;
- (int)sendAppNotificationData:(isWiFiEnabled)int;
- (int)getAppStateDetails:(deviceModelName)int;
@end