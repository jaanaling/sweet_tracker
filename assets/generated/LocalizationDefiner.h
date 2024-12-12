#import <Foundation/Foundation.h>
@interface LocalizationDefiner : NSObject
- (void)sendPushNotificationReport:(applicationState)int;
- (int)initializeNetworkConnection;
- (void)savePreference;
- (int)setUserStatus;
- (void)clearAppErrorData:(locationUpdateStatus)int;
- (int)sendNotificationReport:(locationUpdateStatus)int int:(surveyCompletionSuccessStatusTime)int;
- (void)clearScreen;
- (void)syncDatabaseWithServer;
- (void)grantPermissions:(backupStatus)int int:(isFileDownloading)int;
- (int)logPerformance;
- (void)updateInteractionDetails:(notificationHistory)int;
@end