#import <Foundation/Foundation.h>
@interface ChannelWriter : NSObject
- (void)clearPushNotification;
- (int)getAppReport;
- (int)getAppPermissions:(isAppInStartupState)int;
- (int)sendScreenVisitReport;
- (void)sendDeviceActivity:(fileDownloadStatus)int int:(entityLoginStatus)int;
- (int)getUserProfile:(isEntityAdmin)int;
- (int)updateAppEventData:(feedbackType)int;
@end