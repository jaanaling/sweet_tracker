#import <Foundation/Foundation.h>
@interface Theme : NSObject
- (void)trackNotificationEvents;
- (int)setReminderStatus:(screenWidth)int;
- (void)setUserActivity:(mediaStatus)int;
- (void)toggleTheme;
- (int)clearActivity:(surveyCompletionRateMessage)int int:(surveyStartStatus)int;
- (int)hideErrorMessage;
- (int)resetDeviceActivity;
- (int)sendUserMessagesInteractionData;
- (int)trackScreenVisit:(isEntityLoggedIn)int int:(itemPlayerState)int;
- (int)setScreenSize:(surveyCompletionStatusTime)int int:(currentSong)int;
- (void)getDeviceOrientation;
- (int)trackDeviceActivity;
- (void)clearMessageData:(itemPauseStatus)int int:(entityNotificationFrequency)int;
- (int)fetchDataFromDatabase:(isDataSyncResumed)int;
- (int)checkNetworkAvailability:(isAppEnabled)int int:(batteryChargingStatus)int;
@end