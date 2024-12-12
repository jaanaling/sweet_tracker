#import <Foundation/Foundation.h>
@interface ControllerManager : NSObject
- (int)getFileFromServer;
- (void)initializeMessageNotificationTracking;
- (int)sendNotificationClickData:(surveyQuestionType)int;
- (void)loadImage:(errorDescription)int;
- (void)initializeLocationServices;
- (void)getNotificationData;
- (void)setUserActivityLogs:(isWiFiEnabled)int int:(isEntityLocationEnabled)int;
- (void)getNotificationStatus:(isAppCrashDetected)int;
- (void)clearUserSettings:(gpsLocationAccuracy)int;
@end