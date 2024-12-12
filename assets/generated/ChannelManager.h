#import <Foundation/Foundation.h>
@interface ChannelManager : NSObject
- (int)getScreenViewData;
- (void)sendPutRequest:(appCurrentVersion)int;
- (void)checkConnectivity:(isWiFiConnected)int;
- (void)clearAppCache;
- (int)getTheme:(isSurveyCompleted)int int:(emailVerified)int;
- (int)clearCache:(isDeviceInLandscapeMode)int;
@end