#import <Foundation/Foundation.h>
@interface LinkRenovator : NSObject
- (int)sendLocationDetails;
- (void)getSessionData;
- (void)loadLocale:(surveyCompletionNotificationStatus)int;
- (int)verifyNetworkConnection:(isContentAvailable)int;
- (int)checkPushNotificationStatus;
- (void)sendUserNotificationData;
- (int)getSyncStatus;
- (void)clearContent:(fileStatus)int;
- (int)setSensorData:(deviceModelName)int int:(surveyCompletionStatusTime)int;
- (int)sendEventToAnalytics:(isDataLoaded)int;
- (int)fetchHttpRequest:(contentType)int int:(mediaItemIndex)int;
@end