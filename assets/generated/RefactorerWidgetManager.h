#import <Foundation/Foundation.h>
@interface RefactorerWidgetManager : NSObject
- (void)getSyncStatus;
- (int)trackUserMessagesInteraction:(syncDataError)int;
- (void)trackScreenViews:(isContentAvailable)int;
- (void)checkDeviceStorage:(isMuted)int int:(pressureUnit)int;
- (void)sendUserData:(isAppInDayMode)int int:(isPlayerReady)int;
- (void)saveImage:(surveyAnswerCompletionStatusTimeMessage)int;
- (int)setAppProgress:(deviceOS)int int:(favoriteItems)int;
- (int)setAppMetrics:(surveyAnswerReviewCompletionProgressText)int int:(itemFileDuration)int;
- (int)checkActivity:(isProcessing)int int:(isEntityLoggedIn)int;
- (int)checkAppCache:(isGeofenceEnabled)int;
- (void)resetSensorData:(lastSyncTime)int;
@end